-- Создаём шаблон таблицы customers
CREATE TABLE customer_20240101 (
	customer_id INT4 PRIMARY key NOT NULL, 
	first_name VARCHAR(50) NULL, 
	last_name VARCHAR(50) NULL, 
	gender VARCHAR(30) NULL,
	DOB VARCHAR(50) NULL,
	job_title VARCHAR(50) NULL, 
	job_industry_category VARCHAR(50) NULL, 
	wealth_segment VARCHAR(50) NULL, 
	deceased_indicator VARCHAR(50) NULL, 
	owns_car VARCHAR(30) NULL, 
	address VARCHAR(50) NULL, 
	postcode VARCHAR(30) NULL, 
	state VARCHAR(30) NULL, 
	country VARCHAR(30) NULL, 
	property_valuation INT4 NULL
);

-- Создаём шаблон таблицы transactions
CREATE TABLE transaction_20240101 ( 
	transaction_id INT4 PRIMARY key NOT NULL, 
	product_id INT4 NOT NULL, 
	customer_id INT4 NOT NULL, 
	transaction_date VARCHAR(30) NOT NULL, 
	online_order varchar(30) NULL,
	order_status VARCHAR(30) NOT NULL,
	brand VARCHAR(30) NULL,
	product_line VARCHAR(30) NULL, 
	product_class VARCHAR(30) NULL,
	product_size VARCHAR(30) NULL, 
	list_price FLOAT4 NOT NULL, 
	standard_cost FLOAT4 NULL
);

-- 1. Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)

select job_industry_category, count(customer_id) AS customer_count
from customer_20240101
group by job_industry_category
order by customer_count desc;

-- 2. Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
select c.job_industry_category, sum(list_price) as total_transaction_amount, extract(month from to_date(transaction_date, 'DD.MM.YYYY')) as transaction_month
from transaction_20240101 t
join customer_20240101 c on t.customer_id = c.customer_id
group by transaction_month, c.job_industry_category
order by transaction_month, c.job_industry_category;

-- 3. Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)
select count(*), t.brand
from transaction_20240101 t 
join customer_20240101 c on t.customer_id = c.customer_id
where (t.order_status = 'Approved') and (t.online_order = 'True') and (c.job_industry_category = 'IT')
group by t.brand;

-- 4. Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат 
-- по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только оконные функции. 
-- Сравните результат. — (2 балла)

-- 4a. Используя только GROUP BY
select customer_id, sum(list_price), max(list_price), min(list_price), count(*)
from transaction_20240101 t 
group by customer_id 
order by sum(list_price) desc, count(transaction_id) desc

-- 4b. Используя только оконные 
select t.customer_id, 
        sum(t.list_price) over (partition by customer_id) as t_sum, 
        max(t.list_price) over (partition by customer_id) as t_max, 
        min(t.list_price) over (partition by customer_id) as t_min,
        count(t.list_price) over (partition by customer_id) as t_cnt  
from transaction_20240101 t 
order by t_sum desc, t_cnt desc 

/*Первый запрос использует только GROUP BY, чтобы сгруппировать данные по customer_id, а затем применяет агрегатные функции (SUM, MAX, MIN, COUNT). Это приводит к 
 выводу одной строки на каждого клиента, содержащей сумму, максимум, минимум и количество транзакций для каждого клиента.

Второй запрос также работает с каждым клиентом, но использует оконные функции, чтобы вычислить агрегатные функции (SUM, MAX, MIN, COUNT) для каждой строки 
в результате, не группируя строки по customer_id. Затем он убирает дубликаты с помощью DISTINCT. Это также приводит к выводу одной строки на каждую транзакцию, 
но с повторяющимися данными о клиенте для каждой транзакции.

Вот почему результаты могут выглядеть по-разному: первый запрос дает сводные данные по клиентам, в то время как второй запрос дает информацию по каждой транзакции, 
повторяя данные о клиенте для каждой транзакции. Оба варианта имеют свои преимущества и недостатки, в зависимости от того, что требуется в конкретном случае. 
Если нужна агрегированная информация по клиентам, то предпочтительнее использовать первый запрос. Если же нужна информация по каждой транзакции с данными о 
клиенте для каждой из них, то второй запрос более подходящий.*/

-- 5. Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). 
-- Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)
-- 5a. MIN
select c.first_name, c.last_name, SUM(t.list_price) as total_sum
from transaction_20240101 t
join customer_20240101 c on t.customer_id = c.customer_id
group by c.customer_id
having SUM(t.list_price) = (
  select MIN(total_sum)
  FROM (
    SELECT customer_id, SUM(list_price) as total_sum
    FROM transaction_20240101
    GROUP BY customer_id
  ) sub
)
limit 1;


-- 5b. MAX
select c.first_name, c.last_name, SUM(t.list_price) as total_sum
from transaction_20240101 t
join customer_20240101 c on t.customer_id = c.customer_id
group by c.customer_id
having SUM(t.list_price) = (
  select MAX(total_sum)
  from (
    select customer_id, SUM(list_price) as total_sum
    from transaction_20240101
    group by customer_id
  ) sub
)
limit 1;

-- 6. Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)
select *
from (
select t.*, row_number() over(
partition by t.customer_id 
order by t.transaction_date asc) as row_num
from transaction_20240101 t)
as first_transactions
where row_num = 1;
-- ORDER BY t.transaction_date ASC упорядочивает транзакции каждого клиента по дате, так что самая ранняя транзакция получит номер 1.

-- 7. Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).
with ranked_transactions as (
  select
    customer_id,
    to_date(transaction_date, 'DD.MM.YYYY') as actual_date,
    lead(to_date(transaction_date, 'DD.MM.YYYY')) over (PARTITION by customer_id order by to_date(transaction_date, 'DD.MM.YYYY')) - TO_DATE(transaction_date, 'DD.MM.YYYY') AS interval_days
  from transaction_20240101
),
max_intervals AS (
  select customer_id, max(interval_days) as max_interval
  from ranked_transactions
  group by customer_id
),
max_interval_global as (
  select max(max_interval) as max_interval
  from max_intervals
)
select c.first_name, c.last_name, c.job_title, max_interval
from customer_20240101 c
join max_intervals mi on c.customer_id = mi.customer_id and mi.max_interval = (select max_interval from max_interval_global);
