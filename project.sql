grant select on project to all_staff;

CREATE OR REPLACE
FUNCTION show_secret_project(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS
secret number (10,2);
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