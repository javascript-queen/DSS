# Luigi Framework
### Задание:
Написать пайплайн с помощью фреймворка Luigi.

### Порядок действий:
#### Шаг 1
Скачать supplementary-файлы датасета GSE68849 из GEO → cтраница датасета. Архив называется GSE68849_RAW.tar.
Как видим, здесь стандартный endpoint, в который параметром подставляется название датасета.
В задаче на скачивание имя датасета должно быть параметром.
Ссылку на скачивание можно захардкодить, однако, более корректным решением будет выполнить парсинг страницы и найти ссылку там. Выберите вариант, исходя из своих возможностей, баллы за это не будут снижены, так как задание на Luigi, а не на парсинг.
Архив скачивайте в подготовленную для него папку. Структура папок на ваше усмотрение, но имейте ввиду, что она должна, с одной стороны, просто быть прочитана алгоритмом, а с другой — быть понятной для человека.
Скачивать можно с помощью библиотеки wget для Python.
Если нужно запустить какой-то Bash-код, используйте библиотеку subprocess.
#### Шаг 2
После скачивания в папке появится tar-архив, содержимое которого — gzip-заархивированные файлы.
Нужно разархивировать общий архив, узнать, сколько в нём файлов, и как они называются, создать под каждый файл папку и разархивировать его туда.
Имейте в виду, что датасет может быть устроен по-другому. Например, в нём может быть другое количество файлов в архиве, наименования этих файлов также могут отличаться. Чем универсальнее будет пайплайн, тем лучше.
Текстовые файлы представляют собой набор из 4-х tsv-таблиц, каждая из которых обозначена хедером. Хедеры начинаются с символа [. Для удобства каждую таблицу нужно сохранить в отдельный tsv-файл.
Название файла — на ваше усмотрение. Постарайтесь сделать его максимально понятным и лаконичным.
Вы можете написать свой код для разделения таблиц или использовать код ниже:
```
import io

dfs = {}
with open('GPL10558_HumanHT-12_V4_0_R1_15002873_B.txt') as f:
    write_key = None
    fio = io.StringIO()
    for l in f.readlines():
        if l.startswith('['):
            if write_key:
                fio.seek(0)
                header = None if write_key == 'Heading' else 'infer'
                dfs[write_key] = pd.read_csv(fio, sep='\t', header=header)
            fio = io.StringIO()
            write_key = l.strip('[]\n')
            continue
        if write_key:
            fio.write(l)
    fio.seek(0)
    dfs[write_key] = pd.read_csv(fio, sep='\t')
```
В словаре dfs будет содержаться 4 дата фрейма под соответствующими ключами.
#### Шаг 3
Здесь мы видим, что таблица Probes содержит очень много колонок, часть из которых — большие текстовые поля. Помимо полного файла с этой таблицей сохраните также урезанный файл.
Из него нужно убрать следующие колонки: Definition, Ontology_Component, Ontology_Process, Ontology_Function, Synonyms, Obsolete_Probe_Id, Probe_Sequence.
#### Шаг 4
Теперь мы имеем разложенные по папкам tsv-файлы с таблицами, которые удобно читать. Изначальный текстовый файл можно удалить, убедившись, что все предыдущие этапы успешно выполнены.
Важно!

Хорошо продумайте пайплайн: из каких задач он будет состоять, какие параметры, инпуты и аутпуты будут у каждой задачи, каким образом задачи будут зависеть друг от друга.

### Что сдавать:
Для успешной сдачи задания необходимо сдать следующее:
- Файл с кодом пайплайна. Это должен быть запускаемый из консоли файл с расширением .py, в котором прописаны все задачи пайплайна.
- Ссылку на архив с папкой датасета, полученной в результате работы пайплайна. Будет проверяться структура папок и наименование файлов.
### Критерии оценки:
- Распределение задач: задачи атомарны, правильно выстроены последовательность и вызов задач, выполнены все пункты задания — 5 баллов.
- Удобство и универсальность: нет хардкода, в задачах есть параметры (в частности, для названия датасета), код не предполагает специфику конкретного датасета (количество файлов и их названия) — 3 балла.
- Красота кода — 2 балла.
