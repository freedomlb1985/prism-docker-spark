#scp /etc/hosts root@spark-master:/etc/
#scp /etc/hosts root@spark-slave1:/etc/
ssh root@spark-master "$HADOOP_PREFIX/sbin/stop-yarn.sh && $HADOOP_PREFIX/sbin/stop-dfs.sh > /dev/null"
ssh root@spark-master "/usr/local/spark/sbin/stop-master.sh >/dev/null"
ssh root@spark-master "/usr/local/spark/sbin/stop-slave.sh  >/dev/null"
ssh root@spark-slave1 "/usr/local/spark/sbin/stop-slave.sh  >/dev/null"
/usr/local/spark/sbin/stop-slave.sh >/dev/null
