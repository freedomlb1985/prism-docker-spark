FROM sequenceiq/hadoop-docker:2.7.1
MAINTAINER Frey

############################################################## Additional module by frey #################################################################################
#RUN yum update -y
#RUN yum upgrade -y
RUN yum install -y byobu curl htop man unzip nano wget vim
#RUN rpm -e cracklib-dicts --nodeps
RUN yum install cracklib-dicts
RUN yum clean all
#RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
#RUN tar -xzvf jdk-8u151-linux-x64.tar.gz -C /usr/local/

RUN curl -L http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz  -H 'Cookie: oraclelicense=accept-securebackup-cookie'  -H "Connection: keep-alive" -O
RUN tar -xzvf jdk-8u151-linux-x64.tar.gz -C /usr/local/
ENV JAVA_HOME /usr/local/jdk1.8.0_151
ENV PATH ${JAVA_HOME}/bin:$PATH



##########################################################################################################################################################################

#support for Hadoop 2.6.0
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.2.0-bin-hadoop2.7 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.2.0-bin-hadoop2.7/jars /spark  && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.2.0-bin-hadoop2.7/examples/jars /spark 

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY deploy-start.sh /etc/deploy-start.sh
COPY deploy-stop.sh /etc/deploy-stop.sh
COPY slaves $HADOOP_PREFIX/etc/hadoop/slaves
COPY slaves $SPARK_HOME/conf/slaves
COPY yarn-remote-client/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml.template
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
RUN chown root.root /etc/deploy-start.sh
RUN chmod 700 /etc/deploy-start.sh
RUN chown root.root /etc/deploy-stop.sh
RUN chmod 700 /etc/deploy-stop.sh

#install R
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install R

ENTRYPOINT ["/etc/bootstrap.sh"]
