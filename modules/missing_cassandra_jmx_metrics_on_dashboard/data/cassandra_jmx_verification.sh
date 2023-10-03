

#!/bin/bash



# Define variables

${IP_ADDRESS}="${IP_ADDRESS_OF_CASSANDRA_NODE}"

${JMX_PORT}="${JMX_PORT_NUMBER}"



# Verify that the JMX interface is enabled on the Cassandra node

jmx_enabled=$(sudo grep "com.sun.management.jmxremote" /etc/cassandra/cassandra-env.sh | wc -l)



if [ $jmx_enabled -eq 0 ]; then

  echo "JMX interface is not enabled on the Cassandra node."

  exit 1

else

  echo "JMX interface is enabled on the Cassandra node."

fi



# Verify that the JMX port is open and accessible

jmx_open=$(sudo nc -zv $IP_ADDRESS $JMX_PORT 2>&1 | grep succeeded | wc -l)



if [ $jmx_open -eq 0 ]; then

  echo "JMX port is not open or accessible on the Cassandra node."

  exit 1

else

  echo "JMX port is open and accessible on the Cassandra node."

fi



exit 0