grant select,update,insert,delete on hire to all_hr;

create view hire_public as 
SELECT "HIRE"."HID","HIRE"."POSITION","HIRE"."DEPARTMENT","HIRE"."DETAIL","HIRE"."STATUS" FROM "HIRE"
grant select on hire_public to all_accountant;
grant select on hire_public to all_staff;
grant select on hire_public to all_applicant;

# mac 
BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'hire_policy',
    column_name => 'hire_column');
END;
/

GRANT hire_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('hire_policy',100,'n_level','normal level');
END;
BEGIN
SA_COMPONENTS.CREATE_GROUP('hire_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('hire_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('hire_policy',40,'S','REGION SOUTH','ALL');
END;
BEGIN
sa_label_admin.create_label('hire_policy',3001,'n_level::ALL',TRUE);
sa_label_admin.create_label('hire_policy',4001,'n_level::N',TRUE);
sa_label_admin.create_label('hire_policy',5001,'n_level::S',TRUE);
END;
BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'hire_policy'
, schema_name    => 'company'
, table_name     => 'hire'
, table_options  => 'LABEL_DEFAULT, WRITE_CONTROL,HIDE');
END;
BEGIN
SA_POLICY_ADMIN.REMOVE_TABLE_POLICY (
policy_name    => 'hire_policy'
, schema_name    => 'company'
, table_name     => 'hire',
drop_column => TRUE);
END;
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('hire_policy','company','FULL,PROFILE_ACCESS');
END;
INSERT INTO hire(hid,position,department,headcount,hire_column) VALUES(1,'a','a',1,3001);
INSERT INTO hire(hid,position,department,headcount,hire_column) VALUES(2,'b','b',2,4001);
INSERT INTO hire(hid,position,department,headcount,hire_column) VALUES(3,'C','C',3,5001);
BEGIN
sa_user_admin.set_user_labels(policy_name=> 'hire_policy',user_name =>'staff2',max_read_label =>'n_level::S');
sa_user_admin.set_user_labels(policy_name=> 'hire_policy',user_name =>'hr',max_read_label =>'n_level::S');
END;
BEGIN
SA_USER_ADMIN.DROP_USER_ACCESS (
policy_name=> 'hire_policy',user_name =>'hr'); 
END;
