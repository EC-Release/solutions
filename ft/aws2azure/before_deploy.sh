#!/bin/bash

git clone https://$gitlabuser:$gitlabtoken@gitlab.com/Srikakulapu/terraform-input.git
pwd && ls -l
sudo mv terraform-input/ec-file-transfer.tfvars /usr/ec-file-transfer.tfvars
ls -l /usr/
export AWS_ACCESS_KEY_ID=$AWSACCESKEYID
export AWS_SECRET_ACCESS_KEY=$AWSSECRETKEYID
export AWS_DEFAULT_REGION=$AWSREGION
export ARM_CLIENT_ID=$AZUSER
export ARM_CLIENT_SECRET=$AZPWD
export ARM_SUBSCRIPTION_ID=$AZSUBSCRIPTIONID
export ARM_TENANT_ID=$AZTENANTID
