FROM centos7
MAINTAINER satish736
WORKDIR /usr/local/
RUN yum install java -y
CMD wget http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.11/bin/apache-tomcat-9.0.11.tar.gz
CMD tar -xvf apache-tomcat-9.0.11.tar.gz
CMD mv apache-tomcat-9.0.11 tomcat
COPY content.xml /usr/local/tomcat/content.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY lib /usr/local/tomcat/lib
CMD ./tomcat/bin/startup.sh
