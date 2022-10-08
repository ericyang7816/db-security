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