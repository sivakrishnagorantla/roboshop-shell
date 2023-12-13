#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp

SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$0DATE.log
USERID=$(id -u)
R="/e[31m"
G="/e[32m"
N="/e[0m"
Y="/e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this Script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $?

yum install nodejs -y &>>$LOGFILE

VALIDATE $?

# once the user is created. if you run the script 2nd time
# this command will definetly fail
# how to improve: first check already exist or not then improve it
useradd roboshop &>>$LOGFILE

# write a condition directory exist or not
mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

cd /app &>>$LOGFILE

unzip /tmp/catalogue.zip &>>$LOGFILE

cd /app &>>$LOGFILE

npm install &>>$LOGFILE

#give full path of catalogue.service because we are inside /app
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl enable catalogue &>>$LOGFILE

systemctl start catalogue &>>$LOGFILE

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

yum install mongodb-org-shell -y &>>$LOGFILE

mongo --host mongodb.sivakrishnaws.online </app/schema/catalogue.js &>>$LOGFILE






