scp /etc/hosts root@spark-master:/etc/
scp /etc/hosts root@spark-slave1:/etc/
ssh root@spark-master "$HADOOP_PREFIX/sbin/start-dfs.sh >/dev/null"
ssh root@spark-master "$HADOOP_PREFIX/sbin/start-yarn.sh >/dev/null"
ssh root@spark-master "/usr/local/spark/sbin/start-master.sh >/dev/null"
ssh root@spark-master "/usr/local/spark/sbin/start-slave.sh spark://spark-master:7077 >/dev/null"
ssh root@spark-slave1 "/usr/local/spark/sbin/start-slave.sh spark://spark-master:7077 >/dev/null"
/usr/local/spark/sbin/start-slave.sh spark://spark-master:7077 >/dev/null
