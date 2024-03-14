# Перед тем как начать, нужно убедиться, что все пакеты и библиотеки загружены
# Этом можно сделать при помощи pip и виртуального окружения venv через терминал:
# python3 -m venv myenv
# source myenv/bin/activate
# pip install pandas
# pip install luigi
# pip install wget

# Чтобы запустить код, нужно ввести следующую команду:
# python3 my_luigi.py
# или
# python my_luigi.py

# Импорты библиотек
import os
import tarfile
import io
import gzip
import shutil
import luigi
import wget 
import pandas as pd

# Определение именованных констант
DATA_FOLDER = 'data'
GSE_ID = 'GSE68849'
RAW_TAR_FILE = f'{GSE_ID}_RAW.tar'
TSV_FILES_FOLDER = 'tsv_files'
CSV_FILES_FOLDER = 'csv_files'
PROBES_TSV = 'Probes.tsv'
FULL_PROBES_CSV = 'full_probes_data.csv'
TRIMMED_PROBES_CSV = 'trimmed_probes_data.csv'
R1_TXT_FILE = 'GPL10558_HumanHT-12_V4_0_R1_15002873_B.txt.gz'
R2_TXT_FILE = 'GPL10558_HumanHT-12_V4_0_R2_15002873_B.txt.gz'

# ШАГ 1: Создание папки и загрузка файлов
folder_path = DATA_FOLDER

# Проверяем, существует ли папка
if not os.path.exists(folder_path):
    # Создаем папку
    os.makedirs(folder_path)
    print(f'Папка {folder_path} успешно создана')
else:
    print(f'Папка {folder_path} уже существует')

class DownloadSupplementaryFiles(luigi.Task):
    dataset_name = luigi.Parameter(default=GSE_ID)

    def output(self):
        return luigi.LocalTarget(os.path.join(DATA_FOLDER, f'{self.dataset_name}_RAW.tar'))

    def run(self):
        # Ссылка на скачивание
        download_link = f'http://www.ncbi.nlm.nih.gov/geo/download/?acc={self.dataset_name}&format=file'
        # Папка для загрузки
        output_dir = os.path.dirname(self.output().path)
        # Скачивание файла
        wget.download(download_link, out=output_dir)

class ExtractSupplementaryFiles(luigi.Task):
    dataset_name = luigi.Parameter(default=GSE_ID)

    def requires(self):
        return DownloadSupplementaryFiles(self.dataset_name)

    def output(self):
        return luigi.LocalTarget(os.path.join(DATA_FOLDER, self.dataset_name))

    def run(self):
        # Путь к загруженному архиву
        input_path = self.input().path
        # Папка для распаковки
        output_dir = os.path.dirname(self.output().path)
        # Распаковка архива
        with tarfile.open(input_path, 'r') as tar:
            tar.extractall(output_dir)

if __name__ == '__main__':
    luigi.build([ExtractSupplementaryFiles(dataset_name=GSE_ID)], local_scheduler=True)

# ШАГ 2: Разделение файлов и сохранение в нужном формате
def extract_tar_archive(archive_path, output_dir):
    with tarfile.open(archive_path, 'r') as tar:
        tar.extractall(output_dir)

def get_files_info(directory):
    files = []
    for root, _, filenames in os.walk(directory):
        for filename in filenames:
            files.append(os.path.join(root, filename))
    return files

def split_and_save_tables(file_path, output_dir):
    dfs = {}
    with gzip.open(file_path, 'rb') as f:
        write_key = None
        fio = io.TextIOWrapper(f, encoding='utf-8')
        for line in fio:
            if line.startswith('['):
                if write_key:
                    fio.seek(0)
                    header = None if write_key == 'Heading' else 'infer'
                    dfs[write_key] = pd.read_csv(fio, sep='\t', header=header)
                fio = io.StringIO()
                write_key = line.strip('[]\n')
                continue
            if write_key:
                fio.write(line)
        fio.seek(0)
        dfs[write_key] = pd.read_csv(fio, sep='\t')

    for key, df in dfs.items():
        output_path = os.path.join(output_dir, '{}.tsv'.format(key))
        os.makedirs(os.path.dirname(output_path), exist_ok=True)  # Создание папки, если она не существует
        df.to_csv(output_path, sep='\t', index=False)

# Путь к папке с разархивированными файлами
extracted_dir = os.path.join(DATA_FOLDER, GSE_ID)
# Путь к папке, где будут сохранены tsv-файлы
output_dir = os.path.join(DATA_FOLDER, TSV_FILES_FOLDER)

# Разархивировать общий tar-архив
extract_tar_archive(os.path.join(DATA_FOLDER, RAW_TAR_FILE), extracted_dir)

# Получить информацию о файлах
files = get_files_info(extracted_dir)

# Разделить таблицы и сохранить их в формате tsv
for file in files:
    split_and_save_tables(file, output_dir)

# Шаг 3: Обработка данных и сохранение в CSV
# Путь к файлу TSV с данными
probes_tsv_path = os.path.join(DATA_FOLDER, TSV_FILES_FOLDER, PROBES_TSV)

# Загрузить данные из файла TSV в DataFrame
probes_df = pd.read_csv(probes_tsv_path, sep='\t')

# Создать урезанный DataFrame, удалив необходимые столбцы
trimmed_probes_df = probes_df.drop(columns=['Definition', 'Ontology_Component', 'Ontology_Process', 'Ontology_Function', 'Synonyms', 'Obsolete_Probe_Id', 'Probe_Sequence'])

# Создание папки csv внутри папки data
os.makedirs(os.path.join(DATA_FOLDER, CSV_FILES_FOLDER))
# Путь для сохранения CSV файлов
# Путь для папки csv
csv_files_folder = os.path.join(DATA_FOLDER, CSV_FILES_FOLDER)

# Проверка существования папки csv
if not os.path.exists(csv_files_folder):
    # Если папки не существует, создаем её
    os.makedirs(csv_files_folder)

# Сохранить оба DataFrame в файлы CSV
probes_df.to_csv(os.path.join(csv_files_folder, FULL_PROBES_CSV), index=False)
trimmed_probes_df.to_csv(os.path.join(csv_files_folder, TRIMMED_PROBES_CSV), index=False)

# Шаг 4: Удаление исходных текстовых файлов
# Пути к исходным текстовым файлам
r1_txt_path = os.path.join(DATA_FOLDER, R1_TXT_FILE)
r2_txt_path = os.path.join(DATA_FOLDER, R2_TXT_FILE)

# Удалить исходные текстовые файлы, если они существуют
if os.path.exists(r1_txt_path):
    os.remove(r1_txt_path)
    print(f'Файл {r1_txt_path} удален')
else:
    print(f'Файл {r1_txt_path} не найден')

if os.path.exists(r2_txt_path):
    os.remove(r2_txt_path)
    print(f'Файл {r2_txt_path} удален')
else:
    print(f'Файл {r2_txt_path} не найден')