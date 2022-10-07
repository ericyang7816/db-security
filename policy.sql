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

CREATE OR REPLACE
FUNCTION show_own_info(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'HR') = 1 THEN
    RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'ACCOUNTANT') = 1 THEN
    RETURN '';
END IF;
RETURN 'SID = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_own_info;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'staff',
		policy_name	=>	'show_own_info_policy',
		policy_function	=>	'show_own_info',
		sec_relevant_cols=> 'ACCOUNT,SECRET',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'staff',
		policy_name	=>	'show_own_info_policy');
END;

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
		object_name	=>	'staff',
		policy_name	=>	'show_own_info_policy');
END;

CREATE OR REPLACE
FUNCTION show_secret_project(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 ASsecret number (10,2);
condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
SELECT SECRET INTO secret from staff where sid = (SYS_CONTEXT('USERENV', 'SESSION_USER' ));
RETURN 'SECRET <= ' || secret;
END show_secret_project;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'project',
		policy_name	=>	'show_secret_project_policy',
		policy_function	=>	'show_secret_project',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'project',
		policy_name	=>	'show_secret_project_policy');
END;

CREATE OR REPLACE
FUNCTION show_projectgroup(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS
condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'HR') = 1 THEN
		RETURN '';
END IF;
RETURN 'PID IN (SELECT PID FROM PROJECT WHERE LEADER = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))) OR PARTICIPANT = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_projectgroup;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'projectgroup',
		policy_name	=>	'show_projectgroup_policy',
		policy_function	=>	'show_projectgroup',
		statement_types => 'SELECT',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'projectgroup',
		policy_name	=>	'show_projectgroup_policy');
END;

CREATE OR REPLACE
FUNCTION update_projectgroup(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS
condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
RETURN 'PID IN (SELECT PID FROM PROJECT WHERE LEADER = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' )))';
END update_projectgroup;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'projectgroup',
		policy_name	=>	'update_projectgroup_policy',
		policy_function	=>	'update_projectgroup',
		statement_types => 'UPDATE',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'projectgroup',
		policy_name	=>	'update_projectgroup');
END;

/*
ALTER USER COMPANY DEFAULT ROLE DBA;
select SID from STAFF; where SID = (SYS_CONTEXT('USERENV', 'SESSION_USER' ))
select (SYS_CONTEXT('USERENV', 'ISDBA' )) from dual
SELECT SYS_CONTEXT('SYS_SESSION_ROLES', 'DBA') FROM DUAL;
select SYS_CONTEXT( 'SYS_SESSION_ROLES', 'ALL_ACCOUNTANT' ) from dual
	SELECT * FROM session_roles;
	SELECT * FROM ALL_POLICIES
SELECT * FROM USER_SYS_PRIVS; SELECT * FROM USER_TAB_PRIVS; SELECT * FROM USER_ROLE_PRIVS;
*/