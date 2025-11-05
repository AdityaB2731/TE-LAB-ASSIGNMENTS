Enter password: *******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.43 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show database;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'database' at line 1
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| adityadb           |
| demodb             |
| information_schema |
| loomline           |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
7 rows in set (0.14 sec)

mysql> use demodb;
Database changed
mysql> show tables;
+------------------+
| Tables_in_demodb |
+------------------+
| demo             |
| emp              |
| high_gpa         |
| placementdrive   |
| student          |
| training         |
+------------------+
6 rows in set (0.04 sec)

mysql> select * from placementdrive;
+----------+---------------+---------+-----------+
| Drive_id | Pcomp_name    | package | location  |
+----------+---------------+---------+-----------+
|        1 | TCS           | 4L      | Pune      |
|        2 | Infosys       | 5L      | Mumbai    |
|        3 | Wipro         | 4.5L    | Pune      |
|        4 | Cognizant     | 5L      | Bangalore |
|        5 | Tech Mahindra | 6L      | Hyderabad |
+----------+---------------+---------+-----------+
5 rows in set (0.02 sec)

mysql> select * from student;
+------+----------+------+--------+------+------------+------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      |
+------+----------+------+--------+------+------------+------------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |
+------+----------+------+--------+------+------------+------------+
8 rows in set (0.02 sec)

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

mysql> select * from student natural join placementdrive;
+----------+------+------+--------+------+------------+------------+---------------+---------+-----------+
| Drive_id | s_id | T_id | s_name | CGPA | s_branch   | s_dob      | Pcomp_name    | package | location  |
+----------+------+------+--------+------+------------+------------+---------------+---------+-----------+
|        1 |    1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 | TCS           | 4L      | Pune      |
|        2 |    2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 | Infosys       | 5L      | Mumbai    |
|        2 |    8 |    4 | Divya  |  8.4 | IT         | 2001-07-20 | Infosys       | 5L      | Mumbai    |
|        3 |    3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 | Wipro         | 4.5L    | Pune      |
|        3 |    7 |    1 | Aman   |    9 | Computer   | 2002-04-09 | Wipro         | 4.5L    | Pune      |
|        4 |    5 |    2 | Riya   |  8.9 | IT         | 2002-06-19 | Cognizant     | 5L      | Bangalore |
|        4 |    9 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 | Cognizant     | 5L      | Bangalore |
|        5 |    6 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 | Tech Mahindra | 6L      | Hyderabad |
+----------+------+------+--------+------+------------+------------+---------------+---------+-----------+
8 rows in set (0.02 sec)

mysql> select * from student join placementdrive;
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      | Drive_id | Pcomp_name    | package | location  |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        4 | Cognizant     | 5L      | Bangalore |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        3 | Wipro         | 4.5L    | Pune      |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        2 | Infosys       | 5L      | Mumbai    |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        1 | TCS           | 4L      | Pune      |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        4 | Cognizant     | 5L      | Bangalore |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        3 | Wipro         | 4.5L    | Pune      |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        2 | Infosys       | 5L      | Mumbai    |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        1 | TCS           | 4L      | Pune      |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        4 | Cognizant     | 5L      | Bangalore |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        3 | Wipro         | 4.5L    | Pune      |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        2 | Infosys       | 5L      | Mumbai    |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        1 | TCS           | 4L      | Pune      |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        4 | Cognizant     | 5L      | Bangalore |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        3 | Wipro         | 4.5L    | Pune      |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        2 | Infosys       | 5L      | Mumbai    |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        1 | TCS           | 4L      | Pune      |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        4 | Cognizant     | 5L      | Bangalore |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        3 | Wipro         | 4.5L    | Pune      |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        2 | Infosys       | 5L      | Mumbai    |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        1 | TCS           | 4L      | Pune      |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        4 | Cognizant     | 5L      | Bangalore |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        3 | Wipro         | 4.5L    | Pune      |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        2 | Infosys       | 5L      | Mumbai    |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        1 | TCS           | 4L      | Pune      |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        4 | Cognizant     | 5L      | Bangalore |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        3 | Wipro         | 4.5L    | Pune      |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        2 | Infosys       | 5L      | Mumbai    |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        1 | TCS           | 4L      | Pune      |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        4 | Cognizant     | 5L      | Bangalore |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        3 | Wipro         | 4.5L    | Pune      |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        2 | Infosys       | 5L      | Mumbai    |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        1 | TCS           | 4L      | Pune      |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
40 rows in set (0.02 sec)

mysql> select * from student as s join placementdrive as p on s.Drive_id=p.Drive_id ;
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      | Drive_id | Pcomp_name    | package | location  |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        1 | TCS           | 4L      | Pune      |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        2 | Infosys       | 5L      | Mumbai    |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        2 | Infosys       | 5L      | Mumbai    |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        3 | Wipro         | 4.5L    | Pune      |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        3 | Wipro         | 4.5L    | Pune      |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        4 | Cognizant     | 5L      | Bangalore |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        4 | Cognizant     | 5L      | Bangalore |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        5 | Tech Mahindra | 6L      | Hyderabad |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
8 rows in set (0.00 sec)

