CREATE OR REPLACE FUNCTION show_own_position_base_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition    VARCHAR2(200);
    sessionName  VARCHAR2(30);
    userRole     VARCHAR2(30);
    userPosition VARCHAR2(30);
BEGIN
    sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName = 'SYSTEM' THEN
        RETURN '';
    END IF;

    userRole := SYS_CONTEXT('VPD_CONTEXT', 'USER_ROLE');
    IF userRole = 'hr' OR userRole = 'accountant' THEN
        RETURN '';
    END IF;


    SELECT POSITION INTO userPosition FROM STAFF WHERE SNAME = sessionName;
    RETURN 'POSITION = ' || userPosition;
END show_own_position_base_salary;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'position',
            policy_name => 'show_own_position_base_salary');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'position',
            policy_name => 'show_own_position_base_salary',
            sec_relevant_cols=> 'BASIC',
            policy_function => 'show_own_position_base_salary');
END;

