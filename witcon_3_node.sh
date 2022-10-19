#/bin/bash

# Sep 25 2022 - changing the image from :$version to :2.15.2.0-b87
version=2.15.2.0-b87

function pause() 
{ 
 echo "\n Please press <return> key to continue ... \n" ; read -s -n 1 
}

# Verify docker running first 

docker ps -a 2> /dev/null

if [[ "$?" = "1" ]] 
then
  echo "\n Please run docker desktop first and re-run this \n" ; exit 1
fi


# Start of setting up the 3 node cluster for several scenarios.

docker network remove yb-net
docker network create -d bridge yb-net

# Bring up a 3 node cluster in docker containers. If you are on Mac on Arm64 chip and get a warning that the docker container was meant for Linux/x86-64, you can ignore it. Sending errors to bit bucket.

docker run -d --network yb-net --name yb-eu-1 -p5001:5433 -p7001:7000 -p9001:9000 yugabytedb/yugabyte:$version yugabyted start --daemon=false --listen yb-eu-1 \
 --master_flags="placement_zone=1,placement_region=eu,placement_cloud=cloud" \
 --tserver_flags="placement_zone=1,placement_region=eu,placement_cloud=cloud"  2>/dev/null

echo "\n Watch the cluster config 127.0.0.1:7001 after every container start up - takes about 10 seconds "

echo "\n After the first node creates the cluster, from http://localhost:7001/, # of Tserver = 1, Master =1, RF = 1"

pause

#sleep 15     Without a pause, put a wait - so that the new node can join the cluster

docker run -d --network yb-net --name yb-eu-2 -p5002:5433 -p7002:7000 -p9002:9000 yugabytedb/yugabyte:$version yugabyted start --daemon=false --listen yb-eu-2 --join yb-eu-1 \
 --master_flags="placement_zone=2,placement_region=eu,placement_cloud=cloud" \
 --tserver_flags="placement_zone=2,placement_region=eu,placement_cloud=cloud"  2>/dev/null

echo  "\n As the 2nd node joins the cluster, from http://localhost:7001/,  # of Tserver = 2, Master =2, RF = 1"

pause
#sleep 15

docker run -d --network yb-net --name yb-us-1 -p5003:5433 -p7003:7000 -p9003:9000 yugabytedb/yugabyte:$version yugabyted start --daemon=false --listen yb-us-1 --join yb-eu-1 \
 --master_flags="placement_zone=1,placement_region=us,placement_cloud=cloud" \
 --tserver_flags="placement_zone=1,placement_region=us,placement_cloud=cloud"  2>/dev/null

echo "\n When all 3 nodes are added, watch that the  number of Tserver = 3, Master =3, RF = 3. RF jumped from 1 to 3"


sleep 20


docker exec -i yb-eu-1 yb-admin -master_addresses yb-eu-1:7100,yb-eu-2:7100,yb-us-1:7100 modify_placement_info cloud.eu.1:1,cloud.eu.2:1,cloud.us.1:1 3


echo "\n Now with 3 nodes in the cluster, creating 3rd test table - this time will connect to the 3rd node"

ysqlsh -p 5003 -U yugabyte -ec "create table t1 ( c1 int ) " ;

echo "\n Watch that the t1 table has 3 tablets at localhost:9001/tables \n"