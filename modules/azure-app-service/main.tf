//TO-DO
//RESEARCH ABOUT TERRAFORM APP SERVICE CONFIGS AND MODIFY IN NEED 

resource "azurerm_linux_web_app" "app_service" {
  name                = var.app_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id = var.service_plan_id
  https_only = true

  public_network_access_enabled = true
  webdeploy_publish_basic_authentication_enabled = true

  site_config {
    
    //linux_fx_version = "DOTNETCORE|8.0" - deprecated
    always_on        = false
    http2_enabled    = true
    container_registry_use_managed_identity = false
    ftps_state                     = "FtpsOnly"
    load_balancing_mode            = "LeastRequests"
    local_mysql_enabled            = false
    managed_pipeline_mode          = "Integrated"
    minimum_tls_version            = "1.2"
    remote_debugging_enabled       = false
    scm_minimum_tls_version        = "1.2"
    scm_use_main_ip_restriction    = false
    use_32_bit_worker              = true
    vnet_route_all_enabled         = false
    websockets_enabled             = false
    worker_count                   = 1
    application_stack {
      dotnet_version = "8.0"
    }
  }

  logs {
    detailed_error_messages = false
    failed_request_tracing  = false
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

}