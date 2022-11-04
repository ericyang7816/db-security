GRANT CONNECT, RESOURCE, SELECT_CATALOG_ROLE TO company;

GRANT EXECUTE ON sa_components TO company WITH GRANT OPTION;
GRANT EXECUTE ON sa_user_admin TO company WITH GRANT OPTION;
GRANT EXECUTE ON sa_user_admin TO company WITH GRANT OPTION;
GRANT EXECUTE ON sa_label_admin TO company WITH GRANT OPTION;
GRANT EXECUTE ON sa_policy_admin TO company WITH GRANT OPTION;
GRANT EXECUTE ON sa_audit_admin  TO company WITH GRANT OPTION;

GRANT LBAC_DBA TO company;
GRANT EXECUTE ON sa_sysdba TO company;
GRANT EXECUTE ON to_lbac_data_label TO company;