# Set up a table with geo distribution of a table. 
# Bring up multi-region database first - docker 

# sh witcon_3_node.sh

# verify multi region setup
function pause() 
{ 
 echo "\n Please press <return> key to continue ... \n" ; read -s -n 1 
}

echo "\n Now that we have a 3 node cluster, let's ensure that we have all the nodes visibile \n"
pause

# sleep 15
psql -e -p 5001 -h localhost -U yugabyte -c "select * from yb_servers();"

#
# host   | port | num_connections | node_type | cloud | region | zone | public_ip 
#--------------------------------------------------------------------------------
# yb-us-1 | 5433 |               0 | primary   | cloud | us     | 1    | yb-us-1
# yb-eu-2 | 5433 |               0 | primary   | cloud | eu     | 2    | yb-eu-2
# yb-eu-1 | 5433 |               0 | primary   | cloud | eu     | 1    | yb-eu-1

# Ensure that the clusters have RF3 setup - until you run this command below you cannot create any table  */

docker exec -i yb-eu-1 yb-admin -master_addresses yb-eu-1:7100,yb-eu-2:7100,yb-us-1:7100 modify_placement_info cloud.eu.1:1,cloud.eu.2:1,cloud.us.1:1 3


# Create table with list partitions - partitoion by location column. 
# Notice that there is no preferred leader is picked and no follower read etc. */

pause

echo "\n Remember based on how the ports are mapped for docker 

port 5001 - EU1
port 5002 - EU2
port 5003 - US1

"
pause
echo "\n First we are creating a transactions table that is partitioned by list on location column \n"

psql -e -p 5001 -h localhost -U yugabyte <<SQL 


CREATE TABLE transactions (
  user_id       INT NOT NULL,
  account_id	    INT NOT NULL,
  location TEXT,
  account_type  TEXT NOT NULL,
  amount        NUMERIC NOT NULL,
  created_at    TIMESTAMP DEFAULT NOW()
) PARTITION BY LIST (location);

SQL

pause
echo "\n Create three tablespaces on different cloud / region / zone combination \n"

psql -e -p 5001 -h localhost -U yugabyte <<SQL 

CREATE TABLESPACE ts_eu1 WITH (
  replica_placement='{"num_replicas": 1, "placement_blocks":
  [{"cloud":"cloud","region":"eu","zone":"1","min_num_replicas":1} ]}');

CREATE TABLESPACE ts_eu2 WITH (
  replica_placement='{"num_replicas": 1, "placement_blocks":
  [{"cloud":"cloud","region":"eu","zone":"2","min_num_replicas":1} ]}');

CREATE TABLESPACE ts_us1 WITH (
  replica_placement='{"num_replicas": 1, "placement_blocks":
  [{"cloud":"cloud","region":"us","zone":"1","min_num_replicas":1} ]}');

SQL

# Verify the tablespaces 

pause
echo "\n Now let's verify the new tablespaces created  \n"

psql -e -p 5001 -h localhost -U yugabyte -c  "\db+"


echo "\n Now we create partition child tables in each tablespace based on location column value \n"

pause
psql -e -p 5001 -h localhost -U yugabyte <<SQL 

CREATE TABLE transactions_eu1 PARTITION OF transactions
    (user_id, account_id, location, account_type, amount, created_at,
    PRIMARY KEY (user_id HASH, account_id, location))
  FOR VALUES IN ('EU1') TABLESPACE ts_eu1 ;

CREATE TABLE transactions_eu2 PARTITION OF transactions
    (user_id, account_id, location, account_type, amount, created_at,
    PRIMARY KEY (user_id HASH, account_id, location))
  FOR VALUES IN ('EU2') TABLESPACE ts_eu2 ;

CREATE TABLE transactions_us1 PARTITION OF transactions
    (user_id, account_id, location, account_type, amount, created_at,
    PRIMARY KEY (user_id HASH, account_id, location))
  FOR VALUES IN ('US1') TABLESPACE ts_us1 ;

SQL

pause


echo "\n Finally we will insert one row for each location \n"

pause
psql -e -p 5001 -h localhost -U yugabyte <<SQL 

INSERT INTO transactions VALUES (100, 10001, 'EU1', 'checking', 100);

INSERT INTO transactions VALUES (200, 20002, 'EU2', 'checking', 100);

INSERT INTO transactions VALUES (300, 30003, 'US1', 'checking', 100);

SQL


# Verification of geo-locality - connect to EU1 but querying for EU1 - does a partition scan

echo "\n Geo-locality verification two ways -one by getting a query plan for EU1 records \n"
pause
psql -e -p 5001 -h localhost -U yugabyte -c  "explain analyze select * from transactions where location = 'EU1';" 

# If you use this function, connecting to EU1 that as local table you get only EU1 and EU2 but not US1 record

echo "\n Next we wull use yb_is_local - that returns all the data for the same region - EU1 and EU2 both but not US region \n"
pause
psql -e -p 5001 -h localhost -U yugabyte -c "select location from transactions where yb_is_local_table(transactions.tableoid) ;"

# Notice that what goes in yb_is_local_table is the parent table name not the partition table, i.e. transactoins not transactions_us1

echo "\n Another way to query the tablespaces   \n"
pause

psql -e -p 5001 -h localhost -U yugabyte -c "select tableoid::regclass as tablespace, location from transactions ;"

pause
echo "\n Thank you - this is the end of this lab and demo \n"