mysql> select * from student inner join placementdrive;
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      | Drive_id | Pcomp_name    | package | location  |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        4 | Cognizant     | 5L      | Bangalore |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        3 | Wipro         | 4.5L    | Pune      |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        2 | Infosys       | 5L      | Mumbai    |
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 |        1 | TCS           | 4L      | Pune      |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        4 | Cognizant     | 5L      | Bangalore |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        3 | Wipro         | 4.5L    | Pune      |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        2 | Infosys       | 5L      | Mumbai    |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 |        1 | TCS           | 4L      | Pune      |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        4 | Cognizant     | 5L      | Bangalore |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        3 | Wipro         | 4.5L    | Pune      |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        2 | Infosys       | 5L      | Mumbai    |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 |        1 | TCS           | 4L      | Pune      |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        4 | Cognizant     | 5L      | Bangalore |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        3 | Wipro         | 4.5L    | Pune      |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        2 | Infosys       | 5L      | Mumbai    |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 |        1 | TCS           | 4L      | Pune      |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        4 | Cognizant     | 5L      | Bangalore |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        3 | Wipro         | 4.5L    | Pune      |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        2 | Infosys       | 5L      | Mumbai    |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 |        1 | TCS           | 4L      | Pune      |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        4 | Cognizant     | 5L      | Bangalore |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        3 | Wipro         | 4.5L    | Pune      |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        2 | Infosys       | 5L      | Mumbai    |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 |        1 | TCS           | 4L      | Pune      |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        4 | Cognizant     | 5L      | Bangalore |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        3 | Wipro         | 4.5L    | Pune      |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        2 | Infosys       | 5L      | Mumbai    |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 |        1 | TCS           | 4L      | Pune      |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        5 | Tech Mahindra | 6L      | Hyderabad |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        4 | Cognizant     | 5L      | Bangalore |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        3 | Wipro         | 4.5L    | Pune      |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        2 | Infosys       | 5L      | Mumbai    |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 |        1 | TCS           | 4L      | Pune      |
+------+----------+------+--------+------+------------+------------+----------+---------------+---------+-----------+
40 rows in set (0.00 sec)

mysql> select s.*,p.Pcomp_name from student s inner join placementdrive p on s.Drive_id=p.Drive_id;
+------+----------+------+--------+------+------------+------------+---------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      | Pcomp_name    |
+------+----------+------+--------+------+------------+------------+---------------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 | TCS           |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 | Infosys       |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 | Infosys       |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 | Wipro         |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 | Wipro         |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 | Cognizant     |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 | Cognizant     |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 | Tech Mahindra |
+------+----------+------+--------+------+------------+------------+---------------+
8 rows in set (0.00 sec)

mysql> select s.*,p.Pcomp_name from student s join placementdrive p on s.Drive_id=p.Drive_id;
+------+----------+------+--------+------+------------+------------+---------------+
| s_id | Drive_id | T_id | s_name | CGPA | s_branch   | s_dob      | Pcomp_name    |
+------+----------+------+--------+------+------------+------------+---------------+
|    1 |        1 |    1 | Aditi  |  8.7 | Computer   | 2002-03-15 | TCS           |
|    2 |        2 |    2 | Dinesh |  7.5 | IT         | 2001-11-22 | Infosys       |
|    8 |        2 |    4 | Divya  |  8.4 | IT         | 2001-07-20 | Infosys       |
|    3 |        3 |    3 | Ananya |  9.2 | Mechanical | 2002-02-10 | Wipro         |
|    7 |        3 |    1 | Aman   |    9 | Computer   | 2002-04-09 | Wipro         |
|    5 |        4 |    2 | Riya   |  8.9 | IT         | 2002-06-19 | Cognizant     |
|    9 |        4 |    5 | Rahul  |  7.8 | Computer   | 2002-01-29 | Cognizant     |
|    6 |        5 |    3 | Pranav |  7.2 | Electrical | 2001-12-01 | Tech Mahindra |
+------+----------+------+--------+------+------------+------------+---------------+
8 rows in set (0.00 sec)

mysql> select s.s_name,s.s_branch from student s
    -> join placementdrive p
    -> on s.Drive_id=p.Drive_id
    -> where p.package=5;
+--------+----------+
| s_name | s_branch |
+--------+----------+
| Dinesh | IT       |
| Divya  | IT       |
| Riya   | IT       |
| Rahul  | Computer |
+--------+----------+
4 rows in set, 5 warnings (0.02 sec)

mysql> SELECT s.s_name, t.Tcompany_name
    -> FROM student s
    -> JOIN Training t
    -> ON s.T_id = t.T_id
    -> WHERE t.T_Fee > 20000;
ERROR 1054 (42S22): Unknown column 't.Tcompany_name' in 'field list'
mysql> select s.s_name,t.Tcomp_name from student s
    -> join training t
    -> on s.T_id=t.T_id
    -> where t.T_fee>20000;
