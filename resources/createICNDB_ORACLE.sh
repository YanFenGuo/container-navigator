#!/usr/bin/env bash

# The script to set Navigator datbase on Oracle
# Please create one oracle user(schema) for Navigator before executing the script
function print-help()
{
        echo "The script to set Navigator datbase on Oracle"
        echo "Please create one oracle user(schema) for Navigator before executing the script"
        echo "Usage: createICNDB_ORACLE.sh COMMAND"
        echo "Options:"
        echo " -s oracle user(schema) name            Existing oracle user for Navigator (e.g. icndb)"
        echo " -p oracle user password                Password of the oracle user"
        echo " -r URL for connecting to Oracle        Example: //localhost:1521/sample"
        echo " -t tablespace name                     Tablespace name to be created for Navigator database (e.g. ICNDB)"
        echo " -a navigator admin id                  Admin user name to login Navigator (e.g. P8Admin)"
        exit 1
}

if [ $# -lt 5 ]; then
    print-help
fi

while getopts ":s:p:r:t:a:" opt
do
        case $opt in
                s ) SCHEMA_NAME=$OPTARG
                    echo "ICN database user(schema) name: $SCHEMA_NAME";;
                p ) USER_PASSWORD=$OPTARG
                    echo "ICN database user password: $USER_PASSWORD";;    
                r ) URL_STRING=$OPTARG
                    echo "URL for connecting to Oracle: $URL_STRING";;  
                t ) TS_NAME=$OPTARG
                    echo "ICN database table space name: $TS_NAME";;
                a ) ICN_ADMIN_ID=$OPTARG
                    echo "ICN admin ID: $ICN_ADMIN_ID";;
                ? ) print-help
                    exit 1;;
        esac
done

# Update ORACLE_ONE_SCRIPT_ICNDB.sql
sed -i -e "s/@ECMClient_SCHEMA@/$SCHEMA_NAME/g" ORACLE_ONE_SCRIPT_ICNDB.sql
sed -i -e "s/@ECMClient_TBLSPACE@/$TS_NAME/g" ORACLE_ONE_SCRIPT_ICNDB.sql
sed -i -e "s/@ECMClient_ADMINID@/$ICN_ADMIN_ID/g" ORACLE_ONE_SCRIPT_ICNDB.sql

echo "COMMIT;" >> ORACLE_ONE_SCRIPT_ICNDB.sql
echo "EXIT;" >> ORACLE_ONE_SCRIPT_ICNDB.sql

# Call sqlplus to execute sql script
sqlplus $SCHEMA_NAME/$USER_PASSWORD@$URL_STRING @ORACLE_ONE_SCRIPT_ICNDB.sql
