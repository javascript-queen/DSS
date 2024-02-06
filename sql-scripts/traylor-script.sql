-- Создание таблицы "Products"
CREATE TABLE Products (
	product_id INT primary key,
	brand VARCHAR(255) not null,
	product_line VARCHAR(255) NOT NULL,
	product_class VARCHAR(255) NOT NULL,
	product_size VARCHAR(255) NOT NULL
);

-- Создание таблицы "Transactions"
CREATE TABLE Transactions (
	transaction_id INT PRIMARY KEY,
	customer_id INT NOT NULL,
	transaction_date DATE NOT NULL,
	online_order BOOLEAN NOT NULL,
	order_status VARCHAR(255) NOT NULL,
	product_id INT,
	list_price DECIMAL(10, 2) NOT NULL,
	standard_cost DECIMAL(10, 2) NOT NULL
);

-- Создание таблицы "Customers"
CREATE TABLE Customers (
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	gender VARCHAR(1),
	DOB DATE,
	job_title_id INT,
	wealth_segment VARCHAR(255),
	deceased_indicator VARCHAR(1),
	owns_car VARCHAR(3)
);

-- Создание таблицы "Jobs"
CREATE TABLE Jobs (
	job_title_id INT PRIMARY KEY,
	job_title VARCHAR(255),
	job_industry_category VARCHAR(255)
);

-- Создание таблицы "Addresses"
CREATE TABLE Addresses (
	customer_id INT,
	address VARCHAR(255),
	postcode VARCHAR(20),
	state VARCHAR(255),
	country_id INT,
	property_valuation INT
);

-- Создание таблицы "Countries"
CREATE TABLE Countries (
	country_id INT PRIMARY KEY,
	country_name VARCHAR(255)
);

-- Вставка данных в таблицу "Products"
INSERT INTO Products (product_id, brand, product_line, product_class, product_size)
VALUES
(1, 'Solex', 'Standard', 'medium', 'medium'),
(2, 'Trek Bicycles', 'Standard', 'medium', 'large'),
(3, 'OHM Cycles', 'Standard', 'low', 'medium'),
(4, 'Norco Bicycles', 'Standard', 'medium', 'medium'),
(5, 'Giant Bicycles', 'Standard', 'medium', 'large'),
(6, 'Giant Bicycles', 'Road', 'medium', 'medium'),
(7, 'WeareA2B', 'Standard', 'medium', 'medium'),
(8, 'WeareA2B', 'Standard', 'medium', 'medium'),
(9, 'Solex', 'Standard', 'medium', 'large'),
(10, 'WeareA2B', 'Standard', 'medium', 'medium');

-- Вставка данных в таблицу "Transactions"
INSERT INTO Transactions (transaction_id, customer_id, transaction_date, online_order, order_status, product_id, list_price, standard_cost)
VALUES
(1, 2950, '2017-02-25', FALSE, 'Approved', 2, 71.49, 53.62),
(2, 3120, '2017-05-21', TRUE, 'Approved', 3, 2091.47, 388.92),
(3, 37, '2017-10-16', FALSE, 'Approved', 402, 1793.43, 248.82),
(4, 88, '2017-08-31', FALSE, 'Approved', 3135, 1198.46, 381.10),
(5, 78, '2017-10-01', TRUE, 'Approved', 787, 1765.30, 709.48),
(6, 25, '2017-03-08', TRUE, 'Approved', 2339, 1538.99, 829.65),
(7, 22, '2017-04-21', TRUE, 'Approved', 1542, 60.34, 45.26),
(8, 15, '2017-07-15', FALSE, 'Approved', 2459, 1292.84, 13.44),
(9, 67, '2017-08-10', FALSE, 'Approved', 1305, 1071.23, 380.74),
(10, 12, '2017-08-30', TRUE, 'Approved', 3262, 1231.15, 161.60);

-- Вставка данных в таблицу "Countries"
INSERT INTO Countries (country_id, country_name)
VALUES
(1, 'Australia');

-- Вставка данных в таблицу "Jobs"
INSERT INTO Jobs (job_title_id, job_title, job_industry_category)
VALUES
(1, 'Executive Secretary', 'Health'),
(2, 'Administrative Officer', 'Financial Services'),
(3, 'Recruiting Manager', 'Property'),
(4, 'IT', NULL),
(5, 'Senior Editor', NULL),
(6, 'Retail', NULL),
(7, NULL, 'Financial Services'),
(8, 'Media Manager I', NULL),
(9, 'Business Systems Development Analyst', 'Argiculture'),
(10, 'Senior Quality Engineer', 'Financial Services');

-- Вставка данных в таблицу "Customers"
INSERT INTO Customers (customer_id, first_name, last_name, gender, DOB, job_title_id, wealth_segment, deceased_indicator, owns_car)
VALUES
(1, 'Laraine', 'Medendorp', 'F', '1953-10-12', 1, 'Mass Customer', 'N', 'Yes'),
(2, 'Eli', 'Bockman', 'M', '1980-12-16', 2, 'Mass Customer', 'N', 'Yes'),
(3, 'Arlin', 'Dearle', 'M', '1954-01-20', 3, 'Mass Customer', 'N', 'Yes'),
(4, 'Talbot', NULL, 'M', '1961-10-03', 4, 'Mass Customer', 'N', 'No'),
(5, 'Sheila-kathryn', 'Calton', 'F', '1977-05-13', 5, 'Affluent Customer', 'N', 'Yes'),
(6, 'Curr', 'Duckhouse', 'M', '1966-09-16', 6, 'High Net Worth', 'N', 'Yes'),
(7, 'Fina', 'Merali', 'F', '1976-02-23', 7, 'Affluent Customer', 'N', 'Yes'),
(8, 'Rod', 'Inder', 'M', '1962-03-30', 8, 'Mass Customer', 'N', 'No'),
(9, 'Mala', 'Lind', 'F', '1973-03-10', 9, 'Affluent Customer', 'N', 'Yes'),
(10, 'Fiorenze', 'Birdall', 'F', '1988-10-11', 10, 'Mass Customer', 'N', 'Yes');

-- Вставка данных в таблицу "Addresses"
INSERT INTO Addresses (customer_id, address, postcode, state, country_id, property_valuation)
VALUES
(1, '060 Morning Avenue', '2016', 'New South Wales', 1, 10),
(2, '6 Meadow Vale Court', '2153', 'New South Wales', 1, 10),
(3, '0 Holy Cross Court', '4211', 'QLD', 1, 9),
(4, '17979 Del Mar Point', '2448', 'New South Wales', 1, 4),
(5, '9 Oakridge Court', '3216', 'VIC', 1, 9),
(6, '4 Delaware Trail', '2210', 'New South Wales', 1, 9),
(7, '49 Londonderry Lane', '2650', 'New South Wales', 1, 4),
(8, '97736 7th Trail', '2023', 'New South Wales', 1, 12),
(9, '93405 Ludington Park', '3044', 'VIC', 1, 8),
(10, '44339 Golden Leaf Alley', '4557', 'QLD', 1, 4);
