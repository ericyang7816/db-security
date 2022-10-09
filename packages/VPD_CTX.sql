CREATE OR REPLACE PACKAGE VPD_CTX AS
    PROCEDURE SET_VPD_CONTEXT;
END;
/
CREATE OR REPLACE PACKAGE BODY VPD_CTX IS
    PROCEDURE SET_VPD_CONTEXT IS
        userName        VARCHAR2(30);
        userID          VARCHAR2(30);
        userGroup       VARCHAR2(30);
        userSecretLevel NUMBER;
    BEGIN
        userName := SYS_CONTEXT('USERENV', 'SESSION_USER');
        IF (userName = 'SYSTEM') THEN
            RETURN;
        END IF;

        SELECT SID, USER_GROUP, SECRET
        INTO userID, userGroup, userSecretLevel
        FROM STAFF
        WHERE SNAME = userName;

        DBMS_SESSION.set_context('VPD_CONTEXT', 'USER_ID', userID);
        DBMS_SESSION.set_context('VPD_CONTEXT', 'USER_GROUP', userGroup);
        DBMS_SESSION.set_context('VPD_CONTEXT', 'USER_SECRET_LEVEL', userSecretLevel);
    END SET_VPD_CONTEXT;
END VPD_CTX;

GRANT EXECUTE ON VPD_CTX TO PUBLIC;