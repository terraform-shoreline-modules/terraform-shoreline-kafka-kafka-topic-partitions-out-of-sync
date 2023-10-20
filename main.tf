terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_topic_partitions_out_of_sync_incident" {
  source    = "./modules/kafka_topic_partitions_out_of_sync_incident"

  providers = {
    shoreline = shoreline
  }
}