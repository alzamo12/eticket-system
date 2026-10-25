-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================

CREATE TABLE Users (
    user_id serial primary key,
    full_name varchar(50),
    email varchar(50) unique,
    role varchar(30) check (role in ('Ticket Manager', 'Football Fan')),   --Ticket Manager or Football Fan
    phone_number varchar(15)
    
    -- Write your constraint to make 'user_id' the Primary Key
    -- Write your constraint to ensure 'email' values are never duplicated
    -- Write your check constraint to restrict 'role' to specific allowed strings
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id serial primary key,
    fixture varchar(200),
    tournament_category varchar(100),
    base_ticket_price int check (base_ticket_price >= 0),
    match_status varchar(30) check (match_status in ('Available','Selling Fast','Sold Out','Postponed'))   -- 'Available','Selling Fast','Sold Out','Postponed'
    
    -- Write your constraint to make 'match_id' the Primary Key -->  done
    -- Write your check constraint to prevent negative ticket prices --> done
    -- Write your check constraint to restrict 'match_status' values --> done
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================

CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    match_id INT REFERENCES Matches(match_id),
    seat_number VARCHAR(10),
    payment_status varchar(30) check (payment_status in ('Pending','Confirmed','Cancelled','Refunded')),   --'Pending','Confirmed','Cancelled','Refunded'
    total_cost INT check (total_cost >= 0)
    
    -- Write your constraint to make 'booking_id' the Primary Key --> done
    -- Write your Foreign Key constraint linking 'user_id' to the Users table --> done
    -- Write your Foreign Key constraint linking 'match_id' to the Matches table --> done
    -- Write your check constraint to ensure 'total_cost' is non-negative --> done
    -- Write your check constraint to restrict 'payment_status' values
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
  (501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);



--  query ->  1
select match_id,fixture, base_ticket_price from Matches 
where tournament_category = 'Champions League' and match_status = 'Available'


--  query ->  2 
select user_id, full_name, email from Users where full_name like 'Tanvir%' or full_name ilike '%Haque%'


--  query ->  3 ( missing payment status)
select booking_id, user_id, match_id, coalesce(payment_status, 'Action Required') as systematic_status  from Bookings where payment_status is null



-- Query 4: R

select b.booking_id, u.full_name, m.fixture, b.total_cost from Bookings as b 
  inner join Users as u on  b.user_id = u.user_id
  inner join Matches as m on b.match_id = m.match_id


--  Query 5: 

select u.user_id, full_name, booking_id from Users as u left join Bookings as b on u.user_id = b.user_id


-- Query 6: 

select booking_id, match_id, total_cost from Bookings where total_cost > (select avg(total_cost) from Bookings)


-- Query 7:

select match_id, fixture, base_ticket_price from Matches order by base_ticket_price desc limit 2 offset 1; 