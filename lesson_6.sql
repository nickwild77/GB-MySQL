USE vk;

-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем.

SELECT from_user_id AS user_id, 
	(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE users.id=messages.from_user_id) AS sender,
	COUNT(*) AS total
FROM messages
WHERE to_user_id=74
	AND from_user_id IN(
	SELECT user_id FROM friendships WHERE friend_id=74
	UNION ALL 
	SELECT friend_id FROM friendships WHERE user_id=74
	)
GROUP BY user_id 
ORDER BY total DESC;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT COUNT(*) AS total FROM likes
WHERE target_type_id = 2
AND target_id IN (SELECT * FROM (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
) AS sorted_profiles)
;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
	(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
	COUNT(*) AS total
	FROM likes
	GROUP BY gender
	ORDER BY total DESC 
	LIMIT 1;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT
  CONCAT(first_name, ' ', last_name) AS user,
  	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) +
  	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) +
  	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS all_activity
  	FROM users
  	ORDER BY all_activity
  	LIMIT 10;

