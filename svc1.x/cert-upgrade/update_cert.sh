cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
cf a | grep -E 'started' | awk '{print $1}'| while read -r zone
do
cf set-env $zone EC_PRVT_KEY "${PVT_KEY}"

cf set-env $zone EC_PUB_KEY "${PUB_CRT}"

cf set-env $zone EC_PRVT_PWD "${SVC_PWD}"

cf restage $zone
done