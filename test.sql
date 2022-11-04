-- staff table
-- staff1,company
select * from staff;
-- hr
UPDATE staff SET SNAME='mysql' WHERE sid = 'STAFF1';
select * from staff;

-- position
-- staff1
select * from position;

-- salary
-- STAFF1
select * from salary;
-- accountant
select * from salary;
UPDATE salary SET "DATE"=TO_DATE('2020-12-01','YYYY-MM-DD') WHERE sid = 'STAFF1';

-- attendance
-- staff1
select * from attendance;

-- project
-- staff1,staff2
select * from project;

-- projectgroup;
-- staff1
SELECT * FROM PROJECTGROUP;
UPDATE projectgroup SET performance='C' WHERE pid= 20201021 and participant = 'STAFF2';


-- interview
-- staff1
select * from interview;
UPDATE INTERVIEW SET status=1 WHERE id=20200021;


-- HIRE
-- hr,staff1
select * from hire;
-- staff1
select * from hire_public;