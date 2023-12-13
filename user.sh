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

VALIDATE $? "Downloading nodejs"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop &>>$LOGFILE

VALIDATE $? "Adding User"

mkdir /app &>>$LOGFILE

VALIDATE $? "Creating the directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Downloading user articraft"

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "Unzipping userfile"

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app folder"

npm install &>>$LOGFILE 

VALIDATE $? "Installing dependies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "Copying user.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reloaded"

systemctl enable user &>>$LOGFILE 

VALIDATE $? "Enabling user"

systemctl start user &>>$LOGFILE

VALIDATE $? "Starting User"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing mongo client"

mongo --host mongodb.sivakrishnawsdevops.online </app/schema/user.js &>>$LOGFILE