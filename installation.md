# Installation steps 

- [Java installation](https://github.com/reportportal/reportportal/blob/master/installation.md#java-installation)
- [Docker installation](https://github.com/reportportal/reportportal/blob/master/installation.md#docker-installation)
- [MongoDB installation](https://github.com/reportportal/reportportal/blob/master/installation.md#mongodb-installation-optional)
- [Linux server  tuning](https://github.com/reportportal/reportportal/blob/master/installation.md#linux-server-tuning)
- [Report Portal deploy](https://github.com/reportportal/reportportal/blob/master/installation.md#reportportal-application-installation)
- [Production readiness](https://github.com/reportportal/reportportal/blob/master/installation.md#production-readiness)
- [System requirements](https://github.com/reportportal/reportportal/blob/master/installation.md#system-requirements)

## Java installation


For configuration Java on server we need to download it first from [Java download page](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
Latest ReportPortal build is using Java 8 (Latest release is Java 8u66 on article creation moment).

Create directory for java place and download Java archive under, for example, ``/usr/java`` directory.
```Shell
[root@server ~]# mkdir /usr/java
[root@server ~]# cd /usr/java/
```

Unpack Java archive:

```Shell
[root@server java]# tar -xzf jdk-8u66-linux-x64.tar.gz
```

Then create Java environment variables for users. Add it in `/etc/profile` and then source it to give to all users:

```Shell
JAVA_HOME=/usr/java/jdk1.8.0_66
export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH
export PATH
```


## Docker installation

To run ReportPortal with Docker, Docker Engine and Docker Compose must be installed. 
Please, refer to official documentation:
* [Docker Engine Installation](https://docs.docker.com/engine/installation/)
* [Docker Compose Installation](https://docs.docker.com/compose/install/)

>Note: Docker Compose is optional. It's possible to run containers using plain `docker run` mechanism and link it to each other

## MongoDB installation (optional)

MongoDB can be installed outside of container infrastructure. This recommended for production with huge load.

**3.0.x version is required!**

The next step is installation of MongoDB on server. General installation process is described on official MongoDB page: [MongoDB Installation
Guide](<https://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat/>)

But here are quick steps that we need:

**STEP-1.** 

Create a `/etc/yum.repos.d/mongodb.repo` file to hold the following configuration information for the MongoDB repository:

If you are running a 64-bit system, use the following configuration:

```Shell
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
```

**STEP-2.** 

When you install the packages, you choose whether to install the current release or a previous one. We just decide to use latest one, to install the latest stable version of MongoDB, issue the following command:

```Shell
[root@server /]# sudo yum install -y mongodb-org
```

**STEP-3.** 

Before starting to use MongoDB with ReportPortal, we need to create admin user for MongoDB and separate admin user for 'reportportal' database data. By default MongoDB installed without authentication.
Report Portal services which require DB access, use the following set of properties:

```Shell
rp.mongo.host - MongoDB server host (by default: localhost)
rp.mongo.port - exposed port for MongoDB connection (by default: 27017)
rp.mongo.dbname - database name (by default: reportportal)
rp.mongo.user - target database user login (by default: user)
rp.mongo.password - target database user password (by default: 1q2w3e)
```

Provided information in Report Portal server configuration should be the same as for following steps (if you change config then appropriate changes should be reflected for MongoDB server as well).
In server shell please use following commands to cover above configuration:

Start MongoDB service (if it's not started):

```Shell
[root@server /]# service mongod start
```

Then go to mongo shell (Mongo invitation should be appeared after):

```Shell
[root@server /]# mongo
MongoDB shell version: 3.2.0
connecting to: test
```

Please use following commands for creating general database administrator and reportportal database user:

Mongo shell
```JSON
use admin
db.createUser(
  {
    user: "admin",
    pwd: "PASS",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
use reportportal
db.createUser(
  {
    user: "user",
    pwd: "PASS",
    roles: [ "userAdmin", "dbAdmin", "readWrite" ]
  }
)
exit
```

Then stop MongoDB service:

```Shell
[root@server /]# service mongod stop
```

**STEP-4.** 

Enabling authentication mechanism and external access to database.
Minor update is required for MongoDB configuration file. Please follow next commands from server shell:

```Shell
[root@server /]# vim /etc/mongo.conf
```

And put following parameters into config:

```Shell
auth = true
bind_ip = 0.0.0.0
port = 27017
```

**STEP-5.** 

You must configure SELinux to allow MongoDB to start on Red Hat Linux-based systems (Red Hat Enterprise Linux or CentOS Linux).
To configure SELinux, administrators have three options:

>All three options require **root** privileges. The first two options each requires a system reboot and may have larger implications for your deployment.

- Disable SELinux entirely by changing the SELINUX setting to disabled in **/etc/selinux/config**.

```Shell
SELINUX=disabled
```

- Set SELinux to permissive mode in `/etc/selinux/config` by changing the SELINUX setting to permissive.

```Shell
SELINUX=permissive
```


>You can use **setenforce** to change to permissive mode; this method does not require a reboot but is **not** persistent.


Enable access to the relevant ports (e.g. 27017) for SELinux if in enforcing mode. See [Default MongoDB Port](<https://docs.mongodb.org/manual/reference/default-mongodb-port/>) for more information on MongoDB’s default ports. For default settings, this can be accomplished by running

```Shell
semanage port -a -t mongod_port_t -p tcp 27017
```


>On RHEL 7.0, if you change the data path, the _default_ SELinux policies will prevent [mongod](<https://docs.mongodb.org/manual/reference/program/mongod/#bin.mongod>) from having write access on the new data path if you do not change the security context.


You may alternatively choose not to install the SELinux packages when you are installing your Linux operating system, or choose to remove the relevant packages. This option is the most invasive and is not recommended.

**STEP-6.** 

Now MongoDB can be launched by console command as:

```Shell
[root@server /]# service mongod start
```

>The following commands are available for service monitoring

```Shell
#Start mongo service
service mongod start 
#Stop mongo service
service mongod stop
#Check mongo service status
service mongod status 
```



Linux server tuning
-------------------

If you are going to use ReportPortal by a lot of users, probably, you need to increase limits for open files \ file descriptors under Linux OS. Following example will show how to increase this limit under CentOS:

There is possibility to setup limits for specified user and\or group. So...

1.  Open limits.conf file

2.  ``` [root@server /]# vi /etc/security/limits.conf  ```

3.  Add specified limits, for example following will setup limits in 65535 open 'files\file' descriptors:
  ```
  #<domain> <type> <item> <value>
  * soft nproc 65535
  * hard nproc 65535
  ```


4.  Or for specified user:
  ```Shell
   #<domain> <type> <item> <value> 
   httpd soft nproc 65535 
   httpd hard nproc 65535
  ```


## ReportPortal application installation


And, finally, easiest part of installation guide.

1. Download \*.war application archive from [EPAM artifactory](<http://artifactory.epam.com/artifactory/simple/EPMC-TST/com/epam/ta/reportportal/ws/>). 
  - If file name differ than **reportportal-ws.war** - please rename it.

2. Copy it under `/usr/share/apache-tomcat-7.0.\<version\>/webapps`.
3. Please be sure than MongoDB service has working:

  ```Shell
  [root@server /]# service mongod status
  mongod (pid 1426) is running...
  ```

4. TFS external integration **(required even you not use it, this will be fixed in next releases)**: 

Initial configuration for TFS native libraries is setup as: 

```Shell
com.ta.reportportal.tfs.native=/etc/reportportal/tfs/native 
```

Please download latest version of TFS SDK and put 'native' folder under configured path (we have tested RP for 14.0.1 version). Or place into new one and re-configure Report Portal server application.
So for default config please perform next steps:

```Shell
[root@server /]# cd etc/
[root@server /]# mkdir reportportal
[root@server /]# cd reportportal
[root@server /]# mkdir tfs
[root@server /]# cd tfs
[root@server /]# cp -R {unziped_tfs_sdk}/redist/native .
```

Also put in tomcat lib folder Microsoft jar lib from the same SDK from 'lib' folder. For example it could be looks like:

```Shell
[root@server /]# cp -R {unziped_tfs_sdk}/redist/lib/com.microsoft.tfs.sdk-14.0.1.jar /usr/share/apache-tomcat-7.0.<version>/lib/com.microsoft.tfs.sdk-14.0.1.jar
```

**STEP-5.** Restart Tomcat. ReportPortal automaticaly create minimum database scheme during deployment:

```Shell
[root@server /]# service tomcat restart
```


## Production readiness

You can use the Report Portal appliances (Docker) for small production setups but please consider to harden the security of the box before.

- Set another password for the default ubuntu/linux user
- Disable remote password logins in /etc/ssh/sshd_config and deploy proper ssh keys
- Seperate the box network-wise from the outside, otherwise Elasticsearch can be reached by anyone
- add additional RAM to the appliance and raise the java heap!
- add additional HDD to the appliance and extend disk space. Mount external disk space.
- add the appliance to your monitoring and metric systems.

If you want to create your own customised setup take a look at our [other installation methods]().


## System requirements

The Report Portal server application has the following prerequisites:

- Some modern Linux distribution (Debian Linux, Ubuntu Linux, or CentOS recommended)
- [MongoDB 3.0.+ or later](https://docs.mongodb.com/manual/administration/install-community/) (latest stable version is recommended)
- [Oracle Java SE 8 or later](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([OpenJDK 8] also works; latest stable update is recommended)
