create role all_hr not identified;
create role all_accountant not identified;
create role all_staff not identified;
create role all_applicant not identified;

grant connect to all_hr;
grant select,update on staff to all_hr;
grant select,update,insert,delete on hire to all_hr;
grant select,update,insert,delete on attendance to all_hr;
grant select,update,insert,delete on interview to all_hr;
grant select on salary to all_hr;
grant select on position to all_hr;
grant select on projectgroup to all_hr;

grant connect to all_accountant;
grant select on staff to all_accountant;
grant select,update,insert on salary to all_accountant;
grant select on attendance to all_accountant;
grant select on position to all_accountant; 

grant connect to all_staff;
grant select,update on staff to all_staff;
grant select,update on interview to all_staff;
grant select on salary to all_staff;grant select on project to all_staff;
grant select,update on projectgroup to all_staff;
grant select on attendance to all_staff; 
grant select on position to all_staff; 

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

grant select on hire_public to all_accountant;
grant select on hire_public to all_staff;
grant select on hire_public to applicant;

/*
grant connect to hr;
revoke connect,resource from hr;
grant all PRIVILEGES on hire to hr;
revoke all PRIVILEGES on hire from hr;

drop role all_hr;
drop role all_accountant;
drop role all_staff;

DROP USER staff1;
DROP USER staff2;
DROP USER hr;
DROP USER accountant;
DROP USER applicant;