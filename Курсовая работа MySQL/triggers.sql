USE amediateka;

CREATE
    TRIGGER log_insert_trigger_on_users AFTER INSERT
    ON users
    FOR EACH ROW BEGIN
		IF NEW.id THEN
			INSERT INTO logs (table_name, event) VALUES ('users', 'new user');
		END IF;
    END;

CREATE
    TRIGGER log_insert_trigger_on_movies AFTER INSERT
    ON movies
    FOR EACH ROW BEGIN
		IF NEW.id THEN
			INSERT INTO logs (table_name, event) VALUES ('movies', 'new movie');
		END IF;
    END;