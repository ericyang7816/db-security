grant select,update,insert,delete on interview to all_hr;
grant select,update on interview to all_staff;

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