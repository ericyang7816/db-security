grant select, update, insert, delete on attendance to all_hr;
grant select on attendance to all_accountant;
grant select on attendance to all_staff;

CREATE OR REPLACE FUNCTION show_own_attendance(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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
    IF userGroup = 'hr' THEN
        RETURN '';
    END IF;

    RETURN userGroup;
END show_own_attendance;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'attendance',
            policy_name => 'show_own_attendance_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'attendance',
            policy_name => 'show_own_attendance_policy',
            policy_function => 'show_own_attendance');
END;