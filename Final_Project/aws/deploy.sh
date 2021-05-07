#!/usr/bin/env bash

# fetch config from AWS for currently running infrastructure
source ./load_lab_config.sh

NOW=$(date '+%Y%m%d%H%M%S')
LOGFILE="./deploy-${NOW}.log"

echo "Deploying Full AWS infrastructure for ${APP_TAG_NAME}:${APP_TAG_VALUE}" | tee ${LOGFILE}
echo "Running deploy.sh at ${NOW}" | tee -a ${LOGFILE}

PROG="../multi-node-threaded/target/multi-node-threaded-2.0-jar-with-dependencies.jar"

INSTANCES_IDS_ARRAY=$(echo $INSTANCES_IDS | tr " " "\n")
for instance in $INSTANCES_IDS_ARRAY
do
  instance_id=${instance}
done
#aws ec2 associate-address --instance-id ${instance_id} --allocation-id ${ELASTIC_ID} --allow-reassociation

# get public IP addresses of the instances (in the public subnet)
INSTANCES_IPS=$(aws ec2 describe-instances ${PREAMBLE} --filters Name=instance-state-name,Values=running Name=tag:${APP_TAG_NAME},Values=${APP_TAG_VALUE} --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text | tr '\n' ' ')
echo "Public IP addresses: ${INSTANCES_IPS}" | tee -a ${LOGFILE}

for host in ${INSTANCES_IPS}
do
	echo "Copying over ${PROG} to ${USER}@${host}:~/ ..." | tee -a ${LOGFILE}
	scp -i ${KEY_FILE} ${PROG} ${USER}@${host}:~/ | tee -a ${LOGFILE}
	#ssh -i ${KEY_FILE} ${USER}@${host} "sudo amazon-linux-extras install java-openjdk11" | tee -a ${LOGFILE}
    #ssh -i ${KEY_FILE} ${USER}@${host} "mkdir multi-node-threaded"
    #ssh -i ${KEY_FILE} ${USER}@${host} "aws configure"
done
echo "Done." | tee -a ${LOGFILE}



exit 0