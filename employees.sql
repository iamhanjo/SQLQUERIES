-- Breakdown of Male and Female employees working in the Company Starting from 1990.
select 
e.gender , 
year(s.from_date) as calendar_year,
count(e.emp_no) as Number_of_Employees 
from employees e 
join salaries s
on e.emp_no = s.emp_no
group by calendar_year ,  e.gender
having calendar_year >= 1990;

-- Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.
select e.gender,
d.dept_name,
dm.emp_no,
dm.from_date,
dm.to_date,
f.calendar_year ,
case 
 when year(dm.to_date) >= f.calendar_year and year(dm.from_date)<= f.calendar_year then 1 
else 0
END  as active
from 
(select year(hire_date) as calendar_year
from employees 

group by calendar_year) f
cross join dept_manager dm
join  departments d 
on dm.dept_no = d.dept_no 
join employees e 
on e.emp_no = dm.emp_no
order by dm.emp_no , calendar_year;

-- Compare the average salary of female versus male employees in the entire company 
-- until year 2002, and add a filter allowing you to see that per each department.

select round(avg(s.salary),2) as SALARY ,
e.gender ,
year(s.to_date) as calendar_year,
d.dept_name
from employees e 
join salaries s 
on e.emp_no = s.emp_no
join dept_emp de
on de.emp_no = e.emp_no
join departments d 
on d.dept_no = de.dept_no 
group by  e.gender , calendar_year ,d.dept_no 
having calendar_year <= 2002
order by d.dept_no ;

-- Create an SQL stored procedure that will allow you to obtain the average male and female salary 
-- per department within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure.
-- Finally, visualize the obtained result-set in Tableau as a double bar chart. 

DROP PROCEDURE IF EXISTS filtered_salary;
Delimiter $$
create procedure filtered_salary ( in p_min_salary float ,p_max_salary float)
begin
select e.gender ,
d.dept_name ,
avg(s.salary) as avg_salary 
from salaries s
join employees e 
on s.emp_no = e.emp_no 
join dept_emp de
on e.emp_no = de.emp_no 
join departments d 
on d.dept_no = de.dept_no 
where s.salary between p_min_salary and p_max_salary
group by d.dept_no, e.gender ;
end $$ 
Delimiter ;
call filtered_salary (20000,100000);

