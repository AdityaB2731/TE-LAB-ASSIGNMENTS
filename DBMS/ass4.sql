mysql> create table borrower(
    -> roll_no INT,
    -> name VARCHAR(50),
    -> doi DATE,
    -> book_name VARCHAR(50),
    -> status VARCHAR(1) DEFAULT 'I',
    -> PRIMARY KEY(roll_no,book_name));
Query OK, 0 rows affected (0.14 sec)

mysql> create table fine(
    -> roll_no INT,
    -> date DATE,
    -> amt INT);
Query OK, 0 rows affected (0.05 sec)

mysql> INSERT INTO borrower VALUES
    -> (1,'Rahul','2024-10-10','DBMS','I'),
    -> (2,'Sneha','2024-09-15','CN','I'),
    -> (3,'Amit','2024-08-25','OS','I'),
    -> (4,'Priya','2024-09-28','AI','I'),
    -> (5,'Rohit','2024-10-01','SQL','R');  -- Already returned
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0


-- Create tables
CREATE TABLE borrower (
    roll_no INT,
    name VARCHAR(50),
    doi DATE,
    book_name VARCHAR(50),
    status VARCHAR(1) DEFAULT 'I',
    PRIMARY KEY (roll_no, book_name)
);

CREATE TABLE fine (
    roll_no INT,
    date DATE,
    amt INT
);

-- Insert sample data
INSERT INTO borrower VALUES
(1, 'Rahul', '2024-10-10', 'DBMS', 'I'),
(2, 'Sneha', '2024-09-15', 'CN', 'I'),
(3, 'Amit', '2024-08-25', 'OS', 'I'),
(4, 'Priya', '2024-09-28', 'AI', 'I'),
(5, 'Rohit', '2024-10-01', 'SQL', 'R');  -- Already returned

-- Create procedure
DELIMITER $$

CREATE PROCEDURE library(
    IN roll INT,
    IN book VARCHAR(50),
    IN return_date DATE
)
BEGIN
    DECLARE issue_date DATE;
    DECLARE fine_amt INT DEFAULT 0;
    DECLARE days_diff INT;
    DECLARE current_status VARCHAR(1);

    -- Error handlers
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'SQL exception: error occurred.' AS ErrorMessage;
    END;

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No record found' AS ErrorMessage;
    END;

    -- Fetch issue date and current status
    SELECT doi, status INTO issue_date, current_status
    FROM borrower
    WHERE roll_no = roll AND book_name = book;

    -- Check if book is already returned
    IF current_status = 'R' THEN
        SELECT 'Book already returned' AS Message;
    ELSE
        -- Calculate days difference
        SET days_diff = DATEDIFF(return_date, issue_date);

        -- Compute fine
        IF days_diff <= 14 THEN
            SET fine_amt = 0;
        ELSEIF days_diff BETWEEN 15 AND 30 THEN
            SET fine_amt = days_diff * 5;
        ELSE
            SET fine_amt = (30 * 5) + ((days_diff - 30) * 50);
        END IF;

        -- Update borrower status to returned
        UPDATE borrower
        SET status = 'R'
        WHERE roll_no = roll AND book_name = book;

        -- Insert fine if applicable
        IF fine_amt > 0 THEN
            INSERT INTO fine(roll_no, date, amt)
            VALUES (roll, return_date, fine_amt);
            SELECT CONCAT('Fine amount: ', fine_amt) AS Message;
        ELSE
            SELECT 'No fine' AS Message;
        END IF;
    END IF;
END$$

DELIMITER ;

-- Example calls
CALL library(1, 'DBMS', '2024-10-18');  -- No fine
CALL library(2, 'CN', '2024-10-05');    -- Fine applied
CALL library(3, 'OS', '2024-10-09');    -- Fine applied


mysql> delimiter ;
mysql> CALL library(1, 'DBMS', '2024-10-18');
+---------+
| Message |
+---------+
| no fine |
+---------+
1 row in set (0.02 sec)

Query OK, 0 rows affected (0.02 sec)

mysql> CALL library(2, 'CN', '2024-10-05');
Query OK, 1 row affected (0.02 sec)

mysql> select * from fine;
+---------+------------+------+
| roll_no | date       | amt  |
+---------+------------+------+
|       2 | 2024-10-05 |  100 |
+---------+------------+------+
1 row in set (0.00 sec)

mysql> CALL library(3, 'OS', '2024-10-09');
Query OK, 1 row affected (0.01 sec)

mysql> CALL library(3, 'OS', '2024-10-09');^C
mysql> select * from fine;
+---------+------------+------+
| roll_no | date       | amt  |
+---------+------------+------+
|       2 | 2024-10-05 |  100 |
|       3 | 2024-10-09 |  900 |
+---------+------------+------+
2 rows in set (0.00 sec)

mysql> SELECT doi, DATEDIFF('2024-10-09', doi) FROM borrower WHERE book_name='OS';
+------------+-----------------------------+
| doi        | DATEDIFF('2024-10-09', doi) |
+------------+-----------------------------+
| 2024-08-25 |                          45 |
+------------+-----------------------------+
1 row in set (0.00 sec)

mysql> create table circle(
    -> radius INT,
    -> area DOUBLE);
Query OK, 0 rows affected (0.06 sec)


mysql> DELIMITER $$
mysql>
mysql> CREATE PROCEDURE calc_cir_area(IN start_r INT, IN end_r INT)
    -> BEGIN
    ->     DECLARE r INT;
    ->     DECLARE a DOUBLE;
    ->
    ->     -- Handle unexpected SQL errors gracefully
    ->     DECLARE EXIT HANDLER FOR SQLEXCEPTION
    ->     BEGIN
    ->         SELECT 'SQL Exception occurred' AS ErrorMessage;
    ->     END;
    ->
    ->     -- Validation checks
    ->     IF start_r < 5 OR end_r > 9 THEN
    ->         SIGNAL SQLSTATE '45000'
    ->         SET MESSAGE_TEXT = 'error in limit (start and end must be between 5 and 9)';
    ->     END IF;
    ->
    ->     IF start_r > end_r THEN
    ->         SIGNAL SQLSTATE '45000'
    ->         SET MESSAGE_TEXT = 'error: start_r cannot be greater than end_r';
    ->     END IF;
    ->
    ->     -- Main logic
    ->     SET r = start_r;
    ->     WHILE r <= end_r DO
    ->         SET a = 3.14 * r * r;
    ->         INSERT INTO circle(radius, area) VALUES (r, a);
    ->         SET r = r + 1;
    ->     END WHILE;
    -> END$$
Query OK, 0 rows affected (0.02 sec)

mysql>
mysql> DELIMITER ;
mysql> CALL calc_cir_area(5, 9);
Query OK, 1 row affected (0.04 sec)

mysql> CALL calc_cir_area(4, 8);   -- start_r < 5
+------------------------+
| ErrorMessage           |
+------------------------+
| SQL Exception occurred |
+------------------------+
1 row in set (0.01 sec)

Query OK, 0 rows affected (0.01 sec)

mysql> select * from circle;
+--------+--------+
| radius | area   |
+--------+--------+
|      5 |   78.5 |
|      6 | 113.04 |
|      7 | 153.86 |
|      8 | 200.96 |
|      9 | 254.34 |
+--------+--------+
5 rows in set (0.00 sec)

mysql>