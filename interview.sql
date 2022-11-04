grant select,update,insert,delete on interview to all_hr;
grant select,update(status) on interview to all_staff;

CREATE OR REPLACE
FUNCTION show_own_interview(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'HR') = 1 THEN
    RETURN '';
END IF;
RETURN 'INTERVIEWER = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_own_interview;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'interview',
		policy_name	=>	'show_own_interview_policy',
		policy_function	=>	'show_own_interview',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'interview',
		policy_name	=>	'show_own_interview_policy');
END;

BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'interview_policy',
    column_name => 'interview_column');
END;
/
BEGIN
SA_SYSDBA.DROP_POLICY ('interview_policy',TRUE);
END;
GRANT interview_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('interview_policy',100,'n_level','normal level');
END;
BEGIN
SA_COMPONENTS.CREATE_GROUP('interview_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('interview_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('interview_policy',40,'S','REGION SOUTH','ALL');
END;
BEGIN
sa_label_admin.create_label('interview_policy',3003,'n_level::ALL',TRUE);
sa_label_admin.create_label('interview_policy',4003,'n_level::N',TRUE);
sa_label_admin.create_label('interview_policy',5003,'n_level::S',TRUE);
END;
BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'interview_policy'
, schema_name    => 'company'
, table_name     => 'interview'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL, WRITE_CONTROL,HIDE');
END;

BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('interview_policy','company','FULL,PROFILE_ACCESS');
END;
INSERT INTO INTERVIEW(ID,interview_column) VALUES (20200021,5003);
INSERT INTO INTERVIEW(ID,interview_column) VALUES (20200022,4003);

BEGIN
sa_user_admin.set_user_labels(policy_name=> 'interview_policy',user_name =>'staff2',max_read_label =>'n_level::S');
sa_user_admin.set_user_labels(policy_name=> 'interview_policy',user_name =>'hr',max_read_label =>'n_level::ALL');
END;
BEGIN
SA_USER_ADMIN.DROP_USER_ACCESS (
policy_name=> 'hire_policy',user_name =>'hr'); 
END;