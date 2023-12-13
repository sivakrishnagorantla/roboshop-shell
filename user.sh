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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

yum install nodejs -y &>>$LOGFILE

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

cd /app &>>$LOGFILE

unzip /tmp/user.zip &>>$LOGFILE

cd /app &>>$LOGFILE

npm install &>>$LOGFILE 

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl enable user &>>$LOGFILE 

systemctl start user &>>$LOGFILE

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

yum install mongodb-org-shell -y &>>$LOGFILE

mongo --host mongodb.sivakrishnawsdevops.online </app/schema/user.js &>>$LOGFILE