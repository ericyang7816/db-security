grant select on hierarchy to all_hr;
grant select on hierarchy to all_accountant; 
grant select on hierarchy to all_staff; 

# mac 
BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'hierarchy_policy',
    column_name => 'hierarchy_column');
END;
/

GRANT hierarchy_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('hierarchy_policy',100,'v_level','vendor level');
SA_COMPONENTS.CREATE_LEVEL('hierarchy_policy',200,'s_level','staff level');
END;
BEGIN
SA_COMPONENTS.CREATE_GROUP('hierarchy_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('hierarchy_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('hierarchy_policy',40,'S','REGION SOUTH','ALL');
END;
BEGIN
sa_label_admin.create_label('hierarchy_policy',3002,'s_level::ALL',TRUE);
sa_label_admin.create_label('hierarchy_policy',4002,'v_level::N',TRUE);
sa_label_admin.create_label('hierarchy_policy',5002,'v_level::S',TRUE);
END;
BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'hierarchy_policy'
, schema_name    => 'company'
, table_name     => 'hierarchy'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL, WRITE_CONTROL,HIDE');
END;
BEGIN
SA_POLICY_ADMIN.REMOVE_TABLE_POLICY (
policy_name    => 'hierarchy_policy'
, schema_name    => 'company'
, table_name     => 'hierarchy',
drop_column => TRUE);
END;
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('hierarchy_policy','company','FULL,PROFILE_ACCESS');
END;
INSERT INTO HIERARCHY(position,department,hierarchy_column) VALUES('a','a',3002);
INSERT INTO HIERARCHY(position,department,hierarchy_column) VALUES('b','b',4002);
INSERT INTO HIERARCHY(position,department,hierarchy_column) VALUES('C','C',5002);
BEGIN
sa_user_admin.set_user_labels(policy_name=> 'hierarchy_policy',user_name =>'staff1',max_read_label =>'v_level::S');
sa_user_admin.set_user_labels(policy_name=> 'hierarchy_policy',user_name =>'hr',max_read_label =>'s_level::ALL');
END;
BEGIN
SA_USER_ADMIN.DROP_USER_ACCESS (
policy_name=> 'hire_policy',user_name =>'hr'); 
END;
