create role all_hr not identified;
create role all_accountant not identified;
create role all_staff not identified;
create role all_applicant not identified;

grant connect to all_hr;
grant connect to all_accountant;
grant connect to all_staff;
grant connect to all_applicant;

create user hr identified by 123;
grant all_hr to hr with admin option;
create user accountant identified by 123;
grant all_accountant to accountant with admin option;
create user staff1 identified by 123;
grant all_staff to staff1;
create user staff2 identified by 123;
grant all_staff to staff2;
create user applicant identified by 123;
grant all_applicant to applicant;


create view staff_basic as
select sid, sname, position, department, contact from staff;
grant select on staff_basic to all_staff;
grant select,update on staff_basic to all_hr;
grant select on staff_basic to all_accountant;

create view staff_accountant as
select sid, sname, position, department, contact,account from staff;
grant select on staff_accountant to all_staff;
grant update on staff_accountant.account to all_staff;
grant select on staff_accountant to all_hr;
grant update on staff_accountant.account to all_hr;
grant select on staff_accountant to all_accountant;
grant update on staff_accountant.account to all_accountant;



/*
grant connect to hr;
revoke connect,resource from hr;
grant all PRIVILEGES on hire to hr;
revoke all PRIVILEGES on hire from hr;

drop role all_hr;
drop role all_accountant;
drop role all_staff;
drop role all_applicant;

DROP USER staff1;
DROP USER staff2;
DROP USER hr;
DROP USER accountant;
DROP USER applicant;