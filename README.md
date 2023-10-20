
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Topic Partitions Out of Sync Incident
---

In this type of incident, the partitions of a Kafka topic become out of sync, which means that some of the messages are not being delivered to the intended consumers. This can happen due to various reasons, such as a network issue, a hardware failure, or a bug in the Kafka software. The consequences of this incident can be serious, as it can cause data loss, message duplication, or other errors in the downstream systems that depend on the Kafka topic. Therefore, it is important to identify and resolve the root cause of the partition sync issue as soon as possible to ensure the reliability and consistency of the data pipeline.

### Parameters
```shell
export ZOOKEEPER_PORT="PLACEHOLDER"

export ZOOKEEPER_HOST="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export REPLICATION_FACTOR="PLACEHOLDER"

export PARTITION_COUNT="PLACEHOLDER"

export PATH_TO_KAFKA_HOME="PLACEHOLDER"

export NAME_OF_TOPIC="PLACEHOLDER"
```

## Debug

### List all topics in Kafka
```shell
kafka-topics --list --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT}
```

### Describe a specific topic to check if it has multiple partitions
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} --topic ${TOPIC_NAME}
```

### Check if any of the Kafka brokers are down
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} --topic ${TOPIC_NAME} | grep -i "isr:"
```

### Check if there are any under-replicated partitions
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT} | grep -i "under-replicated"
```

## Repair

### Check the topic configuration to ensure that replication and partition counts are correct.
```shell


#!/bin/bash

# Set the variables

KAFKA_HOME=${PATH_TO_KAFKA_HOME}

TOPIC_NAME=${NAME_OF_TOPIC}

REPLICATION_FACTOR=${REPLICATION_FACTOR}

PARTITION_COUNT=${PARTITION_COUNT}



# Check the topic configuration

$KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic $TOPIC_NAME | grep -q "Replication Factor: $REPLICATION_FACTOR" 

if [ $? -ne 0 ]; then

    # Update the replication factor

    $KAFKA_HOME/bin/kafka-topics.sh --alter --zookeeper localhost:2181 --topic $TOPIC_NAME --partitions $PARTITION_COUNT --replication-factor $REPLICATION_FACTOR

    echo "Replication factor updated for topic $TOPIC_NAME"

else

    echo "Replication factor is already correct for topic $TOPIC_NAME"

fi


```