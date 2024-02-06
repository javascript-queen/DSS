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
    	standard_cost DECIMAL(10, 2) NOT null
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


