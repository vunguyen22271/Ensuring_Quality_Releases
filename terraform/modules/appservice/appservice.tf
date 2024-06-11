resource "azurerm_service_plan" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  service_plan_id     = azurerm_service_plan.test.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 1
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = true
  }
  logs {
    detailed_error_messages = false
    failed_request_tracing  = false

    application_logs {
      file_system_level = "Error"
    }

    http_logs {
      file_system {
        retention_in_days = 3
        retention_in_mb   = 100
      }
    }
  }
  site_config {
    always_on = false
    application_stack{
      current_stack = "dotnet"
      dotnet_version = "v4.0"
    }
    virtual_application {
      physical_path = "site\\wwwroot" 
      preload       = false 
      virtual_path  = "/" 
    }
  }
}