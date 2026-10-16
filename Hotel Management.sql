-- Hotel Management Database

create database hotel_management;

use hotel_management;

create table Hotels (
    hotel_id int primary key auto_increment,
    hotel_name varchar(50),
    city varchar(30),
    star_rating int
);

insert into Hotels (hotel_name, city, star_rating)
values
('Grand Palace', 'Chennai', 5),
('Royal Inn', 'Bangalore', 4),
('Blue Moon', 'Hyderabad', 3);

select * from Hotels;

create table Rooms (
    room_id int primary key auto_increment,
    hotel_id int,
    room_number varchar(10),
    room_type varchar(20),
    price decimal(10,2),
    status varchar(20),

    foreign key (hotel_id)
    references Hotels(hotel_id)
);

insert into Rooms
    (hotel_id, room_number, room_type, price, status)
values
    (1, '101', 'Standard', 2500, 'Available'),
    (1, '102', 'Deluxe', 4000, 'Occupied'),
    (1, '103', 'Suite', 7000, 'Occupied'),
    (2, '201', 'Standard', 2200, 'Available'),
    (2, '202', 'Deluxe', 3800, 'Occupied'),
    (3, '301', 'Standard', 1800, 'Available'),
    (3, '302', 'Suite', 6000, 'Occupied');

select * from Rooms;

create table Guests (
    guest_id int primary key auto_increment,
    guest_name varchar(50),
    phone varchar(15),
    city varchar(30)
);

insert into Guests (guest_name, phone, city)
values
('Rahul', '9876543210', 'Chennai'),
('Priya', '9876543211', 'Bangalore'),
('Arun', '9876543212', 'Hyderabad'),
('Sneha', '9876543213', 'Coimbatore'),
('Karthik', '9876543214', 'Mumbai');

select * from Guests;

create table Bookings (
    booking_id int primary key auto_increment,
    guest_id int,
    room_id int,
    check_in date,
    check_out date,
    booking_status varchar(20),

    foreign key (guest_id)
    references Guests(guest_id),

    foreign key (room_id)
    references Rooms(room_id)
);

insert into Bookings
    (guest_id, room_id, check_in, check_out, booking_status)
values
    (1, 2, '2026-07-25', '2026-07-30', 'Completed'),
    (2, 3, '2026-07-28', '2026-08-02', 'Active'),
    (3, 5, '2026-07-29', '2026-08-01', 'Active'),
    (4, 7, '2026-07-20', '2026-07-22', 'Completed'),
    (1, 1, '2026-08-05', '2026-08-08', 'Booked'),
    (5, 4, '2026-07-31', '2026-08-03', 'Cancelled');

select * from Bookings;

create table Payments (
    payment_id int primary key auto_increment,
    booking_id int,
    amount decimal(10,2),
    payment_status varchar(20),

    foreign key (booking_id)
    references Bookings(booking_id)
);

insert into Payments (booking_id, amount, payment_status)
values
(1, 20000, 'Paid'),
(2, 35000, 'Paid'),
(3, 12000, 'Pending'),
(4, 15000, 'Paid'),
(5, 7500, 'Pending'),
(6, 0, 'Refunded');

select * from Payments;

-- Hotel and Room Availability Queries

select
    room_number,
    room_type,
    price,
    hotel_name
from Rooms
join Hotels
    on Rooms.hotel_id = Hotels.hotel_id
where status = 'Available';

select
    guest_name,
    hotel_name,
    room_number,
    check_in,
    check_out
from Guests
join Bookings
    on Guests.guest_id = Bookings.guest_id
join Rooms
    on Bookings.room_id = Rooms.room_id
join Hotels
    on Rooms.hotel_id = Hotels.hotel_id
where curdate() between check_in and check_out
    and booking_status = 'Active';
    
-- Payment and Booking Reports

select sum(amount) as total_revenue
from Payments
where payment_status = 'Paid';

select
    b.booking_id,
    g.guest_name,
    h.hotel_name,
    r.room_number,
    b.check_in,
    b.check_out,
    b.booking_status
from Bookings b
join Guests g
    on b.guest_id = g.guest_id
join Rooms r
    on b.room_id = r.room_id
join Hotels h
    on r.hotel_id = h.hotel_id
where b.check_in between '2026-07-25' and '2026-07-31';

-- Room Type and Occupancy Reports

select
    r.room_type,
    count(*) as total_bookings
from Rooms r
join Bookings b
    on r.room_id = b.room_id
group by r.room_type
order by total_bookings desc
limit 1;

select
    hotel_id,
    count(*) as total_rooms,
    count(case when status = 'Occupied' then 1 end) as occupied_rooms,
    round(
        count(case when status = 'Occupied' then 1 end) * 100.0 / count(*),
        2
    ) as occupancy_rate
from Rooms
group by hotel_id;

-- Guest Booking and Payment Details

select
    b.booking_id,
    g.guest_name,
    b.check_in,
    b.check_out,
    b.booking_status
from Bookings b
join Guests g
    on b.guest_id = g.guest_id
where b.booking_status = 'Cancelled';

select
    g.guest_name,
    count(b.booking_id) as total_bookings
from Guests g
join Bookings b
    on g.guest_id = b.guest_id
group by g.guest_id, g.guest_name
having count(b.booking_id) > 1;

select
    avg(price) as average_room_price
from Rooms;

select
    h.hotel_name,
    count(r.room_id) as total_rooms
from Hotels h
join Rooms r
    on h.hotel_id = r.hotel_id
group by h.hotel_id, h.hotel_name
having count(r.room_id) > 100;

select
    g.guest_name,
    sum(p.amount) as total_payment
from Guests g
join Bookings b
    on g.guest_id = b.guest_id
join Payments p
    on b.booking_id = p.booking_id
group by g.guest_id, g.guest_name
order by total_payment desc
limit 1;

-- Hotel Revenue and Room Price Reports

select
    h.hotel_name,
    sum(p.amount) as total_revenue
from Hotels h
join Rooms r
    on h.hotel_id = r.hotel_id
join Bookings b
    on r.room_id = b.room_id
join Payments p
    on b.booking_id = p.booking_id
where p.payment_status = 'Paid'
group by h.hotel_id, h.hotel_name
order by total_revenue desc;

select
    r.room_number,
    r.room_type,
    r.price,
    h.hotel_name
from Rooms r
join Hotels h
    on r.hotel_id = h.hotel_id
order by r.price desc
limit 1;

-- Guests Without Bookings and Hotel Revenue Ranking

select
    g.guest_id,
    g.guest_name,
    g.phone,
    g.city
from Guests g
left join Bookings b
    on g.guest_id = b.guest_id
where b.booking_id is null;

select
    hotel_name,
    total_revenue,
    rank() over (order by total_revenue desc) as revenue_rank
from (
    select
        h.hotel_name,
        sum(p.amount) as total_revenue
    from Hotels h
    join Rooms r
        on h.hotel_id = r.hotel_id
    join Bookings b
        on r.room_id = b.room_id
    join Payments p
        on b.booking_id = p.booking_id
    where p.payment_status = 'Paid'
    group by h.hotel_id, h.hotel_name
) as hotel_revenue;