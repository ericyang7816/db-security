@vpd_ctx.sql;

CREATE OR REPLACE TRIGGER ON_CONNECTION_TRI
    AFTER LOGON
    ON DATABASE
BEGIN
    VPD_CTX.SET_VPD_CONTEXT;
END;