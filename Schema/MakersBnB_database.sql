DROP TABLE IF EXISTS users, spaces, bookings, availability, photos, messages;


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
    city TEXT,
    description TEXT,
    price FLOAT,
    start_date DATE,
    end_date DATE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    space_id INTEGER,
    user_id INTEGER,
    start_date DATE,
    end_date DATE,
    contents TEXT,
    status TEXT DEFAULT 'pending',
    FOREIGN KEY (space_id) REFERENCES spaces(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE availability (
    id SERIAL PRIMARY KEY,
    space_id INTEGER,
    date DATE,
    is_available BOOLEAN DEFAULT true,
    FOREIGN KEY (space_id) REFERENCES spaces(id)
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER,
    receiver_id INTEGER,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_notification BOOLEAN DEFAULT false,
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);

CREATE TABLE photos (
  id SERIAL PRIMARY KEY,
  space_id INT,
  photo_url TEXT,
  FOREIGN KEY (space_id) REFERENCES spaces(id)
);

INSERT INTO users (username, email, password) VALUES
('Jessica', 'Jessica@gmail.com', 'IloveMakers2023'),
('Khuslen', 'Khuslen@gmail.com', 'Hello123'),
('Eugene', 'Eugene@gmail.com', 'Coolcat123'),
('Afrika', 'Afrika@gmail.com', 'Japan123');


INSERT INTO spaces (name, city, description, price, start_date, end_date, created_at, updated_at, user_id) VALUES
('London Plaza', 'London', '2 bedroom flat', '60.50', '2023-06-05', '2023-06-20', NOW(), NOW(), 1),
('Paris Cottage', 'Paris', 'Entire house', '30.50', '2023-07-05', '2023-07-20', NOW(), NOW(), 2);

INSERT INTO bookings (space_id, user_id, start_date, end_date, contents, status) VALUES
(1, 2, '2023-06-05', '2023-06-10', 'I would like an extra bed', 'pending'),
(2, 1, '2023-07-05', '2023-07-11', 'No requests', 'approved'); 


INSERT INTO availability (space_id, date, is_available) VALUES
(1, '2023-06-05', true),
(1, '2023-06-06', true),
(1, '2023-06-07', true),
(1, '2023-06-08', true),
(1, '2023-06-09', true),
(2, '2023-07-05', false),
(2, '2023-07-06', false),
(2, '2023-07-07', false),
(2, '2023-07-08', false),
(2, '2023-07-09', false),
(2, '2023-07-10', false);

INSERT INTO photos (id, space_id, photo_url)
VALUES
  (1, 1, 'https://c4.wallpaperflare.com/wallpaper/530/118/410/table-room-interior-wallpaper-preview.jpg'),
  (2, 1, 'https://c4.wallpaperflare.com/wallpaper/754/151/797/design-style-lamp-room-wallpaper-preview.jpg'),
  (3, 2, 'https://images.wallpaperscraft.com/image/single/interior_design_style_design_68248_1920x1080.jpg'),
  (4, 2, 'https://c0.wallpaperflare.com/preview/598/43/584/interior-design-room-office.jpg');



