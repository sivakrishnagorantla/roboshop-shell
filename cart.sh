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

VALIDATE $? "Setting up NPM source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NODEjs"

# once the user is created. if you run the script 2nd time
# this command will definetly fail
# how to improve: first check already exist or not then improve it
useradd roboshop &>>$LOGFILE

VALIDATE $? "Adding User"

# write a condition directory exist or not
mkdir /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "Downloading cart artifact"

cd /app &>>$LOGFILE

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "Unzipping cataloge file"

cd /app &>>$LOGFILE

npm install &>>$LOGFILE

VALIDATE $? "Installing dependencies"

#give full path of cart.service because we are inside /app
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "Copying cart service"

systemctl daemon-reload &>>$LOGFILE

systemctl enable cart &>>$LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "Starting cart"

 

