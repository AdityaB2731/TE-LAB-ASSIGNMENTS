----------------------------------------------------------------------------
create procedure getcategory(in marks int, out category varchar(20))
begin
 if marks between 990 and 1550 then
  set category = 'distinction';
 elseif marks between 900 and 989 then
  set category = 'first class';
 elseif marks between 825 and 899 then
  set category = 'second class';
 else
  set category = 'no class';
 end if;
end$$
-------------------------------------------------------------------------
CREATE PROCEDURE proc_grade(IN p_roll_no INT)
 BEGIN
 DECLARE v_name VARCHAR(50);
 DECLARE v_marks INT;
 DECLARE v_category VARCHAR(20); 
    SELECT name, total_marks INTO v_name, v_marks
    FROM stud_mark
    WHERE roll_no = p_roll_no; 
    CALL getcategory(v_marks, v_category);
    SELECT v_name AS Stu_name, v_marks AS total_marks, v_category AS Category;
END$$
