grant select, update, insert, delete on interview to all_hr;
grant select, update on interview to all_staff;

CREATE OR REPLACE FUNCTION show_own_interview(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition VARCHAR2(200);
    sessionName  VARCHAR2(30);
    userGroup VARCHAR2(30);
BEGIN
    sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName := 'SYSTEM' THEN
        RETURN '';
    END IF;

    userGroup := SYS_CONTEXT('VPD_CONTEXT', 'USER_GROUP');
    IF userGroup = 'hr' THEN
        RETURN '';
    END IF;

    RETURN 'INTERVIEWER = ' || sessionName;
END show_own_interview;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'interview',
            policy_name => 'show_own_interview_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'interview',
            policy_name => 'show_own_interview_policy',
            policy_function => 'show_own_interview',
            update_check => TRUE);
END;