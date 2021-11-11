USE amediateka;

DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER //
CREATE PROCEDURE sp_add_user (first_name VARCHAR(100),
							 last_name VARCHAR(100),
							 gender CHAR(1),
							 email VARCHAR(100),
							 phone VARCHAR(100),
							 birthday DATE,
							 OUT u_in_status VARCHAR(200))
BEGIN
	DECLARE _rollback BOOL DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);
	DECLARE last_user_id INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET _rollback = 1;
			GET STACKED DIAGNOSTICS CONDITION 1
				code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
			SET u_in_status := concat('Aborted. Error code: ', code, '. Text: ', error_string);
		END;

	START TRANSACTION;
	INSERT INTO users
		(first_name, last_name, gender, email, phone, birthday)
	VALUES
		(first_name, last_name, gender, email, phone, birthday);

	SELECT last_insert_id() INTO @last_user_id;

	IF _rollback THEN
		ROLLBACK;
	ELSE
		SET u_in_status := 'OK';
		COMMIT;
	END IF;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_add_movie;
DELIMITER //

CREATE PROCEDURE sp_add_movie (name VARCHAR(50),
							 genre_id INT,
							 country_id INT,
							 directors_id INT,
							 actors_id INT,
							 relase_date DATE,
							 OUT m_in_status VARCHAR(200))
BEGIN
	DECLARE _rollback BOOL DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);
	DECLARE last_movie_id INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET _rollback = 1;
			GET STACKED DIAGNOSTICS CONDITION 1
				code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
			SET m_in_status := concat('Aborted. Error code: ', code, '. Text: ', error_string);
		END;

	START TRANSACTION;
	INSERT INTO movies
		(name, genre_id, country_id, directors_id, actors_id, relase_date)
	VALUES
		(name, genre_id, country_id, directors_id, actors_id, relase_date);

	SELECT last_insert_id() INTO @last_movie_id;

	IF _rollback THEN
		ROLLBACK;
	ELSE
		SET m_in_status := 'OK';
		COMMIT;
	END IF;

END //
DELIMITER ;
