grant select on staff to all_hr;
grant select on staff to all_accountant;
grant select on staff to all_staff;

grant update (position) on staff to all_hr;
grant update (department) on staff to all_hr;

grant update (contact) on staff to all_staff;

CREATE OR REPLACE
FUNCTION update_own_info(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS condition VARCHAR2 (200);
BEGIN
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'COMPANY') = 1 THEN
		RETURN '';
END IF;
IF INSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'),'HR') = 1 THEN
		RETURN '';
END IF;
RETURN 'SID = (SYS_CONTEXT(''USERENV'', ''SESSION_USER'' ))';
END update_own_info;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_schema	=>	'company',
		object_name	=>	'staff',
		policy_name	=>	'update_own_info_policy',
		policy_function	=>	'update_own_info',
		statement_types => 'UPDATE',
		update_check => TRUE);
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
		object_schema	=>	'company',
		object_name	=>	'staff',
		policy_name	=>	'update_own_info_policy');
END;

# mac 
BEGIN
  SA_SYSDBA.CREATE_POLICY(
    policy_name => 'staff_info_policy',
    column_name => 'staff_column');
END;
/

GRANT staff_info_policy_DBA TO company;

BEGIN
SA_COMPONENTS.CREATE_LEVEL('staff_info_policy',100,'v_level','vendor level');
SA_COMPONENTS.CREATE_LEVEL('staff_info_policy',200,'s_level','staff level');
SA_COMPONENTS.CREATE_LEVEL('staff_info_policy',300,'m_level','manager level');
END;

BEGIN
SA_COMPONENTS.CREATE_GROUP('staff_info_policy',60,'ALL','ALL REGIONS');
SA_COMPONENTS.CREATE_GROUP('staff_info_policy',20,'N','REGION NORTH','ALL');
SA_COMPONENTS.CREATE_GROUP('staff_info_policy',40,'S','REGION SOUTH','ALL');
END;

BEGIN
sa_label_admin.create_label('staff_info_policy',3000,'m_level::ALL',TRUE);
sa_label_admin.create_label('staff_info_policy',4000,'v_level::N',TRUE);
sa_label_admin.create_label('staff_info_policy',5000,'s_level::S',TRUE);
END;

BEGIN
sa_label_admin.drop_label('staff_info_policy',3000);
sa_label_admin.drop_label('staff_info_policy',4000);
sa_label_admin.drop_label('staff_info_policy',5000);
END;

BEGIN
sa_policy_admin.apply_table_policy
( policy_name    => 'staff_info_policy'
, schema_name    => 'company'
, table_name     => 'staff'
, table_options  => 'LABEL_DEFAULT, READ_CONTROL,WRITE_CONTROL,HIDE');
END;

BEGIN
SA_SYSDBA.DROP_POLICY ('staff_info_policy',TRUE);
END;
INSERT INTO staff(sid,sname,staff_column) VALUES(2,'a',4000);
INSERT INTO staff(sid,sname,staff_column) VALUES(3,'b',5000);
INSERT INTO staff(sid,sname,staff_column) VALUES(4,'c',3000);
BEGIN
SA_USER_ADMIN.SET_USER_PRIVS('staff_info_policy','company','FULL,PROFILE_ACCESS');
END;
BEGIN
sa_user_admin.set_user_labels(policy_name=> 'staff_info_policy',user_name =>'staff1',max_read_label =>'v_level::N');
sa_user_admin.set_user_labels(policy_name=> 'staff_info_policy',user_name =>'staff2',max_read_label =>'s_level::S');
sa_user_admin.set_user_labels(policy_name=> 'staff_info_policy',user_name =>'hr',max_read_label =>'m_level::N');
END;
BEGIN
SA_USER_ADMIN.DROP_USER_ACCESS (
policy_name=> 'staff_info_policy',user_name =>'hr'); 
END;
BEGIN
SA_SYSDBA.ENABLE_POLICY (
 'staff_info_policy');
END;
