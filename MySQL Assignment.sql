-- BANKING DATABASE, CUSTOMERS, AND ACCOUNTS

create database banking_db;

use banking_db;

create table customers(
	customer_id int primary key auto_increment,
    name varchar(50),
    city varchar(50)
);

create table accounts(
	account_id int primary key auto_increment,
    customer_id int,
    account_type varchar(20),
    balance decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

show tables;

insert into customers (name, city) values
			("Vipul", "Sangli"),
            ("Abhi", "Pune"),
            ("Rohan", "Mumbai"),
            ("Aditya", "Kolhapur");
            
select * from customers;


insert into accounts (customer_id, account_type, balance) values
(1, "Savings", 50000),
(1, "Current", 20000),
(2, "Savings", 30000),
(3, "Savings", 15000),
(4, "Current", 40000);

select * from accounts;

select * from accounts where balance > 20000;

select * from customers where city = "Sangli";

select * from accounts where balance between 20000 and 50000;

select * from customers where name like "A%";

select * from accounts where account_type = "Savings" or account_type = "Current";

select * from accounts where account_type != "Savings";

select * from customers where name like "%a%";

select * from accounts where balance <= 30000;

select * from customers where city != "Pune";

select * from accounts where balance not between 10000 and 40000;

select * from customers where name like "%i";

select * from accounts where balance = 50000;

select * from customers where city in ("Pune", "Kolhapur");

select * from accounts where balance > 10000 and balance < 40000;

select * from accounts where account_type != "Current";

select * from accounts order by balance desc;

select * from customers order by name asc;

select * from accounts order by account_type asc, balance desc;

-- AGGREGATE FUNCTIONS AND GROUPING

select sum(balance) as total_balance from accounts;

select avg(balance) as average_balance from accounts;

select max(balance) as highest_balance from accounts;

select min(balance) as lowest_balance from accounts;

select count(*) as total_customers from customers;

select account_type, sum(balance) as total_balance from accounts group by account_type;

select account_type, avg(balance) as average_balance from accounts group by account_type;

select account_type, avg(balance) as average_balance from accounts group by account_type having avg(balance) > 20000;

select customer_id, count(*) as total_accounts from accounts group by customer_id;

select customer_id, count(*) as total_accounts from accounts group by customer_id having count(*) > 1;

-- JOINS BETWEEN CUSTOMERS AND ACCOUNTS

select customers.name, accounts.balance from customers inner join accounts on customers.customer_id = accounts.customer_id;

select customers.name, accounts.account_type, accounts.balance from customers left join accounts on customers.customer_id = accounts.customer_id;

select accounts.account_id, customers.name, customers.city, accounts.account_type, accounts.balance from accounts join customers on accounts.customer_id = customers.customer_id;

select customers.name, accounts.account_type, accounts.balance from customers inner join accounts on customers.customer_id = accounts.customer_id where accounts.balance > 20000;

select customers.name, sum(accounts.balance) as total_balance from customers inner join accounts on customers.customer_id = accounts.customer_id group by customers.customer_id, customers.name;

select customers.name, accounts.balance from customers inner join accounts on customers.customer_id = accounts.customer_id order by accounts.balance asc;

select customers.city, count(accounts.account_id) as total_accounts from customers inner join accounts on customers.customer_id = accounts.customer_id group by customers.city;

-- SUBQUERIES

select * from accounts where balance > (select avg(balance) from accounts);

select * from customers where customer_id in (select customer_id from accounts);

select * from customers where customer_id not in (select customer_id from accounts);

select * from accounts where balance = (select max(balance) from accounts);

select name from customers where customer_id in (select customer_id from accounts group by customer_id having sum(balance) > 40000);

-- TRAIN AND BOOKING QUERIES

create table trains (
    train_id int primary key auto_increment,
    train_name varchar(50),
    source varchar(50),
    destination varchar(50)
);

create table bookings (
    booking_id int primary key auto_increment,
    train_id int,
    passenger_name varchar(50),
    fare decimal(10,2),
    status varchar(20),
    foreign key (train_id) references trains(train_id)
);

insert into trains (train_name, source, destination) values
("Sahyadri Express", "Pune", "Kolhapur"),
("Deccan Express", 'Mumbai', "Pune"),
("Mahalaxmi Express", "Kolhapur", "Mumbai");

select * from trains;

insert into bookings (train_id, passenger_name, fare, status) values
(1, "Vipul", 500, "Confirmed"),
(1, "Abhi", 500, "Waiting"),
(2, "Rohan", 300, "Confirmed"),
(3, "Aditya", 450, "Cancelled"),
(2, "Omkar", 300, "Confirmed");

select * from bookings;

select * from bookings where fare > 400;

select * from bookings where status != "Confirmed";

select * from trains where source = "Pune";

select * from bookings where fare between 300 and 500;

select * from bookings where passenger_name like "A%";

select trains.train_name, bookings.passenger_name from trains inner join bookings on trains.train_id = bookings.train_id;

select trains.train_name, count(bookings.booking_id) as total_bookings from trains inner join bookings on trains.train_id = bookings.train_id group by trains.train_id, trains.train_name;

select trains.train_name, sum(bookings.fare) as total_fare from trains inner join bookings on trains.train_id = bookings.train_id group by trains.train_id, trains.train_name;

select * from bookings where fare = (select max(fare) from bookings);

select * from trains where train_id in (select train_id from bookings group by train_id having count(*) > 1);

-- EMPLOYEE AGGREGATION AND SORTING

create table Employee (
    emp_id int primary key,
    emp_name varchar(50),
    department varchar(30),
    salary decimal(10,2),
    city varchar(30),
    joining_date date
);

insert into Employee values
(101, "Vipul", 'IT', 60000, "Pune", "2022-01-15"),
(102, "Abhi", 'HR', 45000, "Bangalore", "2021-03-10"),
(103, "Rohan", 'IT', 70000, 'Chennai', "2020-07-12"),
(104, "Omkar", 'Finance', 55000, 'Mumbai', "2023-01-20"),
(105, "Swapnil", 'HR', 48000, 'Delhi', "2022-05-05"),
(106, "Aditya", 'Finance', 65000, 'Mumbai', "2021-08-18");

select * from Employee;

select department, count(*) as total_employees from Employee group by department;

select department, avg(salary) as average_salary from Employee group by department;

select department, count(*) as total_employees from Employee group by department having count(*) > 1;

select department, max(salary) as highest_salary from Employee group by department;

select department, min(salary) as lowest_salary from Employee group by department;

select department, avg(salary) as average_salary from Employee group by department having avg(salary) > 50000;

select department, sum(salary) as total_salary from Employee group by department;

select * from Employee order by salary desc;

select * from Employee order by department, salary desc;

select city, count(*) as total_employees from Employee group by city having count(*) > 1;

select city, sum(salary) as total_salary from Employee group by city;

select department, sum(salary) as total_salary from Employee group by department order by total_salary desc;

select department, count(*) as total_employees from Employee where salary > 50000 group by department;

select department, max(salary) - min(salary) as salary_difference from Employee group by department;

select * from Employee order by salary desc limit 3;

-- CUSTOMER ORDERS ANALYSIS

create table Orders (
    order_id int primary key,
    customer_id int,
    amount decimal(10,2),
    order_date date,
    foreign key (customer_id) references Customers(customer_id)
);

insert into Orders (order_id, customer_id, amount, order_date) values
(1, 1, 2500, "2026-10-01"),
(2, 1, 3000, "2026-10-02"),
(3, 1, 1500, "2026-10-03"),
(4, 1, 4000, "2026-10-04"),
(5, 2, 1800, "2026-10-02"),
(6, 2, 2500, "2026-10-05"),
(7, 3, 6000, '2026-10-03'),
(8, 3, 1200, '2026-10-06'),
(9, 4, 3500, '2026-10-04'),
(10, 4, 2200, '2026-10-07');

select * from Orders;

select c.customer_id, c.name,
       sum(o.amount) as total_order_amount
from Customers c
left join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       count(o.order_id) as total_orders
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having count(o.order_id) > 3;

select c.customer_id, c.name,
       avg(o.amount) as average_order_amount
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       max(o.amount) as highest_order_amount
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       sum(o.amount) as total_purchase_amount
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_purchase_amount desc;

select c.customer_id, c.name,
       sum(o.amount) as total_purchase_amount
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having sum(o.amount) > 10000;

select c.customer_id, c.name,
       count(o.order_id) as total_orders
from Customers c
left join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       count(o.order_id) as total_orders
from Customers c
left join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       count(o.order_id) as total_orders
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_orders desc
limit 1;

select c.customer_id, c.name,
       avg(o.amount) as average_order_amount
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having avg(o.amount) > 2000;

select c.customer_id, c.name,
       sum(o.amount) as total_purchase
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_purchase desc
limit 5;

select c.customer_id, c.name,
       min(o.amount) as minimum_order
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       sum(o.amount) as total_purchase
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having sum(o.amount) > 5000;

select c.customer_id, c.name,
       count(o.order_id) as total_orders,
       sum(o.amount) as total_purchase
from Customers c
left join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name;

select c.customer_id, c.name,
       count(o.order_id) as total_orders,
       sum(o.amount) as total_purchase
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having count(o.order_id) > 2
   and sum(o.amount) > 8000;
   
-- STUDENT MARKS AND DEPARTMENT ANALYSIS

create table Students (
    student_id int primary key,
    student_name varchar(50),
    department varchar(30),
    marks int
);

insert into Students (student_id, student_name, department, marks) values
(1, "Vipul", "IT", 85),
(2, "Abhi", "IT", 72),
(3, "Rohan", "IT", 90),
(4, "Aditya", "IT", 65),
(5, "Omkar", "IT", 78),
(6, "Sneha", "IT", 88),
(7, "Priya", "HR", 92),
(8, "Amit", "HR", 75),
(9, "Neha", "HR", 80),
(10, "Pooja", "HR", 68),
(11, "Rahul", "Finance", 95),
(12, "Kiran", "Finance", 82),
(13, "Sahil", "Finance", 70),
(14, "Meena", "Finance", 87),
(15, "Anjali", "Finance", 76),
(16, "Sagar", "Sales", 60),
(17, "Riya", "Sales", 73),
(18, "Nikhil", "Sales", 89);

select * from Students;
   
select department, avg(marks) as average_marks from Students group by department;

select department, avg(marks) as average_marks from Students group by department having avg(marks) > 75;

select department, max(marks) as highest_marks from Students group by department;

select department, count(*) as total_students from Students group by department;

select department, count(*) as total_students from Students group by department having count(*) > 5;

select department, avg(marks) as average_marks from Students group by department order by average_marks desc;

select department, avg(marks) as average_marks from Students group by department order by average_marks desc limit 3;

select department, avg(marks) as average_marks from Students group by department having avg(marks) between 70 and 90;

select department, sum(marks) as total_marks from Students group by department;

select department, count(*) as total_students from Students group by department order by total_students desc;

select department, min(marks) as lowest_marks from Students group by department;

select department, max(marks) as highest_marks from Students group by department having max(marks) > 90;

select department, count(*) as total_students from Students where marks > 80 group by department;

select department, count(*) as total_students from Students where marks > 75 group by department having count(*) > 3;

select department, max(marks) as highest_marks from Students group by department order by highest_marks desc;
