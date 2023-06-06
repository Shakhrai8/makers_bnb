DROP TABLE IF EXISTS users, spaces;


-- Table Definition
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username text,
    email text,
    password text
);

CREATE TABLE spaces (
    id SERIAL PRIMARY KEY,
    name TEXT,
    description TEXT,
    price FLOAT,
    start_date DATE,
    end_date DATE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (username, email, password) VALUES
('Jessica', 'Jessica@gmail.com', 'IloveMakers2023'),
('Khuslen', 'Khuslen@gmail.com', 'Hello123'),
('Eugene', 'Eugene@gmail.com', 'Coolcat123'),
('Afrika', 'Afrika@gmail.com', 'Japan123');


INSERT INTO spaces (name, description, price, start_date, end_date, created_at, updated_at, user_id) VALUES
('London Plaza', '2 bedroom flat', '60.50', '2023-06-05', '2023-06-20', NOW(), NOW(), 1),
('Paris Cottage', 'Entire house', '30.50', '2023-07-05', '2023-07-20', NOW(), NOW(), 2);

