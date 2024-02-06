## Таблица "Transactions"
  
### 1. НФ1
Давайте начнем с нормализации таблицы до НФ1 (первой нормальной формы). НФ1 требует, чтобы все значения в таблице были атомарными (неделимыми), и чтобы не было повторяющихся групп.

В текущей таблице, кажется, у нас есть повторяющиеся группы в столбцах "brand", "product_line", "product_class", и "product_size". Давайте вынесем эти атрибуты в отдельные таблицы.

Таблица "Products":

product_id | brand            | product_line | product_class | product_size
-----------|------------------|--------------|---------------|--------------
2          | Solex            | Standard     | medium        | medium
3          | Trek Bicycles    | Standard     | medium        | large
37         | OHM Cycles       | Standard     | low           | medium
88         | Norco Bicycles   | Standard     | medium        | medium
78         | Giant Bicycles   | Standard     | medium        | large
25         | Giant Bicycles   | Road         | medium        | medium
22         | WeareA2B         | Standard     | medium        | medium
15         | WeareA2B         | Standard     | medium        | medium
67         | Solex            | Standard     | medium        | large
12         | WeareA2B         | Standard     | medium        | medium
5          | Trek Bicycles    | Mountain     | low           | medium
61         | OHM Cycles       | Standard     | low           | medium
35         | Trek Bicycles    | Standard     | low           | medium
16         | Norco Bicycles   | Standard     | high          | small
12         | Giant Bicycles   | Standard     | medium        | large
3          | Trek Bicycles    | Standard     | medium        | large
79         | Norco Bicycles   | Standard     | medium        | medium
33         | Giant Bicycles   | Standard     | medium        | small
54         | WeareA2B         | Standard     | medium        | medium
25         | Giant Bicycles   | Road         | medium        | medium

Теперь давайте создадим основную таблицу "Transactions" без повторяющихся групп:

transaction_id | customer_id | transaction_date | online_order | order_status | list_price | standard_cost
---------------|-------------|-------------------|--------------|--------------|------------|---------------
1              | 2,950       | 2/25/2017         | False        | Approved     | 71.49      | 53.62
2              | 3,120       | 5/21/2017         | True         | Approved     | 2,091.47   | 388.92
3              | 402         | 10/16/2017        | False        | Approved     | 1,793.43   | 248.82
4              | 3,135       | 8/31/2017         | False        | Approved     | 1,198.46   | 381.10
5              | 787         | 10/1/2017         | True         | Approved     | 1,765.30   | 709.48
6              | 2,339       | 3/8/2017          | True         | Approved     | 1,538.99   | 829.65
7              | 1,542       | 4/21/2017         | True         | Approved     | 60.34      | 45.26
8              | 2,459       | 7/15/2017         | False        | Approved     | 1,292.84   | 13.44
9              | 1,305       | 8/10/2017         | False        | Approved     | 1,071.23   | 380.74
10             | 3,262       | 8/30/2017         | True         | Approved     | 1,231.15   | 161.60
11             | 1,986       | 1/17/2017         | False        | Approved     | 574.64     | 459.71
12             | 2,783       | 1/5/2017          | True         | Approved     | 71.16      | 56.93
13             | 1,243       | 2/26/2017         | True         | Approved     | 1,057.51   | 154.40
14             | 2,717       | 9/10/2017         | False        | Approved     | 1,661.92   | 1,479.11
15             | 247         | 6/11/2017         | False        | Approved     | 1,765.30   | 709.48
16             | 2,961       | 10/10/2017        | False        | Approved     | 2,091.47   | 388.92
17             | 2,426       | 4/3/2017          | False        | Approved     | 1,555.58   | 818.01
18             | 1,842       | 6/2/2017          | False        | Approved     | 1,311.44   | 1,167.18
19             | 2,268       | 4/6/2017          | True         | Approved     | 1,292.84   | 13.44
20             | 3,002       | 1/28/2017         | True         | Approved     | 1,538.99   | 829.65

### 2. НФ2
  
Шаг второй — это приведение ко второй нормальной форме (НФ2). Для этого нам нужно убедиться, что все атрибуты таблицы полностью зависят от первичного ключа. В текущей структуре, кажется, что атрибуты "brand", "product_line", "product_class", и "product_size" зависят от "product_id".

Давайте создадим таблицу "Products" в НФ2:

Таблица "Products":

product_id | brand            | product_line | product_class | product_size
-----------|------------------|--------------|---------------|--------------
2          | Solex            | Standard     | medium        | medium
3          | Trek Bicycles    | Standard     | medium        | large
37         | OHM Cycles       | Standard     | low           | medium
88         | Norco Bicycles   | Standard     | medium        | medium
78         | Giant Bicycles   | Standard     | medium        | large
25         | Giant Bicycles   | Road         | medium        | medium
22         | WeareA2B         | Standard     | medium        | medium
15         | WeareA2B         | Standard     | medium        | medium
67         | Solex            | Standard     | medium        | large
12         | WeareA2B         | Standard     | medium        | medium
5          | Trek Bicycles    | Mountain     | low           | medium
61         | OHM Cycles       | Standard     | low           | medium
35         | Trek Bicycles    | Standard     | low           | medium
16         | Norco Bicycles   | Standard     | high          | small
79         | Norco Bicycles   | Standard     | medium        | medium
33         | Giant Bicycles   | Standard     | medium        | small
54         | WeareA2B         | Standard     | medium        | medium

