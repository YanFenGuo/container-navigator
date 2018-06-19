# container-navigator
Instructions for preparing and initializing Content Navigator database.

## DB2

1. Create a staging folder on db2 server using db2 os user (e.g. db2inst1).

2. Copy the following files to the staging folder of DB2 server: [createICNDB.sh](https://github.com/ibm-ecm/container-navigator/blob/master/resources/createICNDB.sh), [DB2_CREATE_SCRIPT.sql](https://github.com/ibm-ecm/container-navigator/blob/master/resources/DB2_CREATE_SCRIPT.sql) and [DB2_ONE_SCRIPT_ICNDB.sql](https://github.com/ibm-ecm/container-navigator/blob/master/resources/DB2_ONE_SCRIPT_ICNDB.sql)<br>

3. Give proper privileges to the shell script:  
```
chmod 755 createICNDB.sh
```

4. On DB2 server, run the following shell (replace the parameters with the values for your system):  
```
su <db2_os_user>
./createICNDB.sh -n <database_name> -s <schema_name> -t <tablespace_name> -u <database_user> -a <navigator_admin_id>
```
Example:
```
su db2inst1
./createICNDB.sh -n ICNDB -s ICNSCHEMA -t ICNTS -u db2inst1 -a p8admin
```

The parameters are explained in the following table:

Name | Description | Required | 
------------ | ------------- | ------------- | 
n | Navigator database name | Yes | 
s | Navigator database schema name | Yes | 
t | Navigator database tablespace name | Yes | 
u | Navigator database user name | Yes | 
a | Navigator admin ID | Yes | 

## Oracle

1. Create Oracle user (e.g. p8user) and create Oracle database for Navigator (e.g. icndb)

2. Create a staging folder on oracle client where sqlplus is installed.

3. Copy [createICNDB_ORACLE.sh](https://github.com/ibm-ecm/container-navigator/blob/master/resources/createICNDB_ORACLE.sh) and [ORACLE_ONE_SCRIPT_ICNDB.sql](https://github.com/ibm-ecm/container-navigator/blob/master/resources/ORACLE_ONE_SCRIPT_ICNDB.sql) to staging folder

4. Give proper privileges to the shell script:  
```
chmod 755 createICNDB.sh
``` 

5. Run the following shell (replace the parameters with the values for your system):  
```
./createICNDB_ORACLE.sh -s <database_user> -p <password> -r //<oracle_server_ip>:<oracle_server_port>/<database_name> -t <tablespace_name> -a <navigator_admin_id>
```

Example:
```
./createICNDB_ORACLE.sh -s p8user -p password -r //localhost:1521/icndb -t ICNTS -a p8admin
```

The parameters are explained in the following table:

Name | Description | Required | 
------------ | ------------- | ------------- | 
s | Oracle user(schema) name | Yes | 
p | Oracle user password | Yes | 
r | URL for connecting to Oracle | Yes | 
t | Navigator database tablespace name | Yes | 
a | Navigator admin ID | Yes | 