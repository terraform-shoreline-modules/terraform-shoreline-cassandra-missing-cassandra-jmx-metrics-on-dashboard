sudo apt-get install -y jmxterm

java -jar /usr/share/jmxterm/jmxterm.jar -l localhost:${JMX_PORT} -u ${JMX_USERNAME} -p ${JMX_PASSWORD} -n -v silent -c "domains"