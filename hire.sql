grant select,update,insert,delete on hire to all_hr;

create view hire_public as 
SELECT "HIRE"."HID","HIRE"."POSITION","HIRE"."DEPARTMENT","HIRE"."DETAIL","HIRE"."STATUS" FROM "HIRE"
grant select on hire_public to all_accountant;
grant select on hire_public to all_staff;
grant select on hire_public to applicant;