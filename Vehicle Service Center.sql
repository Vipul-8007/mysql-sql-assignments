-- Vehicle Service Center Database

create database vehicle_service_center;

use vehicle_service_center;

create table Customers (
    customer_id int primary key auto_increment,
    customer_name varchar(50),
    phone varchar(15),
    city varchar(30)
);

insert into Customers (customer_name, phone, city)
values
("Vipul", "9876543210", "Pune"),
("Abhi", "9876543211", "Bangalore"),
("Rohan", "9876543212", "Hyderabad"),
("Omkar", "9876543213", "Kolhapur"),
("Swapnil", "9876543214", "Mumbai");

select * from Customers;

create table Vehicles (
    vehicle_id int primary key auto_increment,
    customer_id int,
    vehicle_number varchar(15),
    vehicle_model varchar(50),
    vehicle_type varchar(30),
    foreign key (customer_id)
        references Customers(customer_id)
);

insert into Vehicles
(customer_id, vehicle_number, vehicle_model, vehicle_type)
values
(1, "MH10AB1234", "Hyundai i20", "Car"),
(2, "KA05XY5678", "Honda City", "Car"),
(3, "TS08PQ4321", "Royal Enfield", "Bike"),
(4, "MH09KL9090", "Maruti Swift", "Car"),
(5, "MH12AA1111", "TVS Apache", "Bike");

select * from Vehicles;

create table Mechanics (
    mechanic_id int primary key auto_increment,
    mechanic_name varchar(50),
    specialization varchar(50),
    experience int
);

insert into Mechanics
(mechanic_name, specialization, experience)
values
("Ramesh", "Engine", 10),
("Suresh", "Electrical", 8),
("Mahesh", "General Service", 6),
("Ganesh", "Painting", 12);

select * from Mechanics;

create table Service_Records (
    service_id int primary key auto_increment,
    vehicle_id int,
    mechanic_id int,
    service_type varchar(50),
    service_date date,
    cost decimal(10,2),

    foreign key (vehicle_id)
        references Vehicles(vehicle_id),

    foreign key (mechanic_id)
        references Mechanics(mechanic_id)
);


insert into Service_Records
(vehicle_id, mechanic_id, service_type, service_date, cost)
values
(1, 1, "Engine Repair", "2026-07-10", 8000),
(1, 2, "Electrical Repair", "2026-07-20", 3000),
(2, 3, "General Service", "2026-07-21", 2500),
(3, 1, "Engine Repair", "2026-07-15", 5000),
(4, 3, "General Service", "2026-07-18", 2200),
(5, 2, "Electrical Repair", "2026-06-30", 1800),
(2, 4, "Painting", "2026-07-25", 7000),
(3, 3, "General Service", "2026-07-27", 2000);

select * from Service_Records;

create table Bills (
    bill_id int primary key auto_increment,
    service_id int,
    total_amount decimal(10,2),
    payment_status varchar(20),

    foreign key (service_id)
        references Service_Records(service_id)
);

insert into Bills
(service_id, total_amount, payment_status)
values
(1, 8000, "Paid"),
(2, 3000, "Paid"),
(3, 2500, "Pending"),
(4, 5000, "Paid"),
(5, 2200, "Paid"),
(6, 1800, "Pending"),
(7, 7000, "Paid"),
(8, 2000, "Pending");

select * from Bills;

show tables;

-- Service and Mechanic Reports

select
    vehicle_number,
    vehicle_model,
    service_type,
    service_date
from Vehicles
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
where service_date = curdate();

select
    mechanic_name,
    count(service_id) as Total_Services
from Mechanics
join Service_Records
on Mechanics.mechanic_id = Service_Records.mechanic_id
group by mechanic_name
order by Total_Services desc
limit 1;

-- Customer Billing and Vehicle Service Reports

select
    customer_name,
    sum(total_amount) as Total_Bill
from Customers
join Vehicles
on Customers.customer_id = Vehicles.customer_id
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
join Bills
on Service_Records.service_id = Bills.service_id
group by customer_name;

select
    vehicle_number,
    vehicle_model
from Vehicles
where vehicle_id not in (
    select distinct vehicle_id
    from Service_Records
    where service_date >= date_sub(curdate(), interval 1 year)
);

select
    Vehicles.vehicle_number,
    Service_Records.service_type,
    Service_Records.service_date,
    Service_Records.cost
from Vehicles
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
where Vehicles.vehicle_number = "MH10AB1234"
order by Service_Records.service_date desc;

-- Service Type and Customer Visit Reports

select
    service_type,
    count(*) as Total_Services
from Service_Records
group by service_type;

select
    Customers.customer_name,
    count(Service_Records.service_id) as Total_Visits
from Customers
join Vehicles
on Customers.customer_id = Vehicles.customer_id
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
group by Customers.customer_name
having count(Service_Records.service_id) > 3;

-- Pending Bills and Revenue Reports

select
    Customers.customer_name,
    Vehicles.vehicle_number,
    Service_Records.service_type,
    Bills.total_amount,
    Bills.payment_status
from Customers
join Vehicles
on Customers.customer_id = Vehicles.customer_id
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
join Bills
on Service_Records.service_id = Bills.service_id
where Bills.payment_status = "Pending";

select
    service_type,
    count(*) as Total_Services
from Service_Records
group by service_type
order by Total_Services desc
limit 1;

select
    month(service_date) as Service_Month,
    sum(cost) as Total_Revenue
from Service_Records
group by month(service_date)
order by Service_Month;

select
    month(service_date) as Service_Month,
    sum(cost) as Total_Revenue
from Service_Records
group by month(service_date)
order by Service_Month;

select
    Mechanics.mechanic_name,
    sum(Service_Records.cost) as Total_Revenue
from Mechanics
join Service_Records
on Mechanics.mechanic_id = Service_Records.mechanic_id
group by Mechanics.mechanic_name
order by Total_Revenue desc
limit 1;

-- Customer, Cost, and Mechanic Details

select
    Customers.customer_name,
    count(Vehicles.vehicle_id) as Total_Vehicles
from Customers
join Vehicles
on Customers.customer_id = Vehicles.customer_id
group by Customers.customer_name
having count(Vehicles.vehicle_id) > 1;

select
    avg(cost) as Average_Service_Cost
from Service_Records;

select
    mechanic_name,
    specialization,
    experience
from Mechanics
order by experience desc
limit 1;

select *
from Service_Records
where service_type = "Engine Repair";

select *
from Customers
where city = "Pune";

select
    Mechanics.mechanic_name,
    Service_Records.service_type,
    Service_Records.service_date,
    Service_Records.cost
from Mechanics
join Service_Records
on Mechanics.mechanic_id = Service_Records.mechanic_id
where Mechanics.mechanic_name = "Ramesh";

-- Pending Payment Details and Mechanic Ranking

select
    Customers.customer_name,
    Vehicles.vehicle_number,
    Service_Records.service_type,
    Service_Records.service_date,
    Bills.total_amount,
    Bills.payment_status
from Customers
join Vehicles
on Customers.customer_id = Vehicles.customer_id
join Service_Records
on Vehicles.vehicle_id = Service_Records.vehicle_id
join Bills
on Service_Records.service_id = Bills.service_id
where Bills.payment_status = "Pending";

select
    Mechanics.mechanic_name,
    count(Service_Records.service_id) as Total_Services,
    rank() over (
        order by count(Service_Records.service_id) desc
    ) as Service_Rank
from Mechanics
left join Service_Records
on Mechanics.mechanic_id = Service_Records.mechanic_id
group by Mechanics.mechanic_id, Mechanics.mechanic_name
order by Service_Rank;