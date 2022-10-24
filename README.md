# witcon_2022_yugabyte
Multi-region YugabyteDB with geo partitioning - Witcon 2022, Cleveland

Pre-requisites – Distributed SQL Workshop – Witcon Cleveland 2022
 
Most of the actual scripts below was borrowed from a [blog](https://dev.to/yugabyte/local-reads-from-yugabytedb-raft-followers-5mk) by Frank Pachot. I highly encourage readers to read [his](https://dev.to/franckpachot) blog to learn about Yugabyte and distributed databases.

As pre-requisite you will need docker running on your laptop.
Your laptop can be a MAC, Linux, or Windows with WSL2 installed. 
If you are on Windows and have not used WSL2 before - it can be tricky to install. 
In that case, getting a Cloud VM ( Ubuntu ) will be much easier.
 
If you have never used anything but windows - we will help you run command line.
 
 
For Windows
-----------

1.	Windows 10 or 11 with at least 8 GB memory.
2.	Install Docker desktop from here. Please note the new service agreement to use docker desktop
3.	Install WSL2 for your windows platform, follow the instructions from here
4.	Once WSL2 is installed, install Ubuntu on WSL2 from the above page
5.	Launch Docker Desktop for windows. Enable integration with WSL distro for Ubunto. In Settings | Resources | WSL integration 
6.	Then on WSL2 window run this command to download this docker image that will be used for the lab
-	docker pull yugabytedb/yugabyte:2.15.2.0-b87
7.	Install local Postgres on WSL2 
    - sudo apt update ; sudo apt install postgresql postgresql-contrib

For Mac
--------

1.	MacOS 11 and above, At least 8GB memory
2.	Install Docker desktop from here. Please note the new service agreement to use docker desktop
3.	Launch Docker Desktop for Mac. Then  run this command to download this docker image that will be used for the lab
4.	docker pull yugabytedb/yugabyte:2.15.2.0-b87
5.	Install local Postgres ( will need to use the client psql command only to connect to docker Yugabytedb ) - brew install postgres

 
For Cloud VM - Ubuntu
---------------------
 
Create an Ubuntu VM :

1.	It should have docker client installed already
2.  Run this command to download this docker image that will be used for the lab
-	sudo docker pull yugabytedb/yugabyte:2.15.2.0-b87	

3.	Install Postgresql – 
-    sudo apt update ; sudo apt install postgresql postgresql-contrib

After completing the pre-requisites
----------------------------------

1. Run this script first. Watch the script output. If you get an error on running docker then try running "sudo docker" instead of docker
    - bash witcon_3_node.sh
2. Next, run this script
    - bash witcon_geo_dist.sh