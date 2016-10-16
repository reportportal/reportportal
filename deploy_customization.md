# Custom Deployment and Production Recommended Set 

- [Production readiness](https://github.com/reportportal/reportportal/blob/master/installation.md#production-readiness)
- [System requirements](https://github.com/reportportal/reportportal/blob/master/installation.md#system-requirements)
- [Linux server  tuning](https://github.com/reportportal/reportportal/blob/master/installation.md#linux-server-tuning)

### Production readiness

You can use the Report Portal appliances (Docker) for small production setups but please consider to harden the security of the box before.

- Set another password for the default ubuntu/linux user
- Disable remote password logins in /etc/ssh/sshd_config and deploy proper ssh keys
- Seperate the box network-wise from the outside, otherwise Elasticsearch can be reached by anyone
- add additional RAM to the appliance and raise the java heap!
- add additional HDD to the appliance and extend disk space. Mount external disk space.
- add the appliance to your monitoring and metric systems.

If you want to create your own customised setup take a look at our [other installation methods]().

### Production set

//TODO
* description
* image
* steps with compose links

### System software prerequisites 

The Report Portal server application has the following prerequisites:

- Some modern Linux distribution (Debian Linux, Ubuntu Linux, or CentOS recommended)
- [MongoDB 3.0.+ or later](https://docs.mongodb.com/manual/administration/install-community/) (latest stable version is recommended)

### System requirements

//TODO

### Linux server tuning
>mostly related to server with MongoDB

If you are going to use ReportPortal by a lot of users, probably, you need to increase limits for open files \ file descriptors under Linux OS. Following example will show how to increase this limit under CentOS:

There is possibility to setup limits for specified user and\or group. So...

1.  Open limits.conf file

2.  ``` [root@server /]# vi /etc/security/limits.conf  ```

3.  Add specified limits, for example following will setup limits in 65535 open `files\file` descriptors:
  ```Shell
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
