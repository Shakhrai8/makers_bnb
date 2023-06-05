DROP TABLE IF EXISTS users;

-- Table Definition
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username text,
    email text,
    password text
);

INSERT INTO users (username, email, password) VALUES
('Jessica', 'Jessica@gmail.com', 'IloveMakers2023'),
('Khuslen', 'Khuslen@gmail.com', 'Hello123'),
('Eugene', 'Eugene@gmail.com', 'Coolcat123'),
('Afrika', 'Afrika@gmail.com', 'Japan123');


