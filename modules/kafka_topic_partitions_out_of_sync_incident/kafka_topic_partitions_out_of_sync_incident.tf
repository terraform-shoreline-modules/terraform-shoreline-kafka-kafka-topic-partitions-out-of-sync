resource "shoreline_notebook" "kafka_topic_partitions_out_of_sync_incident" {
  name       = "kafka_topic_partitions_out_of_sync_incident"
  data       = file("${path.module}/data/kafka_topic_partitions_out_of_sync_incident.json")
  depends_on = [shoreline_action.invoke_kafka_topic_replication]
}

resource "shoreline_file" "kafka_topic_replication" {
  name             = "kafka_topic_replication"
  input_file       = "${path.module}/data/kafka_topic_replication.sh"
  md5              = filemd5("${path.module}/data/kafka_topic_replication.sh")
  description      = "Check the topic configuration to ensure that replication and partition counts are correct."
  destination_path = "/tmp/kafka_topic_replication.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_topic_replication" {
  name        = "invoke_kafka_topic_replication"
  description = "Check the topic configuration to ensure that replication and partition counts are correct."
  command     = "`chmod +x /tmp/kafka_topic_replication.sh && /tmp/kafka_topic_replication.sh`"
  params      = ["PATH_TO_KAFKA_HOME","TOPIC_NAME","PARTITION_COUNT","NAME_OF_TOPIC","REPLICATION_FACTOR"]
  file_deps   = ["kafka_topic_replication"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_topic_replication]
}

