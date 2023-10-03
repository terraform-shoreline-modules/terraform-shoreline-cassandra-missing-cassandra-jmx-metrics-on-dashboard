resource "shoreline_notebook" "missing_cassandra_jmx_metrics_on_dashboard" {
  name       = "missing_cassandra_jmx_metrics_on_dashboard"
  data       = file("${path.module}/data/missing_cassandra_jmx_metrics_on_dashboard.json")
  depends_on = [shoreline_action.invoke_jmx_script,shoreline_action.invoke_cassandra_jmx_verification]
}

resource "shoreline_file" "jmx_script" {
  name             = "jmx_script"
  input_file       = "${path.module}/data/jmx_script.sh"
  md5              = filemd5("${path.module}/data/jmx_script.sh")
  description      = "Step 3: Check if JMX is reachable from the local machine"
  destination_path = "/agent/scripts/jmx_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cassandra_jmx_verification" {
  name             = "cassandra_jmx_verification"
  input_file       = "${path.module}/data/cassandra_jmx_verification.sh"
  md5              = filemd5("${path.module}/data/cassandra_jmx_verification.sh")
  description      = "Verify that the JMX interface is enabled on the Cassandra nodes and that the appropriate JMX ports are open and accessible."
  destination_path = "/agent/scripts/cassandra_jmx_verification.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_jmx_script" {
  name        = "invoke_jmx_script"
  description = "Step 3: Check if JMX is reachable from the local machine"
  command     = "`chmod +x /agent/scripts/jmx_script.sh && /agent/scripts/jmx_script.sh`"
  params      = ["JMX_USERNAME","JMX_PASSWORD","JMX_PORT"]
  file_deps   = ["jmx_script"]
  enabled     = true
  depends_on  = [shoreline_file.jmx_script]
}

resource "shoreline_action" "invoke_cassandra_jmx_verification" {
  name        = "invoke_cassandra_jmx_verification"
  description = "Verify that the JMX interface is enabled on the Cassandra nodes and that the appropriate JMX ports are open and accessible."
  command     = "`chmod +x /agent/scripts/cassandra_jmx_verification.sh && /agent/scripts/cassandra_jmx_verification.sh`"
  params      = ["IP_ADDRESS_OF_CASSANDRA_NODE","JMX_PORT_NUMBER","IP_ADDRESS","JMX_PORT"]
  file_deps   = ["cassandra_jmx_verification"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_jmx_verification]
}

