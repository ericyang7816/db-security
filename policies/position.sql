grant select on position to all_hr;
grant select on position to all_accountant;
grant select on position to all_staff;


CREATE OR REPLACE FUNCTION show_own_position_base_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition    VARCHAR2(200);
    userName     VARCHAR2(30);
    userGroup    VARCHAR2(30);
    userPosition VARCHAR2(30);
BEGIN
    userName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF userName := 'SYSTEM' THEN
        RETURN '';
    END IF;
    SELECT USER_GROUP INTO userGroup FROM STAFF WHERE SNAME = userName;
    IF userGroup = 'hr' OR 'accountant' THEN
        RETURN '';
    END IF;
    SELECT POSITION INTO userPosition FROM STAFF WHERE SNAME = userName;
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

