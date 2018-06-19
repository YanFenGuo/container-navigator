# container-navigator
Instructions for preparing and initializing Content Navigator database.

## DB2

You can use the provided sample database scripts to create and configure the IBM Content Navigator database on the DB2 server: [createICNDB.sh](https://github.com/ibm-ecm/container-navigator/blob/master/resources/createICNDB.sh). <br>

Give proper privileges to the shell script:  
```
chmod 755 createICNDB.sh
```

On Linux, run the following shell (replace the parameters with the values for your system):  
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

