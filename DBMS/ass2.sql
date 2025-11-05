


mysql> create table PlacementDrive(
    -> Drive_id INT PRIMARY KEY,
    -> Pcomp_name VARCHAR(50) NOT NULL,
    -> package VARCHAR(50) NOT NULL,
    -> location VARCHAR(50) NOT NULL
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> CREATE TABLE training(
    -> T_id INT PRIMARY KEY,
    -> Tcomp_name VARCHAR(50) NOT NULL,
    -> T_fee INT CHECK(T_fee>=0),
    -> T_year YEAR NOT NULL
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> create table student(
    -> s_id INT PRIMARY KEY,
    -> Drive_id INT REFERENCES PlacementDrive(Drive_id) ON DELETE CASCADE,
    -> T_id INT REFERENCES training(T_id) ON DELETE CASCADE,
    -> s_name VARCHAR(50) NOT NULL,
    -> CGPA FLOAT CHECK(CGPA BETWEEN 0 AND 10),
    -> s_branch VARCHAR(50) NOT NULL,
    -> s_dob DATE NOT NULL
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> show create table student;
+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table   | Create Table                                                                                                                                                                                                                                                                                                                                                                                  |
+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| student | CREATE TABLE `student` (
  `s_id` int NOT NULL,
  `Drive_id` int DEFAULT NULL,
  `T_id` int DEFAULT NULL,
  `s_name` varchar(50) NOT NULL,
  `CGPA` float DEFAULT NULL,
  `s_branch` varchar(50) NOT NULL,
  `s_dob` date NOT NULL,
  PRIMARY KEY (`s_id`),
  CONSTRAINT `student_chk_1` CHECK ((`CGPA` between 0 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> alter table student
    -> add constraint fk_drive
    -> FOREIGN KEY(Drive_id)
    -> REFERENCES PlacementDrive(Drive_id)
    -> ON DELETE CASCADE;
Query OK, 0 rows affected (0.13 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> alter table student
    -> add constraint fk_training
    -> FOREIGN KEY(T_id)
    -> REFERENCES training(T_id)
    -> ON DELETE CASCADE;
Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show create table student;
+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table   | Create Table                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| student | CREATE TABLE `student` (
  `s_id` int NOT NULL,
  `Drive_id` int DEFAULT NULL,
  `T_id` int DEFAULT NULL,
  `s_name` varchar(50) NOT NULL,
  `CGPA` float DEFAULT NULL,
  `s_branch` varchar(50) NOT NULL,
  `s_dob` date NOT NULL,
  PRIMARY KEY (`s_id`),
  KEY `fk_drive` (`Drive_id`),
  KEY `fk_training` (`T_id`),
  CONSTRAINT `fk_drive` FOREIGN KEY (`Drive_id`) REFERENCES `placementdrive` (`Drive_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_training` FOREIGN KEY (`T_id`) REFERENCES `training` (`T_id`) ON DELETE CASCADE,
  CONSTRAINT `student_chk_1` CHECK ((`CGPA` between 0 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> INSERT INTO PlacementDrive (Drive_id, Pcomp_name, package, location) VALUES
    -> (1, 'TCS', '4L', 'Pune'),
    -> (2, 'Infosys', '5L', 'Mumbai'),
    -> (3, 'Wipro', '4.5L', 'Pune'),
    -> (4, 'Cognizant', '5L', 'Bangalore'),
    -> (5, 'Tech Mahindra', '6L', 'Hyderabad');
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> INSERT INTO training (T_id, Tcomp_name, T_fee, T_year) VALUES
    -> (1, 'Udemy', 5000, 2019),
    -> (2, 'Coursera', 8000, 2020),
    -> (3, 'Simplilearn', 7000, 2021),
    -> (4, 'Skillsoft', 6000, 2019),
    -> (5, 'GreatLearning', 9000, 2021);
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> INSERT INTO student (s_id, Drive_id, T_id, s_name, CGPA, s_branch, s_dob) VALUES
    -> (1, 1, 1, 'Aditi', 8.7, 'Computer', '2002-03-15'),
    -> (2, 2, 2, 'Dinesh', 7.5, 'IT', '2001-11-22'),
    -> (3, 3, 3, 'Ananya', 9.2, 'Mechanical', '2002-02-10'),
    -> (4, 1, 4, 'Deepak', 6.8, 'Computer', '2001-08-05'),
    -> (5, 4, 2, 'Riya', 8.9, 'IT', '2002-06-19'),
    -> (6, 5, 3, 'Pranav', 7.2, 'Electrical', '2001-12-01'),
    -> (7, 3, 1, 'Aman', 9.0, 'Computer', '2002-04-09'),
    -> (8, 2, 4, 'Divya', 8.4, 'IT', '2001-07-20'),
    -> (9, 4, 5, 'Rahul', 7.8, 'Computer', '2002-01-29'),
    -> (10, 5, 2, 'Arjun', 6.5, 'Civil', '2001-10-17');
Query OK, 10 rows affected (0.01 sec)
Records: 10  Duplicates: 0  Warnings: 0

mysql> select * from student
    -> where (s_branch IN('Computer','IT')) and (s_name LIKE 'A%' OR s_name LIKE 'D%');
+------+----------+------+--------+------+----------+------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch | s_dob      |
+------+----------+------+--------+------+----------+------------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer | 2002-03-15 |
|    2 |        2 |    2 | Dinesh |  7.5 | IT       | 2001-11-22 |
|    4 |        1 |    4 | Deepak |  6.8 | Computer | 2001-08-05 |
|    7 |        3 |    1 | Aman   |    9 | Computer | 2002-04-09 |
|    8 |        2 |    4 | Divya  |  8.4 | IT       | 2001-07-20 |
+------+----------+------+--------+------+----------+------------+
5 rows in set (0.00 sec)

mysql> select count(DISTINCT Pcomp_name) as total_comp from PlacementDrive;
+------------+
| total_comp |
+------------+
|          5 |
+------------+
1 row in set (0.01 sec)

mysql> select DISTINCT Pcomp_name from PlacementDrive;
+---------------+
| Pcomp_name    |
+---------------+
| TCS           |
| Infosys       |
| Wipro         |
| Cognizant     |
| Tech Mahindra |
+---------------+
5 rows in set (0.00 sec)

mysql> update training
    -> set T_fee = T_fee*1.15
    -> where T_year=2019;
Query OK, 2 rows affected (0.01 sec)
Rows matched: 2  Changed: 2  Warnings: 0

mysql> select * from training
    -> ;
+------+---------------+-------+--------+
| T_id | Tcomp_name    | T_fee | T_year |
+------+---------------+-------+--------+
|    1 | Udemy         |  5750 |   2019 |
|    2 | Coursera      |  8000 |   2020 |
|    3 | Simplilearn   |  7000 |   2021 |
|    4 | Skillsoft     |  6900 |   2019 |
|    5 | GreatLearning |  9000 |   2021 |
+------+---------------+-------+--------+
5 rows in set (0.00 sec)

mysql> delete from student where CGPA<7;
Query OK, 2 rows affected (0.01 sec)

mysql> select Pcomp_name from PlacementDrive where location IN ('Pune','Mumbai');
+------------+
| Pcomp_name |
+------------+
| TCS        |
| Infosys    |
| Wipro      |
+------------+
3 rows in set (0.00 sec)

mysql> select s_name from student where T_id in(select T_id from training where T_year IN (2019,2021));
+--------+
| s_name |
+--------+
| Aditi  |
| Aman   |
| Ananya |
| Pranav |
| Divya  |
| Rahul  |
+--------+
6 rows in set (0.01 sec)

mysql> select s_name,CGPA
    -> from student
    -> where CGPA=(select max(CGPA) from student);
+--------+------+
| s_name | CGPA |
+--------+------+
| Ananya |  9.2 |
+--------+------+
1 row in set (0.00 sec)

mysql> select s_name,CGPA
    -> from student where CGPA BETWEEN 7 AND 9;
+--------+------+
| s_name | CGPA |
+--------+------+
| Aditi  |  8.7 |
| Dinesh |  7.5 |
| Riya   |  8.9 |
| Pranav |  7.2 |
| Aman   |    9 |
| Divya  |  8.4 |
| Rahul  |  7.8 |
+--------+------+
7 rows in set (0.00 sec)

mysql> select s.s_name,s.T_id,t.T_fee
    -> from student s
    -> join training t on s.T_id=t.T_id
    -> order by t.T_fee DESC;
+--------+------+-------+
| s_name | T_id | T_fee |
+--------+------+-------+
| Rahul  |    5 |  9000 |
| Dinesh |    2 |  8000 |
| Riya   |    2 |  8000 |
| Ananya |    3 |  7000 |
| Pranav |    3 |  7000 |
| Divya  |    4 |  6900 |
| Aditi  |    1 |  5750 |
| Aman   |    1 |  5750 |
+--------+------+-------+
8 rows in set (0.00 sec)

mysql> select p.Pcomp_name,s.s_name,p.location,p.package
    -> from student s
    -> join PlacementDrive p on s.Drive_id=p.Drive_id
    -> where p.package IN('30K','40K','50K');
Empty set (0.00 sec)

mysql> create table demo(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(50));
Query OK, 0 rows affected (0.05 sec)

mysql> insert into demo(name) values('Alice'),('Bob'),('Charlie');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select*from demo
    -> ;
+----+---------+
| id | name    |
+----+---------+
|  1 | Alice   |
|  2 | Bob     |
|  3 | Charlie |
+----+---------+
3 rows in set (0.00 sec)

mysql> create view high_gpa as
    -> select s_id,s_name,CGPA
    -> from student
    -> where CGPA>=8;
Query OK, 0 rows affected (0.02 sec)

mysql> select * from high_gpa;
+------+--------+------+
| s_id | s_name | CGPA |
+------+--------+------+
|    1 | Aditi  |  8.7 |
|    3 | Ananya |  9.2 |
|    5 | Riya   |  8.9 |
|    7 | Aman   |    9 |
|    8 | Divya  |  8.4 |
+------+--------+------+
5 rows in set (0.01 sec)

mysql> show create view high_gpa;
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View     | Create View                                                                                                                                                                                                                            | character_set_client | collation_connection |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| high_gpa | CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `high_gpa` AS select `student`.`s_id` AS `s_id`,`student`.`s_name` AS `s_name`,`student`.`CGPA` AS `CGPA` from `student` where (`student`.`CGPA` >= 8) | cp850                | cp850_general_ci     |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
1 row in set (0.00 sec)

mysql> create index idx_branch on student(s_branch);
Query OK, 0 rows affected (0.08 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show index from student;
+---------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table   | Non_unique | Key_name    | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+---------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| student |          0 | PRIMARY     |            1 | s_id        | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| student |          1 | fk_drive    |            1 | Drive_id    | A         |           5 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| student |          1 | fk_training |            1 | T_id        | A         |           5 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| student |          1 | idx_branch  |            1 | s_branch    | A         |           4 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+---------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
4 rows in set (0.04 sec)

mysql> show index from student where Key_name='idx_branch';
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table   | Non_unique | Key_name   | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| student |          1 | idx_branch |            1 | s_branch    | A         |           4 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
1 row in set (0.00 sec)

mysql> CREATE UNIQUE INDEX idx_unique_name ON student(s_name);
Query OK, 0 rows affected (0.06 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> CREATE INDEX idx_composite ON student(s_branch, CGPA);
Query OK, 0 rows affected (0.07 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SHOW INDEX FROM student;
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table   | Non_unique | Key_name        | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| student |          0 | PRIMARY         |            1 | s_id        | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| student |          0 | idx_unique_name |            1 | s_name      | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| student |          1 | fk_drive        |            1 | Drive_id    | A         |           5 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| student |          1 | fk_training     |            1 | T_id        | A         |           5 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| student |          1 | idx_branch      |            1 | s_branch    | A         |           4 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| student |          1 | idx_composite   |            1 | s_branch    | A         |           4 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| student |          1 | idx_composite   |            2 | CGPA        | A         |           8 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
7 rows in set (0.02 sec)

mysql> ANALYZE TABLE student;
+----------------+---------+----------+----------+
| Table          | Op      | Msg_type | Msg_text |
+----------------+---------+----------+----------+
| demodb.student | analyze | status   | OK       |
+----------------+---------+----------+----------+
1 row in set (0.02 sec)

mysql> SELECT * FROM student USE INDEX (idx_branch) WHERE s_branch = 'IT';
+------+----------+------+--------+------+----------+------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch | s_dob      |
+------+----------+------+--------+------+----------+------------+
|    2 |        2 |    2 | Dinesh |  7.5 | IT       | 2001-11-22 |
|    5 |        4 |    2 | Riya   |  8.9 | IT       | 2002-06-19 |
|    8 |        2 |    4 | Divya  |  8.4 | IT       | 2001-07-20 |
+------+----------+------+--------+------+----------+------------+
3 rows in set (0.01 sec)

mysql> SELECT * FROM student WHERE s_branch = 'IT';
+------+----------+------+--------+------+----------+------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch | s_dob      |
+------+----------+------+--------+------+----------+------------+
|    2 |        2 |    2 | Dinesh |  7.5 | IT       | 2001-11-22 |
|    5 |        4 |    2 | Riya   |  8.9 | IT       | 2002-06-19 |
|    8 |        2 |    4 | Divya  |  8.4 | IT       | 2001-07-20 |
+------+----------+------+--------+------+----------+------------+
3 rows in set (0.00 sec)

mysql> EXPLAIN SELECT * FROM student WHERE s_branch = 'IT';
+----+-------------+---------+------------+------+--------------------------+------------+---------+-------+------+----------+-------+
| id | select_type | table   | partitions | type | possible_keys            | key        | key_len | ref   | rows | filtered | Extra |
+----+-------------+---------+------------+------+--------------------------+------------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | student | NULL       | ref  | idx_branch,idx_composite | idx_branch | 202     | const |    3 |   100.00 | NULL  |
+----+-------------+---------+------------+------+--------------------------+------------+---------+-------+------+----------+-------+
1 row in set, 1 warning (0.01 sec)

mysql> explain SELECT * FROM student USE INDEX (idx_branch) WHERE s_branch = 'IT';
+----+-------------+---------+------------+------+---------------+------------+---------+-------+------+----------+-------+
| id | select_type | table   | partitions | type | possible_keys | key        | key_len | ref   | rows | filtered | Extra |
+----+-------------+---------+------------+------+---------------+------------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | student | NULL       | ref  | idx_branch    | idx_branch | 202     | const |    3 |   100.00 | NULL  |
+----+-------------+---------+------------+------+---------------+------------+---------+-------+------+----------+-------+
1 row in set, 1 warning (0.00 sec)

mysql>