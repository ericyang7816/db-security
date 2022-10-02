/*
CREATE OR REPLACE
FUNCTION show_own_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF SYS_CONTEXT('SYS_SESSION_ROLES', 'DBA') = 'TRUE' THEN
		RETURN '';
END IF;
IF SYS_CONTEXT( 'SYS_SESSION_ROLES', 'ALL_ACCOUNTANT' ) = 'TRUE' THEN
    RETURN '';
END IF;
RETURN 'SID = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END show_own_salary;
*/

CREATE OR REPLACE
FUNCTION show_own_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF SYS_CONTEXT('USERENV', 'SESSION_USER')  = 'COMPANY' THEN
		RETURN '';
END IF;
IF SYS_CONTEXT( 'USERENV', 'SESSION_USER' ) = 'ACCOUNTANT' THEN
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
IF SYS_CONTEXT('USERENV', 'SESSION_USER')  = 'COMPANY' THEN
		RETURN '';
END IF;
IF SYS_CONTEXT( 'USERENV', 'SESSION_USER' ) = 'HR' THEN
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
IF SYS_CONTEXT('USERENV', 'SESSION_USER')  = 'COMPANY' THEN
		RETURN '';
END IF;
IF SYS_CONTEXT( 'USERENV', 'SESSION_USER' ) = 'HR' THEN
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
		sec_relevant_cols=> 'DOB');
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'staff',
		policy_name	=>	'show_own_info_policy');
END;



/*
ALTER USER COMPANY DEFAULT ROLE DBA;
select SID from STAFF; where SID = (SYS_CONTEXT('USERENV', 'SESSION_USER' ))
select (SYS_CONTEXT('USERENV', 'ISDBA' )) from dual
SELECT SYS_CONTEXT('SYS_SESSION_ROLES', 'DBA') FROM DUAL;
	SELECT * FROM session_roles;
	SELECT * FROM ALL_POLICIES
SELECT * FROM USER_SYS_PRIVS; SELECT * FROM USER_TAB_PRIVS; SELECT * FROM USER_ROLE_PRIVS;
*/