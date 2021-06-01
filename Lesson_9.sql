
-- Практическое задание по теме “Транзакции, переменные, представления”.
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE id = 1);
DELETE FROM shop.users WHERE id = 1 LIMIT 1;
COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.
CREATE OR REPLACE VIEW viev_1 AS
SELECT
    p.name as product,
    c.name as catalog
FROM products as p
LEFT JOIN catalogs as c
ON p.catalog_id = c.id;

SELECT * FROM viev_1;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры".

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	SET @current_hour = HOUR(CURRENT_TIME());
	IF @current_hour <= 6   THEN RETURN "Доброй ночи";
	ELSEIF @current_hour <= 12 THEN RETURN "Доброе утро";
	ELSEIF @current_hour <= 18 THEN RETURN "Добрый день";
	ELSE RETURN "Добрый вечер";
	END IF;
END;

SELECT hello();

 -- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 -- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают 
 -- неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей 
 -- или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- Триггер на вставку
DROP TRIGGER IF EXISTS check_null_product;
CREATE TRIGGER check_null_product
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.desription IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
	END IF;
END;

-- Триггер на обновление
DROP TRIGGER IF EXISTS check_null_product_update;
CREATE TRIGGER check_null_product_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.desription IS NULL THEN
		SET NEW.name = OLD.name;
		SET NEW.desription = OLD.desription;
	END IF;
END;

-- Проверка вставки значений.
INSERT INTO products (name, desription) VALUES
	('prod_1', 'desc_1'),
	(NULL, 'desc_2'),
	('prod_3', NULL);

SELECT * FROM products;

-- Проверка - что будет, если записать оба NULL значения.
INSERT INTO products (name, desription) VALUES (NULL, NULL);
-- Запрос выполнится с ошибкой.
-- ERROR 1644 (45000): INSERT canceled

-- Проверка работы триггера на обновление
UPDATE products SET name = NULL WHERE id IN (1, 3);

SELECT * FROM products;
