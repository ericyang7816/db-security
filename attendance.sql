grant select,update,insert,delete on attendance to all_hr;
grant select on attendance to all_accountant;
grant select on attendance to all_staff;

CREATE OR REPLACE
FUNCTION show_own_attendance(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'HR') = 1 THEN
    RETURN '';
END IF;
RETURN 'SID = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_own_attendance;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'attendance',
		policy_name	=>	'show_own_attendance_policy',
		policy_function	=>	'show_own_attendance');
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'attendance',
		policy_name	=>	'show_own_attendance_policy');
END;

BEGIN
SA_SYSDBA.DROP_POLICY ( 
   'attendance_policy',
   TRUE);
END;
BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'attendance_policy',
    column_name => 'attendance_column');
END;

GRANT attendance_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('attendance_policy',100,'n_level','normal level');
SA_COMPONENTS.CREATE_LEVEL('attendance_policy',200,'m_level','manager level');
END;
BEGIN
SA_COMPONENTS.CREATE_GROUP('attendance_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('attendance_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('attendance_policy',40,'S','REGION SOUTH','ALL');
END;
BEGIN
sa_label_admin.create_label('attendance_policy',3005,'m_level::ALL',TRUE);
sa_label_admin.create_label('attendance_policy',4005,'n_level::N',TRUE);
sa_label_admin.create_label('attendance_policy',5005,'n_level::S',TRUE);
END;
BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'attendance_policy'
, schema_name    => 'company'
, table_name     => 'attendance'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL, WRITE_CONTROL,HIDE');
END;
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('attendance_policy','company','FULL,PROFILE_ACCESS');
END;
INSERT INTO ATTENDANCE(SID,SNAME,"DATE") VALUES('STAFF1','A',TO_DATE('2020-10-01','YYYY-MM-DD'));
INSERT INTO ATTENDANCE(SID,SNAME,"DATE",ATTENDANCE_COLUMN) VALUES ('STAFF1','A',TO_DATE('2020-10-01','YYYY-MM-DD'),4005);
INSERT INTO ATTENDANCE(SID,SNAME,"DATE",ATTENDANCE_COLUMN) VALUES ('COMPANY','A',TO_DATE('2020-10-01','YYYY-MM-DD'),3005);

BEGIN
sa_user_admin.set_user_labels(policy_name=> 'attendance_policy',user_name =>'staff1',max_read_label =>'n_level::N');
sa_user_admin.set_user_labels(policy_name=> 'attendance_policy',user_name =>'hr',max_read_label =>'n_level::S');
END;
