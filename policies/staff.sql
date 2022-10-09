grant select on staff to all_hr;
grant select on staff to all_accountant;
grant select on staff to all_staff;


grant update (contact) on staff to all_staff;
grant update (account) on staff to all_staff;
grant update (contact) on staff to all_hr;
grant update (account) on staff to all_hr;
grant update (contact) on staff to all_accountant;
grant update (account) on staff to all_accountant;

grant update (sname) on staff to all_hr;
grant update (position) on staff to all_hr;
grant update (department) on staff to all_hr;

CREATE OR REPLACE FUNCTION show_own_info(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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
    IF userGroup = 'accountant' THEN
        RETURN '';
    END IF;
    RETURN 'SNAME = ' || sessionName;
END show_own_info;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'staff',
            policy_name => 'show_own_info_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'staff',
            policy_name => 'show_own_info_policy',
            policy_function => 'show_own_info',
            sec_relevant_cols=> 'ACCOUNT,SECRET',
            statement_types => 'SELECT',
            update_check => TRUE);
END;

CREATE OR REPLACE FUNCTION update_own_info(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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

    RETURN 'SNAME = ' || sessionName;
END update_own_info;

BEGIN
    DBMS_RLS.DROP_POLICY(
            object_schema => 'company',
            object_name => 'staff',
            policy_name => 'update_own_info_policy');
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
            object_schema => 'company',
            object_name => 'staff',
            policy_name => 'update_own_info_policy',
            policy_function => 'update_own_info',
            statement_types => 'UPDATE',
            update_check => TRUE);
END;