Empty set (0.00 sec)

mysql> select t.*
    -> from student s
    -> ^C
mysql> select t.*
    -> from training t
    -> join student s
    -> on s.T_id=t.T_id
    -> where s.s_name='shantanu' and t.T_year=2011;
Empty set (0.02 sec)

mysql> select COUNT(distinct Tcomp_name) as tot_comp
    -> from training
    -> where T_year<2015;
+----------+
| tot_comp |
+----------+
|        0 |
+----------+
1 row in set (0.02 sec)

mysql> where T_year<201^C
mysql> create view stud_train_details as
    -> select s.s_name,s.s_id,s.s_branch,t.Tcomp_name,t.T_fee,t.T_year from student s
    -> join training t
    -> on s.T_id=t.T_id;
Query OK, 0 rows affected (0.07 sec)

mysql> select * from stud_train_details;
+--------+------+------------+---------------+-------+--------+
| s_name | s_id | s_branch   | Tcomp_name    | T_fee | T_year |
+--------+------+------------+---------------+-------+--------+
| Aditi  |    1 | Computer   | Udemy         |  5750 |   2019 |
| Aman   |    7 | Computer   | Udemy         |  5750 |   2019 |
| Dinesh |    2 | IT         | Coursera      |  8000 |   2020 |
| Riya   |    5 | IT         | Coursera      |  8000 |   2020 |
| Ananya |    3 | Mechanical | Simplilearn   |  7000 |   2021 |
| Pranav |    6 | Electrical | Simplilearn   |  7000 |   2021 |
| Divya  |    8 | IT         | Skillsoft     |  6900 |   2019 |
| Rahul  |    9 | Computer   | GreatLearning |  9000 |   2021 |
+--------+------+------------+---------------+-------+--------+
8 rows in set (0.02 sec)

mysql> insert into student(s_id,Drive_id,T_id,s_name,CGPA,s_branch,s_dob) values(111,1,4,'shantanu',8.2,'Computer','2000-01-10');
Query OK, 1 row affected (0.03 sec)

mysql> select * from stud_train_details;
+----------+------+------------+---------------+-------+--------+
| s_name   | s_id | s_branch   | Tcomp_name    | T_fee | T_year |
+----------+------+------------+---------------+-------+--------+
| Aditi    |    1 | Computer   | Udemy         |  5750 |   2019 |
| Aman     |    7 | Computer   | Udemy         |  5750 |   2019 |
| Dinesh   |    2 | IT         | Coursera      |  8000 |   2020 |
| Riya     |    5 | IT         | Coursera      |  8000 |   2020 |
| Ananya   |    3 | Mechanical | Simplilearn   |  7000 |   2021 |
| Pranav   |    6 | Electrical | Simplilearn   |  7000 |   2021 |
| Divya    |    8 | IT         | Skillsoft     |  6900 |   2019 |
| shantanu |  111 | Computer   | Skillsoft     |  6900 |   2019 |
| Rahul    |    9 | Computer   | GreatLearning |  9000 |   2021 |
+----------+------+------------+---------------+-------+--------+
9 rows in set (0.00 sec)

mysql> UPDATE student_training_view
    -> SET T_Fee = T_Fee * 1.10
    -> WHERE s_name = 'shantanu';
ERROR 1146 (42S02): Table 'demodb.student_training_view' doesn't exist
mysql> UPDATE stud_train_details
    -> WHERE s_name = 'shantanu';
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'WHERE s_name = 'shantanu'' at line 2
mysql> UPDATE student_training_view
    -> set T_fee=T_fee*1.10
    -> where s_name = 'shantanu';
ERROR 1146 (42S02): Table 'demodb.student_training_view' doesn't exist
mysql> UPDATE stud_train_details
    -> set T_fee=T_fee*1.10
    -> WHERE s_name = 'shantanu';
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from stud_train_details;
+----------+------+------------+---------------+-------+--------+
| s_name   | s_id | s_branch   | Tcomp_name    | T_fee | T_year |
+----------+------+------------+---------------+-------+--------+
| Aditi    |    1 | Computer   | Udemy         |  5750 |   2019 |
| Aman     |    7 | Computer   | Udemy         |  5750 |   2019 |
| Dinesh   |    2 | IT         | Coursera      |  8000 |   2020 |
| Riya     |    5 | IT         | Coursera      |  8000 |   2020 |
| Ananya   |    3 | Mechanical | Simplilearn   |  7000 |   2021 |
| Pranav   |    6 | Electrical | Simplilearn   |  7000 |   2021 |
| Divya    |    8 | IT         | Skillsoft     |  7590 |   2019 |
| shantanu |  111 | Computer   | Skillsoft     |  7590 |   2019 |
| Rahul    |    9 | Computer   | GreatLearning |  9000 |   2021 |
+----------+------+------------+---------------+-------+--------+
9 rows in set (0.00 sec)

mysql> delete from stud_train_details
    -> where s_name = 'shantanu';
ERROR 1395 (HY000): Can not delete from join view 'demodb.stud_train_details'
mysql>