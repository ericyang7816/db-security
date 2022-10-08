grant select on salary to all_hr;
grant select, update, insert on salary to all_accountant;
grant select on salary to all_staff;

CREATE OR REPLACE FUNCTION show_own_salary(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition VARCHAR2(200);
    userName  VARCHAR2(30);
    userGroup VARCHAR2(30);
BEGIN
    userName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF userName := 'SYSTEM' THEN
        RETURN '';
    END IF;
    SELECT USER_GROUP INTO userGroup FROM STAFF WHERE SNAME = userName;
    IF userGroup = 'accountant' THEN
        RETURN '';
    END IF;
    RETURN 'SNAME = ' || userName;
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