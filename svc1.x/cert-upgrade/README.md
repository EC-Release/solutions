## Cert Upgrade

End-to-end process to upgrade certs of EC services in cloud foundry.

### Generate new certs

Follow process metioned [here](https://github.com/EC-Release/certifactory/blob/beta/README.md) to generate new pair of private and public key(cert)

### Upgrade Certs

The [script](https://github.com/EC-Release/solutions/blob/px-cert-upgrade/svc1.x/cert-upgrade/update_cert.sh) is provided to get list of service instances and update cert for all instances.

#### Login to cf

- Login to the cf org and space where EC service instance are present e.g. for cf1 org - DigitalConnect space - enterprise-connect

```
cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
```

#### List all service instances

- Get list of all the EC service instances in this org and space

```
cf a | grep -E 'started' | awk '{print $1}'
```

#### Update envs for service instance

- Provide the value for PVT_KEY, PUB_KEY and SVC_PWD in following command

```
cf set-env $zone EC_PRVT_KEY "${PVT_KEY}"

cf set-env $zone EC_PUB_KEY "${PUB_CRT}"

cf set-env $zone EC_PRVT_PWD "${SVC_PWD}"
```

#### Restage instance

- Restage the service instance 

```
cf restage $zone
```
