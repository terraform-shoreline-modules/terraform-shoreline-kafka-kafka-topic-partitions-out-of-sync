

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