CREATE OR REPLACE FUNCTION show_projectgroup(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition   VARCHAR2(200);
    sessionName VARCHAR2(30);
    userID      VARCHAR2(30);
    userRole   VARCHAR2(30);
BEGIN
    sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName := 'SYSTEM' THEN
        RETURN '';
    END IF;

    userRole := SYS_CONTEXT('VPD_CONTEXT', 'USER_ROLE');
    IF userRole = 'hr' THEN
        RETURN '';
    END IF;
    userID := SYS_CONTEXT('VPD_CONTEXT', 'USER_ID');
    RETURN 'PID IN (SELECT PID FROM PROJECT WHERE LEADER = ' || userID || ' OR PARTICIPANT '|| sessionName;
END show_projectgroup;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'projectgroup',
            policy_name => 'show_projectgroup_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'projectgroup',
            policy_name => 'show_projectgroup_policy',
            policy_function => 'show_projectgroup',
            statement_types => 'SELECT',
            update_check => TRUE);
END;

CREATE OR REPLACE FUNCTION update_projectgroup(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS
    condition   VARCHAR2(200);
    sessionName VARCHAR2(30);
    userID      VARCHAR2(30);

BEGIN
    sessionName := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF sessionName := 'SYSTEM' THEN
        RETURN '';
    END IF;
    userID := SYS_CONTEXT('VPD_CONTEXT', 'USER_ID');
    RETURN 'LEADER = ' || userID;
END update_projectgroup;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'projectgroup',
            policy_name => 'update_projectgroup');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'projectgroup',
            policy_name => 'update_projectgroup_policy',
            policy_function => 'update_projectgroup',
            statement_types => 'UPDATE',
            update_check => TRUE);
END;