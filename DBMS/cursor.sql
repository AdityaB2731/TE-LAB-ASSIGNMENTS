-- Step 1: Drop existing tables (optional cleanup)
DROP TABLE IF EXISTS old_emp;
DROP TABLE IF EXISTS new_emp;

-- Step 2: Create tables
CREATE TABLE old_emp (
  emp_id INT,
  emp_name VARCHAR(50),
  city VARCHAR(50)
);

CREATE TABLE new_emp (
  emp_id INT,
  emp_name VARCHAR(50),
  city VARCHAR(50)
);

-- Step 3: Insert sample data
INSERT INTO old_emp VALUES
(1, 'Employee1', 'Pune'),
(2, 'Employee2', 'Mumbai'),
(3, 'Employee3', 'Bangalore');

INSERT INTO new_emp VALUES
(1, 'Employee1', 'Pune'),
(2, 'Employee2', 'Mumbai'),
(3, 'Employee3', 'Bangalore'),
(4, 'Employee4', 'Delhi'),
(5, 'Employee5', 'Chennai'),
(6, 'Ved', 'Pune');

DELIMITER $$

CREATE PROCEDURE merge_employees(IN city_param VARCHAR(50))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_id INT;
  DECLARE v_name VARCHAR(50);
  DECLARE v_city VARCHAR(50);

  DECLARE emp_cursor CURSOR FOR
    SELECT emp_id, emp_name, city
    FROM new_emp
    WHERE city = city_param;  -- acts like parameterized cursor!

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN emp_cursor;

  read_loop: LOOP
    FETCH emp_cursor INTO v_id, v_name, v_city;
    IF done THEN
      LEAVE read_loop;
    END IF;

    -- skip duplicates
    IF NOT EXISTS (SELECT 1 FROM old_emp WHERE emp_id = v_id) THEN
      INSERT INTO old_emp VALUES (v_id, v_name, v_city);
    END IF;

  END LOOP;

  CLOSE emp_cursor;

  SELECT 'Merge completed for city: ' AS Msg, city_param AS City;

END$$
DELIMITER ;

CALL merge_employees('Pune');
CALL merge_employees('Chennai');
CALL merge_employees('Delhi');
