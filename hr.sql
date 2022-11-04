CREATE TABLE "STAFF" (
"SID" VARCHAR(255) NOT NULL,
"SNAME" VARCHAR(255) NOT NULL,
"POSITION" VARCHAR(255) NULL,
"DEPARTMENT" VARCHAR(255) NULL,
"CONTACT" VARCHAR(255) NULL,
"REGION" VARCHAR(255) NULL,
"TYPE" VARCHAR(255) NULL,
PRIMARY KEY ("SID") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "HIRE" (
"REGION" VARCHAR2(255) NULL,
"HID" VARCHAR(255) NOT NULL,
"POSITION" VARCHAR(255) NOT NULL,
"DEPARTMENT" VARCHAR(255) NOT NULL,
"DETAIL" VARCHAR(255) NULL,
"HEADCOUNT" SMALLINT NOT NULL,
"STATUS" CHAR(10 ) NULL,
PRIMARY KEY ("HID") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "SALARY" (
"REGION" VARCHAR(255) NULL,
"TYPE" VARCHAR(255) NULL,
"SID" VARCHAR(255) NOT NULL,
"SNAME" VARCHAR(255) NOT NULL,
"DATE" DATE NOT NULL,
"BASIC" NUMBER(10,2) NOT NULL,
"BONUS" NUMBER(10,2) NULL,
"DEDUCTION" NUMBER(10,2) NULL,
"NET" NUMBER(10,2) NOT NULL,
PRIMARY KEY ("SID", "DATE") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "HIERARCHY" (
"POSITION" VARCHAR(255) NOT NULL,
"DEPARTMENT" VARCHAR(255) NOT NULL,
"REGION" VARCHAR(255) NULL,
"TYPE" VARCHAR(255) NULL,
PRIMARY KEY ("POSITION") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "ATTENDANCE" (
"REGION" VARCHAR(255) NULL,
"TYPE" VARCHAR(255) NULL,
"SID" VARCHAR(255) NOT NULL,
"SNAME" VARCHAR(255) NOT NULL,
"DATE" DATE NOT NULL,
"ATTEND" SMALLINT NULL,
"LEAVE" SMALLINT NULL,
"OVERTIME" SMALLINT NULL,
PRIMARY KEY ("SID", "DATE") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "INTERVIEW" (
"REGION" VARCHAR(255) NULL,
"ID" INT NOT NULL,
"NAME" VARCHAR(255) NULL,
"CONTACT" VARCHAR(255) NULL,
"POSITION" VARCHAR(255) NULL,
"INTERVIEWER" VARCHAR(255) NULL,
"TIME" DATE NULL,
"STATUS" SMALLINT NULL,
PRIMARY KEY ("ID") 
)
NOCOMPRESS 
NOPARALLEL ;

CREATE TABLE "PROJECT" (
"PID" INT NOT NULL,
"DESCRIPTION" VARCHAR2(255) NULL,
"LEADER" VARCHAR(255) NULL,
"SECRET" VARCHAR(255) NULL,
"BUSINESS" VARCHAR(255) NULL,
"START" DATE NULL,
"FINISH" DATE NULL,
PRIMARY KEY ("PID") 
)
NOCOMPRESS 
NOPARALLEL ;


ALTER TABLE "STAFF" ADD CONSTRAINT "POSITION" FOREIGN KEY ("POSITION") REFERENCES "HIERARCHY" ("POSITION");
ALTER TABLE "HIRE" ADD CONSTRAINT "POSITION1" FOREIGN KEY ("POSITION") REFERENCES "HIERARCHY" ("POSITION");
ALTER TABLE "SALARY" ADD CONSTRAINT "SID" FOREIGN KEY ("SID") REFERENCES "STAFF" ("SID");
ALTER TABLE "INTERVIEW" ADD CONSTRAINT "SID1" FOREIGN KEY ("INTERVIEWER") REFERENCES "STAFF" ("SID");
ALTER TABLE "INTERVIEW" ADD CONSTRAINT "POSITION2" FOREIGN KEY ("POSITION") REFERENCES "HIERARCHY" ("POSITION");
ALTER TABLE "ATTENDANCE" ADD CONSTRAINT "SID2" FOREIGN KEY ("SID") REFERENCES "STAFF" ("SID");
ALTER TABLE "PROJECT" ADD CONSTRAINT "SID3" FOREIGN KEY ("LEADER") REFERENCES "STAFF" ("SID");

CREATE 
VIEW "HIRE_PUBLIC" AS 
SELECT
"HIRE"."HID",
"HIRE"."POSITION",
"HIRE"."DEPARTMENT",
"HIRE"."DETAIL",
"HIRE"."STATUS"
FROM
"HIRE"
WITH READ ONLY;

