-- *****************************************************************
--
-- Licensed Materials - Property of IBM
--
-- 5724-U69
--
-- Copyright IBM Corp. 2012, 2014  All Rights Reserved.
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
-- *****************************************************************
--
-- NAVIGATOR Oracle SQL Script
--
--


-- Create tablespaces

CREATE TABLESPACE @ECMClient_TBLSPACE@
    DATAFILE '@ECMClient_TBLSPACE@' SIZE 200M REUSE
    AUTOEXTEND ON NEXT 20M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO
    ONLINE
    PERMANENT
;

CREATE TEMPORARY TABLESPACE @ECMClient_TBLSPACE@TEMP
    TEMPFILE '@ECMClient_TBLSPACE@TEMP' SIZE 200M REUSE
    AUTOEXTEND ON NEXT 20M
    EXTENT MANAGEMENT LOCAL
;


-- Alter existing schema

ALTER USER @ECMClient_SCHEMA@
    DEFAULT TABLESPACE @ECMClient_TBLSPACE@
    TEMPORARY TABLESPACE @ECMClient_TBLSPACE@TEMP;

GRANT CONNECT, RESOURCE to @ECMClient_SCHEMA@;
GRANT UNLIMITED TABLESPACE TO @ECMClient_SCHEMA@;


-- Drop table

-- ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

-- DROP TABLE @ECMClient_SCHEMA@.CONFIGURATION;


-- Create table

ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

CREATE TABLE @ECMClient_SCHEMA@.CONFIGURATION (
        ID VARCHAR2(256) NOT NULL,
        ATTRIBUTES CLOB,
	CONSTRAINT ID_PK PRIMARY KEY (ID)
);


-- Create grant

ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

GRANT INSERT,UPDATE,SELECT,DELETE ON CONFIGURATION TO @ECMClient_SCHEMA@;


--

INSERT INTO @ECMClient_SCHEMA@.CONFIGURATION VALUES ('application.navigator', 'locales=ar,he,en,zh_CN,zh_TW,cs,hr,da,nl,fi,fr,de,el,hu,it,ja,ko,nb,pl,pt,pt_BR,ru,sk,sl,es,sv,th,tr,ro,kk,ca,vi;threadSleepTime=5;themes=azurite,cordierite,malachite,obsidian,quartz;plugins=;menus=;repositories=;desktops=admin;viewers=default;servers=cm,od,p8,cmis;key=871bf66c911f811fd48a6cc97aea40a4;objectExpiration=10;desktop=default');

INSERT INTO @ECMClient_SCHEMA@.CONFIGURATION VALUES ('settings.navigator.default', 'mobileAccess=true;logging.level=2;logging.excludes=com.ibm.ecm.configuration;iconStatus=docHold,docNotes,docMinorVersions,docDeclaredRecord,docBookmarks,docCheckedOut,workItemSuspended,workItemDeadlineImportance,workItemDeadlineReminderSent,workItemLocked,workItemCheckedOut;adminUsers=@ECMClient_ADMINID@');

INSERT INTO @ECMClient_SCHEMA@.CONFIGURATION VALUES ('desktop.navigator.admin', 'authenticationType=1;workflowNotification=false;fileIntoFolder=false;showSecurity=false;viewer=default;theme=;name=Admin Desktop;isDefault=Yes;menuPrefix=Default;applicationName=IBM Content Navigator;configInfo=;layout=ecm.widget.layout.NavigatorMainLayout;defaultFeature=ecmClientAdmin;actionHandler=ecm.widget.layout.CommonActionsHandler;servers=cm,od,ci,p8,cmis;repositories=');

INSERT INTO @ECMClient_SCHEMA@.CONFIGURATION VALUES ('version.navigator', 'version=3.0.1');



-- *****************************************************************
-- *****************************************************************
-- ECM TaskManager
-- *****************************************************************
-- *****************************************************************

-- Create table
ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

