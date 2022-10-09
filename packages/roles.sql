create role hr;
grant connect to hr;
grant select, update, insert, delete on attendance to hr;
grant select, update, insert, delete on interview to hr;
grant select on position to hr;
grant select on projectgroup to hr;
grant select on salary to hr;
grant select on staff to hr;
grant update (contact) on staff to hr;
grant update (account) on staff to hr;
grant update (sname) on staff to hr;
grant update (position) on staff to hr;
grant update (department) on staff to hr;

create role accountant;
grant connect to accountant;
grant select on attendance to accountant;
grant select on position to accountant;
grant select, update, insert on salary to accountant;
grant select on staff to accountant;
grant update (contact) on staff to accountant;
grant update (account) on staff to accountant;

create role developer;
grant connect to developer;
grant select on attendance to developer;
grant select, update on interview to developer;
grant select on position to developer;
grant select on project to developer;
grant select, update on projectgroup to developer;
grant select on salary to developer;
grant select on staff to developer;
grant update (contact) on staff to developer;
grant update (account) on staff to developer;

create role applicant;
grant connect to applicant;




