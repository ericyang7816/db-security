grant select on salary to all_hr;
grant select,update,insert on salary to all_accountant;
grant select on salary to all_staff;

CREATE OR REPLACE
FUNCTION show_own_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT( 'USERENV', 'SESSION_USER' ),'ACCOUNTANT') = 1 THEN
    RETURN '';
END IF;
RETURN 'SID = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_own_salary;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'salary',
		policy_name	=>	'show_own_salary_policy',
		policy_function	=>	'show_own_salary');
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'salary',
		policy_name	=>	'show_own_salary_policy');
END;

BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'salary_info_policy',
    column_name => 'salary_column');
END;
BEGIN
SA_SYSDBA.DROP_POLICY ( 
   'salary_info_policy',
   TRUE);
END;
/
GRANT salary_info_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('salary_info_policy',200,'n_level','normal level');
SA_COMPONENTS.CREATE_LEVEL('salary_info_policy',300,'m_level','manager level');
END;

BEGIN
SA_COMPONENTS.CREATE_GROUP('salary_info_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('salary_info_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('salary_info_policy',40,'S','REGION SOUTH','ALL');
END;

BEGIN
sa_label_admin.create_label('salary_info_policy',3004,'m_level::ALL',TRUE);
sa_label_admin.create_label('salary_info_policy',4004,'m_level::N',TRUE);
sa_label_admin.create_label('salary_info_policy',5004,'m_level::S',TRUE);
sa_label_admin.create_label('salary_info_policy',6004,'n_level::S',TRUE);
sa_label_admin.create_label('salary_info_policy',7004,'n_level::N',TRUE);
END;

BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'salary_info_policy'
, schema_name    => 'company'
, table_name     => 'salary'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL,WRITE_CONTROL,HIDE');
END;
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('staff_info_policy','company','FULL,PROFILE_ACCESS');
END;