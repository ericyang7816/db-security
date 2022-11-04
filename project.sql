grant select,update on project to all_staff;
BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'project_policy',
    column_name => 'project_column');
END;

GRANT project_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('project_policy',100,'l_level','low level');
SA_COMPONENTS.CREATE_LEVEL('project_policy',300,'m_level','mid level');
SA_COMPONENTS.CREATE_LEVEL('project_policy',400,'h_level','high level');
END;
BEGIN
SA_COMPONENTS.CREATE_COMPARTMENT('project_policy',10,'MUSIC','MUSIC');
SA_COMPONENTS.CREATE_COMPARTMENT('project_policy',20,'VIDEO','VIDEO');
SA_COMPONENTS.CREATE_COMPARTMENT('project_policy',30,'ADS','ADS');
SA_COMPONENTS.CREATE_COMPARTMENT('project_policy',40,'PAY','PAY');
SA_COMPONENTS.CREATE_COMPARTMENT('project_policy',50,'MAP','MAP');
END;

BEGIN
sa_label_admin.create_label('project_policy',3006,'h_level:PAY,MUSIC,MAP:',TRUE);
sa_label_admin.create_label('project_policy',4006,'h_level:PAY:',TRUE);
sa_label_admin.create_label('project_policy',5006,'m_level:ADS,MUSIC:',TRUE);
sa_label_admin.create_label('project_policy',6006,'m_level:ADS,MAP:',TRUE);
sa_label_admin.create_label('project_policy',7006,'l_level:MAP:',TRUE);
sa_label_admin.create_label('project_policy',8006,'l_level::',TRUE);
END;

BEGIN
SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('project_policy','company','project');
sa_policy_admin.apply_table_policy
( policy_name    => 'project_policy'
, schema_name    => 'company'
, table_name     => 'project'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL,WRITE_CONTROL,HIDE'
, label_function => 'COMPANY.GET_PROJECT_LABEL(:new.SECRET,:new.BUSINESS)'
, predicate => NULL);
END;
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('project_policy','company','FULL,PROFILE_ACCESS');
END;
INSERT INTO PROJECT(PID,project_column) VALUES(2,3006);
INSERT INTO PROJECT(PID,project_column) VALUES(3,4006);
INSERT INTO PROJECT(PID,project_column) VALUES(4,5006);
INSERT INTO PROJECT(PID,project_column) VALUES(5,6006);
INSERT INTO PROJECT(PID,project_column) VALUES(6,7006);
INSERT INTO PROJECT(PID,project_column) VALUES(7,8006);

BEGIN
sa_user_admin.set_user_labels(policy_name=> 'project_policy',user_name =>'staff1',max_read_label =>'h_level:PAY:');
sa_user_admin.set_user_labels(policy_name=> 'project_policy',user_name =>'staff2',max_read_label =>'h_level:PAY,MUSIC,MAP:');
END;


BEGIN
SA_USER_ADMIN.DROP_USER_ACCESS (
policy_name=> 'staff_info_policy',user_name =>'hr'); 
END;
drop PROCEDURE company.GET_PROJECT_LABEL;
CREATE OR REPLACE function get_project_label (
  SECRET  IN  VARCHAR2,
  BUSINESS     IN  VARCHAR2)
RETURN LBACSYS.LBAC_LABEL AS
  v_label  VARCHAR2(80);
BEGIN
  IF SECRET = 'high' THEN
     v_label := 'h_level:';
  ELSIF SECRET = 'mid' THEN
     v_label := 'm_level:';
  ELSE
     v_label := 'l_level:';
  END IF;

  v_label := v_label || BUSINESS || ':';

  RETURN TO_LBAC_DATA_LABEL('project_policy',v_label);
END get_project_label;
grant all on GET_PROJECT_LABEL to company;
BEGIN
TO_LBAC_DATA_LABEL('project_policy','l_level:PAY:');
end;
UPDATE PROJECT
SET project_column = CHAR_TO_LABEL('project_policy','l_level::');
select * from ALL_PROCEDURES where owner = 'COMPANY';