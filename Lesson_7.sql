-- Добавить заказы
INSERT INTO
orders(user_id)
VALUES
(1),
(3),
(5);

-- Добавить позиции товаров к заказам
INSERT INTO
orders_products(order_id, product_id)
VALUES
(1, 1),
(2, 3),
(3, 4);

-- Список пользователей осуществивших заказ
SELECT 
	u.id AS user_id, u.name AS user_name,
	op.order_id AS order_id,
	op.product_id AS product_id,
	(SELECT name FROM products WHERE id = op.product_id) AS product_name,
	op.total
FROM 
	users AS u
RIGHT JOIN
	orders AS o 
ON
	u.id = o.user_id
RIGHT JOIN
	orders_products AS op
ON
	o.id = op.order_id
ORDER BY u.name, op.order_id;

-- Выведите список товаров products и разделов catalogs,
-- который соответствует товару.
SELECT 
	p.id, p.name, p.price,
	c.id AS cat_id,
	c.name AS product
FROM
	products AS p
JOIN
	catalogs AS c
ON 
	p.catalog_id = c.id; 