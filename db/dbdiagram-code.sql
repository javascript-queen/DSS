Table Products {
    product_id INT [primary key]
    brand VARCHAR(255)
    product_line VARCHAR(255)
    product_class VARCHAR(255)
    product_size VARCHAR(255)
}

Table Transactions {
    transaction_id INT [primary key]
    customer_id INT
    transaction_date DATE
    online_order BOOLEAN
    order_status VARCHAR(255)
    product_id INT
    list_price DECIMAL(10, 2)
    standard_cost DECIMAL(10, 2)
}

Table Customers {
  customer_id INT [primary key]
  first_name VARCHAR(255)
  last_name VARCHAR(255)
  gender VARCHAR(1)
  DOB DATE
  job_title_id INT [ref: > Jobs.job_title_id]
  wealth_segment VARCHAR(255)
  deceased_indicator VARCHAR(1)
  owns_car VARCHAR(3)
}

Table Jobs {
  job_title_id INT [primary key]
  job_title VARCHAR(255)
  job_industry_category VARCHAR(255)
}

Table Addresses {
  customer_id INT [ref: > Customers.customer_id]
  address VARCHAR(255)
  postcode VARCHAR(20)
  state VARCHAR(255)
  country_id INT [ref: > Countries.country_id]
  property_valuation INT
}

Table Countries {
  country_id INT [pk]
  country_name VARCHAR(255)
}

Ref: Transactions.customer_id > Customers.customer_id
Ref: Products.product_id < Transactions.product_id
