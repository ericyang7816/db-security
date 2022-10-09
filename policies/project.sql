CREATE OR REPLACE FUNCTION show_secret_project(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition VARCHAR2(200);
    sessionName VARCHAR2(30);
    userSecretLever number(10, 2);
BEGIN
   sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName := 'SYSTEM' THEN
        RETURN '';
    END IF;

    userSecretLever := SYS_CONTEXT('VPD_CONTEXT', 'USER_SECRET_LEVEL');
    RETURN 'SECRET <= ' || userSecretLever;
END show_secret_project;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'project',
            policy_name => 'show_secret_project_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'project',
            policy_name => 'show_secret_project_policy',
            policy_function => 'show_secret_project',
            update_check => TRUE);
END;