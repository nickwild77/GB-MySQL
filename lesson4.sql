USE vk;

UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;

CREATE TEMPORARY TABLE genders (name CHAR (1));

INSERT INTO genders VALUES ('M'), ('F');

UPDATE profiles SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);

CREATE TABLE user_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Индефикатор строки",
	name VARCHAR(100) NOT NULL COMMENT "Название статуса (уникально)",
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
 ) COMMENT "Справочник статусов";

INSERT INTO user_statuses (name) VALUES
('single'),
('married');

UPDATE profiles SET status = NULL;
ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED;

UPDATE profiles SET user_status_id = (SELECT id FROM user_statuses ORDER BY RAND() LIMIT 1);

ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body;

UPDATE messages SET
from_user_id = FLOOR(1 + RAND() * 100),
to_user_id = FLOOR(1 + RAND() * 100);

UPDATE messages SET media_id = FLOOR(1 + RAND() * 100);

UPDATE media SET user_id = FLOOR(1 + RAND() * 100);
UPDATE media SET size = FLOOR(100000 + (RAND() * 1000000)) WHERE size < 1000;

CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

UPDATE media SET filename = CONCAT(
'http://dropbox.net/vk/',
filename,
'.',
(SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

UPDATE media SET metadata = CONCAT('{"owner":"',
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
'"}');

ALTER TABLE media MODIFY COLUMN metadata JSON;

TRUNCATE media_types;

INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

/*!40000 ALTER TABLE friendship DISABLE KEYS */;

UPDATE friendship SET
user_id = FLOOR(1 + RAND() * 100),
friend_id = FLOOR(1 + RAND() * 100);

UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;

/*!40000 ALTER TABLE friendship ENABLE KEYS; */;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
('Requested'),
('Confirmed'),
('Rejected');

UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3);

DELETE FROM communities WHERE ID > 20;

UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);

CREATE TABLE list_of_cities LIKE friendship_statuses;
ALTER TABLE list_of_cities RENAME COLUMN name TO city;
INSERT INTO list_of_cities (city) SELECT city FROM profiles;

CREATE TABLE list_of_countries LIKE list_of_cities;
ALTER TABLE list_of_countries RENAME COLUMN city TO country;
INSERT INTO list_of_countries (country) SELECT country FROM profiles LIMIT 20;

ALTER TABLE list_of_cities RENAME COLUMN city TO city_name;
ALTER TABLE list_of_countries RENAME COLUMN country TO country_name;
