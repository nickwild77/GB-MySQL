--Практическое задание по теме “Оптимизация запросов”
--1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
--в таблицу logs помещается время и дата создания записи, название таблицы, 
--идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	record_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(255),
	pk BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255)
) ENGINE ARCHIVE;

--Процедура записывающая в таблицу logs информацию
--при каждом создании записей в таблицах users, catalogs и products.
CREATE PROCEDURE log_insert_procedure (
	table_name VARCHAR(255),
	id BIGINT,
	name VARCHAR(255))
BEGIN
	INSERT INTO logs (table_name, pk, name) VALUES (table_name, id, name);
END

--Триггеры для таблиц users, catalogs и products

DROP TRIGGER IF EXISTS log_insert_trigger_on_catalogs;
CREATE TRIGGER log_insert_trigger_on_catalogs
AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('catalogs', NEW.id, NEW.name);
END

DROP TRIGGER IF EXISTS log_insert_trigger_on_users;
CREATE TRIGGER log_insert_trigger_on_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('users', NEW.id, NEW.name);
END

DROP TRIGGER IF EXISTS log_insert_trigger_on_products;
CREATE TRIGGER log_insert_trigger_on_products
AFTER INSERT ON products
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('products', NEW.id, NEW.name);
END

