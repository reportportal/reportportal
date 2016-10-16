# Installation steps 

- [Linux server  tuning](https://github.com/reportportal/reportportal/blob/master/installation.md#linux-server-tuning)
- [Report Portal deploy](https://github.com/reportportal/reportportal/blob/master/installation.md#reportportal-application-installation)
- [Production readiness](https://github.com/reportportal/reportportal/blob/master/installation.md#production-readiness)
- [System requirements](https://github.com/reportportal/reportportal/blob/master/installation.md#system-requirements)

## Linux server tuning


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
