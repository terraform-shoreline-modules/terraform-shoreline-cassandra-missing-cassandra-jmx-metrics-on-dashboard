
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Missing Cassandra JMX Metrics on Dashboard
---

This incident type refers to the issue of missing JMX metrics for Cassandra on a dashboard. JMX metrics are important for monitoring the performance of Cassandra, and their absence on a dashboard can lead to difficulties in identifying and resolving issues that may arise. This incident requires investigation to determine the cause of the issue and to restore the missing metrics to the dashboard.

### Parameters
```shell
export JMX_PORT="PLACEHOLDER"

export JMX_USERNAME="PLACEHOLDER"

export JMX_PASSWORD="PLACEHOLDER"

export CASSANDRA_HOST="PLACEHOLDER"

export DASHBOARD_CONFIG_FILE="PLACEHOLDER"

export CASSANDRA_PORT="PLACEHOLDER"

export IP_ADDRESS="PLACEHOLDER"

export IP_ADDRESS_OF_CASSANDRA_NODE="PLACEHOLDER"

export JMX_PORT_NUMBER="PLACEHOLDER"
```

## Debug

### Step 1: Check if Cassandra is running
```shell
sudo service cassandra status
```

### Step 2: Check if JMX is enabled in Cassandra's configuration file
```shell
sudo cat /etc/cassandra/cassandra.yaml | grep -A 1 "jmx:"
```

### Step 3: Check if JMX is reachable from the local machine
```shell
sudo apt-get install -y jmxterm

java -jar /usr/share/jmxterm/jmxterm.jar -l localhost:${JMX_PORT} -u ${JMX_USERNAME} -p ${JMX_PASSWORD} -n -v silent -c "domains"
```

### Step 4: Check if JMX is reachable from the remote machine where the dashboard is hosted
```shell
java -jar /usr/share/jmxterm/jmxterm.jar -l ${CASSANDRA_HOST}:${JMX_PORT} -u ${JMX_USERNAME} -p ${JMX_PASSWORD} -n -v silent -c "domains"
```

### Step 5: Check if the metrics are being collected in Cassandra
```shell
nodetool sjk mxdump ${CASSANDRA_HOST}:${JMX_PORT} | grep -i "CassandraMetrics"
```

### Step 6: Check if the dashboard is properly configured to display the JMX metrics
```shell
sudo cat ${DASHBOARD_CONFIG_FILE} | grep -i "CassandraMetrics"
```

## Repair

### Verify that the JMX interface is enabled on the Cassandra nodes and that the appropriate JMX ports are open and accessible.
```shell


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


```