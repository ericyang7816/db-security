CREATE OR REPLACE FUNCTION show_own_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition VARCHAR2(200);
    sessionName  VARCHAR2(30);
    userRole VARCHAR2(30);
BEGIN
    sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName = 'SYSTEM' THEN
        RETURN '';
    END IF;

    userRole := SYS_CONTEXT('VPD_CONTEXT', 'USER_ROLE');
    IF userRole = 'accountant' THEN
        RETURN '';
    END IF;
    RETURN 'SNAME = ' || sessionName;
END show_own_salary;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'salary',
            policy_name => 'show_own_salary_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'salary',
            policy_name => 'show_own_salary_policy',
            policy_function => 'show_own_salary');
END;