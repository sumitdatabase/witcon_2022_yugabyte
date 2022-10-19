# witcon_2022_yugabyte
Multi-region YugabyteDB with geo partitioning - Witcon 2022, Cleveland

Pre-requisites – Distributed SQL Workshop – Witcon Cleveland 2022
 

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
5.	In Ubunto (WSL2) ,Download Yugabytedb - as root, run these commands
1.	cd /opt
2.	sudo wget https://downloads.yugabyte.com/releases/2.15.2.0/yugabyte-2.15.2.0-b87-linux-x86_64.tar.gz
3.	tar xvfz yugabyte-2.15.2.0-b87-linux-x86_64.tar.gz && cd yugabyte-2.15.2.0/
4.	./bin/post_install.sh
6.	As non-root user, add this directly to your path
1.	export PATH=$PATH:/opt/yugabyte-2.15.2.0/bin
7.	Launch Docker Desktop for windows. Enable integration with WSL distro for Ubunto. In Settings | Resources | WSL integration 

 


8.	Then on WSL2 window run this command to download this docker image that will be used for the lab
-	docker pull yugabytedb/yugabyte:2.15.2.0-b87

9.	Install local Postgres ( will need to use the client psql command only to connect to docker Yugabytedb ) - https://www.postgresql.org/download/windows/ 


For Mac
--------

1.	MacOS 11 and above, At least 8GB memory
2.	Install Docker desktop from here. Please note the new service agreement to use docker desktop
3.	Download Yugabytedb - as root, run these commands
1.	cd /opt
2.	curl -O  https://downloads.yugabyte.com/releases/2.15.2.0/yugabyte-2.15.2.0-b87-darwin-x86_64.tar.gz
3.	tar xvfz yugabyte-2.15.2.0-b87-darwin-x86_64.tar.gz
4.	As non-root user, add this directly to your path
5.	Launch Docker Desktop for Mac. Then  run this command to download this docker image that will be used for the lab
1.	docker pull yugabytedb/yugabyte:2.15.2.0-b87
6.	Install local Postgres ( will need to use the client psql command only to connect to docker Yugabytedb ) - brew install postgres

 
For Cloud VM - Ubuntu
---------------------
 
Create an Ubuntu VM :

1.	It should have docker client installed already
2.	Install Yugabytedb

a)      cd /opt
b)      sudo wget  https://downloads.yugabyte.com/releases/2.15.2.0/yugabyte-2.15.2.0-b87-linux-x86_64.tar.gz
c)      sudo tar xvfz yugabyte-2.15.2.0-b87-linux-x86_64.tar.gz && cd yugabyte-2.15.2.0/
d)      sudo ./bin/post_install.sh 
a.	sudo docker pull yugabytedb/yugabyte:2.15.2.0-b87

3.	Install Postgresql – 


sudo apt update
sudo apt install postgresql postgresql-contrib

