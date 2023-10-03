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

module "missing_cassandra_jmx_metrics_on_dashboard" {
  source    = "./modules/missing_cassandra_jmx_metrics_on_dashboard"

  providers = {
    shoreline = shoreline
  }
}