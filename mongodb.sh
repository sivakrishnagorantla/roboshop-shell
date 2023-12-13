#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp

SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this Script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? " Copied mongoDB repo into yum.repos.d"

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "Installation of Mongodb"

systemctl enable mongod &>>$LOGFILE

VALIDATE $? "Enabling Mongod"

systemctl start mongod &>>$LOGFILE

VALIDATE $? "Starting Mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE

VALIDATE $? "Eited Mongod"

systemctl restart mongod &>>$LOGFILE

VALIDATE $? "Restarted Mongod"