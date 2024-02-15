-- Создать новую базу, чтобы не путать задания
-- create database postgres_hw2;

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

-- Добавляем данные из csv в таблицы при помощи методов DBeaver

-- (1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов
select distinct brand
from transaction_20240101
where standard_cost > 1500;

-- (1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно
select *
from transaction_20240101 t 
where (to_date(transaction_date, 'DD.MM.YYYY')  between '2017-04-01' and '2017-04-09') and (order_status = 'Approved');

-- (1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'
select job_title
-- или без повторов:
-- select distinct job_title
from customer_20240101
where (job_industry_category in ('IT', 'Financial Services')) and (job_title like 'Senior%'); 

-- (1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
select brand
-- или без повторов:
-- select distinct brand
from customer_20240101 c
join transaction_20240101 t ON c.customer_id = t.customer_id
where c.job_industry_category = 'Financial Services';

-- (1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'
select c.customer_id, c.first_name, c.last_name, t.brand  
from customer_20240101 c 
join transaction_20240101 t ON c.customer_id = t.customer_id
where (t.online_order = 'True') and (t.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'))
limit 10;

-- (1 балл) Вывести всех клиентов, у которых нет транзакций
select c.customer_id, c.first_name, c.last_name, t.transaction_id
from customer_20240101 c 
left join transaction_20240101 t ON c.customer_id = t.customer_id
where t.transaction_id is null;

-- (2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью
select t.customer_id, c.first_name, c.last_name  
from transaction_20240101 t 
inner join customer_20240101 c on t.customer_id = c.customer_id
where (c.job_industry_category = 'IT') and (t.standard_cost = (select max(standard_cost) from transaction_20240101));

-- (2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'
-- без повторов:
select distinct c.customer_id, c.first_name, c.last_name
from customer_20240101 c 
left join transaction_20240101 t on c.customer_id = t.customer_id 
where (c.job_industry_category in ('IT', 'Health')) 
and (to_date(t.transaction_date, 'DD.MM.YYYY') between '2017-07-07' and '2017-07-17')
and (t.order_status = 'Approved');
