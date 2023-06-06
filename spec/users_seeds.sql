TRUNCATE TABLE users, spaces RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email, password) VALUES('Jessica', 'Jessica@gmail.com', 'IloveMakers2023');
INSERT INTO users (username, email, password) VALUES('Khuslen', 'Khuslen@gmail.com', 'Hello123');

INSERT INTO spaces (name, city, description, price, start_date, end_date, created_at, updated_at, user_id) VALUES('London Plaza', 'London', '2 bedroom flat', '60.50', '2023-06-05', '2023-06-20', NOW(), NOW(), 1),
('Paris Cottage', 'Paris', 'Entire house', '30.50', '2023-07-05', '2023-07-20', NOW(), NOW(), 2);