CREATE TABLE @ECMClient_SCHEMA@.APP_LOCK (id NUMBER NOT NULL, category VARCHAR2(30) NOT NULL, LOCK_STATUS NUMBER, objectID NUMBER, version NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASKAUDIT (id NUMBER NOT NULL, EVT_ACTION VARCHAR2(128), EVT_TS TIMESTAMP, EVT_INFO CLOB, EVT_TYPE VARCHAR2(128), originator VARCHAR2(380), status VARCHAR2(128), TASK_ID NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.BATCHES (id NUMBER NOT NULL, BATCH_DATA BLOB, CREATED_BY VARCHAR2(128), SEQ_ID NUMBER, START_TIME TIMESTAMP, status NUMBER, STOP_TIME TIMESTAMP, SUCCESS_CNT NUMBER, TASK_ID NUMBER, TOTAL_CNT NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.SERVER (id NUMBER NOT NULL, ACCESS_TIME TIMESTAMP, name VARCHAR2(80) NOT NULL, serverURL VARCHAR2(256), port NUMBER, PROC_ID NUMBER, protocol VARCHAR2(10), status NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASK (id NUMBER NOT NULL, AUTO_RESUME NUMBER, CREATED_BY VARCHAR2(128), description VARCHAR2(1024), END_TIME TIMESTAMP, HANDLER_NAME VARCHAR2(256) NOT NULL, LOCAL_STATE NUMBER, LOG_LEV VARCHAR2(8), name VARCHAR2(256) NOT NULL, NOTIFY_INFO CLOB, parent VARCHAR2(256), REPEAT_PERIOD NUMBER, SERVER_ID NUMBER, START_TIME TIMESTAMP, status NUMBER, STOP_TIME TIMESTAMP, SUCCESS_CNT NUMBER, TASK_INFO CLOB, TASK_MODE NUMBER, TIMER_HANDLE VARCHAR2(512), TOTAL_CNT NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASK_ERROR (id NUMBER NOT NULL, CREATE_TIME TIMESTAMP, ERROR_CODE NUMBER, ERROR_MSG VARCHAR2(1024), TASK_ID NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASK_EXREC (id NUMBER NOT NULL, SERVER_ID NUMBER, START_TIME TIMESTAMP, status NUMBER, STOP_TIME TIMESTAMP, SUCCESS_CNT NUMBER, EXEC_INFO CLOB, TASK_ID NUMBER, TOTAL_CNT NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASK_QUEUE (id NUMBER NOT NULL, CREATED_BY VARCHAR2(128), EXEC_TIME TIMESTAMP, status NUMBER, TASK_ID NUMBER NOT NULL, version NUMBER, PRIMARY KEY (id));
CREATE TABLE @ECMClient_SCHEMA@.TASK_SEQ_TABLE (ID VARCHAR2(256) NOT NULL, SEQUENCE_VALUE NUMBER(20) default NULL, PRIMARY KEY (ID));

INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('APP_LOCK', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('Server', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('TaskAudit', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('TASK_ERROR', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('TASK_QUEUE', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('Batches', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('Task', 4999);
INSERT INTO @ECMClient_SCHEMA@.TASK_SEQ_TABLE VALUES ('TASK_EXREC', 4999);

-- Create grant
ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

GRANT INSERT,UPDATE,SELECT,DELETE ON APP_LOCK TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASKAUDIT TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON BATCHES TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON SERVER TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASK TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASK_ERROR TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASK_EXREC TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASK_QUEUE TO @ECMClient_SCHEMA@;
GRANT INSERT,UPDATE,SELECT,DELETE ON TASK_SEQ_TABLE TO @ECMClient_SCHEMA@;

-- *****************************************************************
-- *****************************************************************
-- SYNC Services
-- *****************************************************************
-- *****************************************************************

-- Create the static tables required for sync and grant privileges

ALTER SESSION SET CURRENT_SCHEMA = @ECMClient_SCHEMA@;

--------------------------------------------------------------------
-- SYNCREPOSMAPPING
--------------------------------------------------------------------

CREATE TABLE @ECMClient_SCHEMA@.SYNCREPOSMAPPING (
	ID NUMBER  NOT NULL   ,
	TABLENAMEPREFIX VARCHAR2 (16)  NOT NULL ,
	REPOSID1 VARCHAR2 (36)  NOT NULL ,
	REPOSID2 VARCHAR2 (36)  NOT NULL ,
	CONNECTIONINFO VARCHAR2 (256) ,
	EVENTID VARCHAR2 (36)  NOT NULL ,
	REPOSTYPE NUMBER(5) DEFAULT 0  NOT NULL  ,
	LASTUPDATEID NUMBER DEFAULT 0  NOT NULL ,
	LASTMODRECEIVED TIMESTAMP ,
	MARKDELETED NUMBER(5) DEFAULT 0  NOT NULL  ,
    CODEMODULEREV SMALLINT ,
	CONSTRAINT CC1392679913540 PRIMARY KEY ( ID) ,
	CONSTRAINT CC1392679924904 UNIQUE ( TABLENAMEPREFIX)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE @ECMClient_SCHEMA@.SYNCREPOSMAPPING_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;

CREATE OR REPLACE TRIGGER @ECMClient_SCHEMA@.SYNCREPOSMAPPING_seq_tr
BEFORE INSERT ON @ECMClient_SCHEMA@.SYNCREPOSMAPPING
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT @ECMClient_SCHEMA@.SYNCREPOSMAPPING_seq.nextval INTO :NEW.ID FROM dual;
END;
/

GRANT INSERT, DELETE, UPDATE, SELECT ON @ECMClient_SCHEMA@.SYNCREPOSMAPPING TO @ECMClient_SCHEMA@;

--------------------------------------------------------------------
-- SYNCITEMS
--------------------------------------------------------------------

CREATE TABLE @ECMClient_SCHEMA@.SYNCITEMS (
	ID NUMBER  NOT NULL   ,
	NAME VARCHAR2 (256)  NOT NULL ,
	OBJECTID VARCHAR2 (36)  NOT NULL ,
	USERID VARCHAR2 (64)  NOT NULL ,
	DESKTOPID VARCHAR2 (64)  NOT NULL ,
	REPOSID NUMBER  NOT NULL ,
	LASTUPDATETS TIMESTAMP DEFAULT  SYSTIMESTAMP NOT NULL ,
	MARKDELETED NUMBER(5) DEFAULT 0  NOT NULL   ,
	CONSTRAINT CC1392680242650 PRIMARY KEY ( ID) ,
	CONSTRAINT CC1392680358320 FOREIGN KEY (REPOSID) REFERENCES SYNCREPOSMAPPING (ID)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE @ECMClient_SCHEMA@.SYNCITEMS_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;

CREATE OR REPLACE TRIGGER @ECMClient_SCHEMA@.SYNCITEMS_seq_tr
BEFORE INSERT ON @ECMClient_SCHEMA@.SYNCITEMS
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT @ECMClient_SCHEMA@.SYNCITEMS_seq.nextval INTO :NEW.ID FROM dual;
END;
/

GRANT INSERT, DELETE, UPDATE, SELECT ON @ECMClient_SCHEMA@.SYNCITEMS TO @ECMClient_SCHEMA@;

--------------------------------------------------------------------
-- DEVICEREGISTRY
--------------------------------------------------------------------

CREATE TABLE @ECMClient_SCHEMA@.DEVICEREGISTRY (
	ID NUMBER  NOT NULL   ,
	DEVICEID VARCHAR2 (36)  NOT NULL ,
	LASTPING TIMESTAMP ,
	MARKDELETED NUMBER(5) DEFAULT 0  NOT NULL   ,
	CONSTRAINT CC1392680754897 PRIMARY KEY ( ID) ,
	CONSTRAINT CC1392680759037 UNIQUE ( DEVICEID)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE @ECMClient_SCHEMA@.DEVICEREGISTRY_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;

CREATE OR REPLACE TRIGGER @ECMClient_SCHEMA@.DEVICEREGISTRY_seq_tr
BEFORE INSERT ON DEVICEREGISTRY
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT @ECMClient_SCHEMA@.DEVICEREGISTRY_seq.nextval INTO :NEW.ID FROM dual;
END;
/

GRANT INSERT, DELETE, UPDATE, SELECT ON @ECMClient_SCHEMA@.DEVICEREGISTRY TO @ECMClient_SCHEMA@;

--------------------------------------------------------------------
-- DEVICESYNCMAP
--------------------------------------------------------------------

CREATE TABLE @ECMClient_SCHEMA@.DEVICESYNCMAP (
	ID NUMBER  NOT NULL   ,
	DEVREGID NUMBER  NOT NULL ,
	SYNCITEMID NUMBER  NOT NULL ,
	MARKDELETED NUMBER(5) DEFAULT 0  NOT NULL   ,
	CONSTRAINT CC1392681213562 PRIMARY KEY ( ID) ,
	CONSTRAINT CC1392681269094 FOREIGN KEY (DEVREGID) REFERENCES DEVICEREGISTRY (ID)  ,
	CONSTRAINT CC1392681292746 FOREIGN KEY (SYNCITEMID) REFERENCES SYNCITEMS (ID)
);

-- Generate ID using sequence and trigger
CREATE SEQUENCE @ECMClient_SCHEMA@.DEVICESYNCMAP_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;

CREATE OR REPLACE TRIGGER @ECMClient_SCHEMA@.DEVICESYNCMAP_seq_tr
BEFORE INSERT ON @ECMClient_SCHEMA@.DEVICESYNCMAP
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT @ECMClient_SCHEMA@.DEVICESYNCMAP_seq.nextval INTO :NEW.ID FROM dual;
END;
/

GRANT INSERT, DELETE, UPDATE, SELECT ON @ECMClient_SCHEMA@.DEVICESYNCMAP TO @ECMClient_SCHEMA@;

--------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------
CREATE TABLE @ECMClient_SCHEMA@.SYNCCONFIGURATION (
	ID VARCHAR(256) NOT NULL,
	ATTRIBUTES CLOB,
	PRIMARY KEY(ID)
);

GRANT INSERT, DELETE, UPDATE, SELECT ON @ECMClient_SCHEMA@.SYNCCONFIGURATION TO @ECMClient_SCHEMA@;

-- Create extra indexes

CREATE INDEX I_DR_LASTPING_MARKDELETED ON @ECMClient_SCHEMA@.DEVICEREGISTRY ( LASTPING , MARKDELETED );
CREATE INDEX I_DSM_SYNCITEMID ON @ECMClient_SCHEMA@.DEVICESYNCMAP ( SYNCITEMID );
CREATE INDEX I_DSM_DEVREGID ON @ECMClient_SCHEMA@.DEVICESYNCMAP ( DEVREGID );
CREATE INDEX I_DSM_MARKDELETED ON @ECMClient_SCHEMA@.DEVICESYNCMAP ( MARKDELETED );
CREATE INDEX I_SI_REPOSID ON @ECMClient_SCHEMA@.SYNCITEMS ( REPOSID );
CREATE INDEX I_SI_UID ON @ECMClient_SCHEMA@.SYNCITEMS ( USERID );
CREATE INDEX I_SI_OID_UID ON @ECMClient_SCHEMA@.SYNCITEMS ( OBJECTID, USERID );
CREATE INDEX I_SRM_REP1_REP2_MARKDELETED ON @ECMClient_SCHEMA@.SYNCREPOSMAPPING ( REPOSID1 , REPOSID2 , MARKDELETED );

-- Load the initial application configuration into the table

INSERT INTO @ECMClient_SCHEMA@.SYNCREPOSMAPPING (TABLENAMEPREFIX, REPOSID1, REPOSID2, CONNECTIONINFO, EVENTID, LASTUPDATEID) VALUES ('NULL', 'NULL', 'NULL', 'NULL', 'NULL', 0);
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('sync.task.states', '{}');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_Property_SyncServerUrl', 'name=IcnSyncServerUrl;descr=sync server URL name;attributes=IcnSyncServerUrl');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncEventAction_DisplayName', 'name=Sync Event Action;descr=Sync Event Action display name;attributes=Sync Event Action');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncEventActionClass_ID', 'name=Action class P8 ID;descr=Filenet P8 action class ID;attributes={A8239821-CD3F-499D-8FAE-F2DA54AC5A99}');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncEventAction_FullyQualifiedClass', 'name=Event action class name;descr=Fully qualified event action handler class name;attributes=com.ibm.ecm.sync.core.store.p8.P8SyncEventActionHandler');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncEventActionClass_Name', 'name=IcnSyncEventAction;descr=Sync Event class name;attributes=IcnSyncEventAction');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncInstanceSubscriptionClass_ID', 'name=Sync instance subscription ID;descr=Filenet P8 instance subscription ID;attributes=DA09A1F1-65C4-4044-8ACA-5AF043BD61B4}');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncInstanceSubscriptionClass_Name', 'name=IcnSyncInstanceSubscription;descr=Instance subscription name;attributes=IcnSyncInstanceSubscription');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncCodeModule_ID', 'name=Sync Code module ID;descr=Filenet P8 Sync code module ID;attributes={9cf33dbe-600d-40c7-a8bb-351fa38ab5a6}');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.Constants.P8_SyncCodeModule_Name', 'name=Sync code module name;descr=Sync code module name;attributes=Sync Code Module');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.api.RepositoryController.publicSyncUrl', 'name=Public sync URL;descr=Public sync URL;attributes=http://localhost:9082/sync/notify');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.WebAppListener.poolSize','name=Internal task pool size;descr=Internal task pool size;attributes=3');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.WebAppListener.deviceCleanupInitialDelay', 'name=Initial deplay for the database clean up task;descr=Initial deplay for the database clean up task (in days);attributes=1');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.WebAppListener.deviceCleanupPeriod', 'name=Device clean up cycle time;descr=Device clean up cycle time (in days);attributes=7');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('com.ibm.ecm.sync.tools.cleanup.CleanupTask.deviceExpiration','name=Device expiration;descr=device expiration (in days);attributes=90');
INSERT INTO @ECMClient_SCHEMA@.SYNCCONFIGURATION ( ID, ATTRIBUTES ) VALUES ('synchdb.version','400');
-- COMMIT;
