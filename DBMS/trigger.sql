mysql> CREATE TABLE IF NOT EXISTS Library (
    ->     book_id INT PRIMARY KEY,
    ->     book_name VARCHAR(100) NOT NULL,
    ->     author_name VARCHAR(100) NOT NULL,
    ->     price INT NOT NULL
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE IF NOT EXISTS Library_Audit (
    ->     audit_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     book_id INT NOT NULL,
    ->     book_name VARCHAR(100) NOT NULL,
    ->     author_name VARCHAR(100) NOT NULL,
    ->     price INT NOT NULL,
    ->     operation_type VARCHAR(20) NOT NULL
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> delimiter $$
mysql> create trigger after_lib_update
    -> after update on Library
    -> for each row
    -> begin
    -> insert into Library_Audit(book_id,book_name,author_name,price,operation_type)
    -> values (OLD.book_id,OLD.book_name,OLD.author_name,OLD.price,'update');
    -> end $$
Query OK, 0 rows affected (0.04 sec)
mysql> delimiter $$
mysql> create trigger before_lib_delete
    -> before delete on Library
    -> for each row
    -> begin
    -> insert into Library_Audit(book_id,book_name,author_name,price,operation_type)
    -> values (OLD.book_id,OLD.book_name,OLD.author_name,OLD.price,'delete');
    -> end $$
Query OK, 0 rows affected (0.03 sec)

mysql> delimiter ;
mysql> CREATE TABLE IF NOT EXISTS Trigger_Log (
    ->     log_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     operation_type VARCHAR(20),
    ->     message VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> DELIMITER //
mysql>
mysql> CREATE TRIGGER before_update_Library_stmt
    -> BEFORE UPDATE ON Library
    -> FOR EACH ROW
    -> BEGIN
    ->     IF @already_logged IS NULL THEN
    ->         INSERT INTO Trigger_Log (operation_type, message)
    ->         VALUES ('UPDATE', 'An update statement started on Library table');
    ->         SET @already_logged = TRUE;
    ->     END IF;
    -> END;
    -> //
Query OK, 0 rows affected (0.02 sec)

mysql> DELIMITER ;
mysql> SET @already_logged = NULL;
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO Library (book_id, book_name, author_name, price)
    -> VALUES
    -> (1, 'C++ Primer', 'Stanley Lippman', 500),
    -> (2, 'Database System Concepts', 'Silberschatz', 600),
    -> (3, 'Operating System Concepts', 'Galvin', 700);
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> UPDATE Library
    -> SET price = price + 50
    -> WHERE book_id = 2;
Query OK, 1 row affected (0.03 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM Library;
+---------+---------------------------+-----------------+-------+
| book_id | book_name                 | author_name     | price |
+---------+---------------------------+-----------------+-------+
|       1 | C++ Primer                | Stanley Lippman |   500 |
|       2 | Database System Concepts  | Silberschatz    |   650 |
|       3 | Operating System Concepts | Galvin          |   700 |
+---------+---------------------------+-----------------+-------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM Library_Audit;
+----------+---------+--------------------------+--------------+-------+----------------+
| audit_id | book_id | book_name                | author_name  | price | operation_type |
+----------+---------+--------------------------+--------------+-------+----------------+
|        1 |       2 | Database System Concepts | Silberschatz |   600 | update         |
+----------+---------+--------------------------+--------------+-------+----------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM Trigger_Log;
+--------+----------------+----------------------------------------------+
| log_id | operation_type | message                                      |
+--------+----------------+----------------------------------------------+
|      1 | UPDATE         | An update statement started on Library table |
+--------+----------------+----------------------------------------------+
1 row in set (0.00 sec)

mysql>
mysql> UPDATE Library
    -> SET price = price + 50
    -> WHERE book_id = 2;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM Library;
+---------+---------------------------+-----------------+-------+
| book_id | book_name                 | author_name     | price |
+---------+---------------------------+-----------------+-------+
|       1 | C++ Primer                | Stanley Lippman |   500 |
|       2 | Database System Concepts  | Silberschatz    |   700 |
|       3 | Operating System Concepts | Galvin          |   700 |
+---------+---------------------------+-----------------+-------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM Library_Audit;
+----------+---------+--------------------------+--------------+-------+----------------+
| audit_id | book_id | book_name                | author_name  | price | operation_type |
+----------+---------+--------------------------+--------------+-------+----------------+
|        1 |       2 | Database System Concepts | Silberschatz |   650 | update         |
+----------+---------+--------------------------+--------------+-------+----------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM Library_Audit;
+----------+---------+--------------------------+--------------+-------+----------------+
| audit_id | book_id | book_name                | author_name  | price | operation_type |
+----------+---------+--------------------------+--------------+-------+----------------+
|        1 |       2 | Database System Concepts | Silberschatz |   650 | update         |
+----------+---------+--------------------------+--------------+-------+----------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM Trigger_Log;
+--------+----------------+----------------------------------------------+
| log_id | operation_type | message                                      |
+--------+----------------+----------------------------------------------+
|      1 | UPDATE         | An update statement started on Library table |
|      2 | UPDATE         | An update statement started on Library table |
+--------+----------------+----------------------------------------------+
2 rows in set (0.00 sec)

mysql> DELETE FROM Library WHERE book_id = 1;
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM Library_Audit;
+----------+---------+--------------------------+-----------------+-------+----------------+
| audit_id | book_id | book_name                | author_name     | price | operation_type |
+----------+---------+--------------------------+-----------------+-------+----------------+
|        1 |       2 | Database System Concepts | Silberschatz    |   650 | update         |
|        2 |       1 | C++ Primer               | Stanley Lippman |   500 | delete         |
+----------+---------+--------------------------+-----------------+-------+----------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM Library;
+---------+---------------------------+--------------+-------+
| book_id | book_name                 | author_name  | price |
+---------+---------------------------+--------------+-------+
|       2 | Database System Concepts  | Silberschatz |   700 |
|       3 | Operating System Concepts | Galvin       |   700 |
+---------+---------------------------+--------------+-------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM Trigger_Log;
+--------+----------------+----------------------------------------------+
| log_id | operation_type | message                                      |
+--------+----------------+----------------------------------------------+
|      1 | UPDATE         | An update statement started on Library table |
|      2 | UPDATE         | An update statement started on Library table |
+--------+----------------+----------------------------------------------+
2 rows in set (0.00 sec)

mysql>