#!/bin/bash
yum update -y
yum install amazon-linux-extras go -y
cd /var/tmp
mkdir APP
cd APP

wget https://github.com/servian/TechChallengeApp/releases/download/v.0.9.0/TechChallengeApp_v.0.9.0_linux64.zip
unzip TechChallengeApp_v.0.9.0_linux64.zip

cd dist
VTT_DBPASSWORD=`aws ssm get-parameter --name "dbpassword" --with-decryption --region ap-southeast-2 --output text --query Parameter.Value`
VTT_DBHOST=`aws ssm get-parameter --name "dbhost" --with-decryption --region ap-southeast-2 --output text --query Parameter.Value`
listenhost=`ec2-metadata --local-ipv4`
VTT_LISTENHOST=`echo $listenhost | cut -d ' ' -f2`
VTT_LISTENPORT=3000
VTT_DBNAME="app"
VTT_DBPORT=5432
VTT_DBUSER="postgre"

rm -f conf.toml

cat>>conf.toml<<EOF 
"DbUser" = "$VTT_DBUSER" 
"DbPassword" = "$VTT_DBPASSWORD"
"DbName" = "$VTT_DBNAME"
"DbPort" = "$VTT_DBPORT"
"DbHost" = "$VTT_DBHOST"
"ListenHost" = "$VTT_LISTENHOST"
"ListenPort" = "$VTT_LISTENPORT"
EOF

./TechChallengeApp updatedb -s
./TechChallengeApp serve