Теперь давайте создадим основную таблицу "Transactions" в НФ2, используя "product_id" в качестве внешнего ключа:

transaction_id | customer_id | transaction_date | online_order | order_status | product_id | list_price | standard_cost
---------------|-------------|-------------------|--------------|--------------|------------|------------|---------------
1              | 2,950       | 2/25/2017         | False        | Approved     | 2          | 71.49      | 53.62
2              | 3,120       | 5/21/2017         | True         | Approved     | 3          | 2,091.47   | 388.92
3              | 402         | 10/16/2017        | False        | Approved     | 37         | 1,793.43   | 248.82
4              | 3,135       | 8/31/2017         | False        | Approved     | 88         | 1,198.46   | 381.10
5              | 787         | 10/1/2017         | True         | Approved     | 78         | 1,765.30   | 709.48
6              | 2,339       | 3/8/2017          | True         | Approved     | 25         | 1,538.99   | 829.65
7              | 1,542       | 4/21/2017         | True         | Approved     | 22         | 60.34      | 45.26
8              | 2,459       | 7/15/2017         | False        | Approved     | 15         | 1,292.84   | 13.44
9              | 1,305       | 8/10/2017         | False        | Approved     | 67         | 1,071.23   | 380.74
10             | 3,262       | 8/30/2017         | True         | Approved     | 12         | 1,231.15   | 161.60
11             | 1,986       | 1/17/2017         | False        | Approved     | 5          | 574.64     | 459.71
12             | 2,783       | 1/5/2017          | True         | Approved     | 61         | 71.16      | 56.93
13             | 1,243       | 2/26/2017         | True         | Approved     | 35         | 1,057.51   | 154.40
14             | 2,717       | 9/10/2017         | False        | Approved     | 16         | 1,661.92   | 1,479.11
15             | 247         | 6/11/2017         | False        | Approved     | 12         | 1,765.30   | 709.48
16             | 2,961       | 10/10/2017        | False        | Approved     | 3          | 2,091.47   | 388.92
17             | 2,426       | 4/3/2017          | False        | Approved     | 79         | 1,555.58   | 818.01
18             | 1,842       | 6/2/2017          | False        | Approved     | 33         | 1,311.44   | 1,167.18
19             | 2,268       | 4/6/2017          | True         | Approved     | 54         | 1,292.84   | 13.44
20             | 3,002       | 1/28/2017         | True         | Approved     | 25         | 1,538.99   | 829.65

Теперь каждый атрибут в таблице "Products" полностью зависит от первичного ключа "product_id", и мы достигли НФ2.

### 3. НФ3
  
Шаг третий — приведение к третьей нормальной форме (НФ3). В данной нормальной форме каждый неключевой атрибут должен зависеть только от первичного ключа, а не от других неключевых атрибутов.

В таблице "Products" у нас нет зависимости неключевых атрибутов друг от друга, поэтому она уже соответствует НФ3.

Теперь давайте проверим таблицу "Transactions". Видим, что атрибуты "list_price" и "standard_cost" зависят только от первичного ключа "transaction_id" и не зависят друг от друга. Таким образом, эта таблица также соответствует НФ3.

Таким образом, исходная структура данных, после нормализации, соответствует третьей нормальной форме (НФ3).

## Таблица "Customers":

Чтобы преобразовать таблицу в первую, вторую и третью нормальную формы (НФ1, НФ2, НФ3), нужно выполнить несколько шагов. Начнём с описания каждой нормальной формы и определения того, какие действия необходимо предпринять на каждом этапе.

### 1. НФ1
Первая нормальная форма (НФ1):
Условия:
- Таблица должна иметь только уникальные имена столбцов.
- Значения в каждой ячейке таблицы должны быть атомарными (не делимыми).

В предложенной таблице все столбцы имеют уникальные названия и, на первый взгляд, все ячейки содержат атомарные значения. Таким образом, таблица уже соответствует требованиям первой нормальной формы.

### 2. НФ2

Вторая нормальная форма (НФ2):
Условия:
- Таблица должна находиться в НФ1.
- Все не ключевые атрибуты должны зависеть от всего первичного ключа, если он составной.

Первичный ключ в данной таблице - customer_id. Поскольку он неделим (не составной), таблица автоматически соответствует требованиям НФ2.

### 3. НФ3
Третья нормальная форма (НФ3):
Условия:
- Таблица должна находиться в НФ2.
- Не должно быть транзитивных зависимостей между не ключевыми атрибутами.

Для перехода к НФ3 нужно убедиться, что все атрибуты зависят только от customer_id, а не друг от друга. В вашей таблице наблюдается взаимозависимость между такими полями, как address, postcode, state, country, где country всегда будет Australia, и эти поля зависят друг от друга, а не только от customer_id. Также могут быть побочные зависимости в таких полях, как job_title и job_industry_category.

Чтобы соответствовать требованиям НФ3, необходимо разделить таблицу на несколько связанных таблиц. Например:

Таблица "Customers"
- customer_id (PK)
- first_name
- last_name
- gender
- DOB
- job_title_id (FK)
- wealth_segment
- deceased_indicator
- owns_car

Таблица "Jobs"
- job_title_id (PK)
- job_title
- job_industry_category

Таблица "Addresses"
- customer_id (FK)
- address
- postcode
- state
- country_id (FK)
- property_valuation

Таблица "Countries"
- country_id (PK)
- country_name
