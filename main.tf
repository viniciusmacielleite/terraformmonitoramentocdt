provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-crm"
  location = "brazilsouth"
}

resource "azurerm_service_plan" "sp" {
  name                = var.global_name_app
  resource_group_name = "rg-crm"
  location            = var.location
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "lwa" {
  name                = var.global_name_app
  resource_group_name = "rg-crm"
  location            = "brazilsouth"
  service_plan_id     = azurerm_service_plan.sp.id
  app_settings = {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = true
      DOCKER_ENABLE_CI = true
      DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io/v1"
  } 
  site_config {
      always_on         = true
      websockets_enabled  = true
      application_stack {
          docker_image  = "viniciusmacielleite/dockermonitoramentocrm"
          docker_image_tag  = "latest"
      }
  }

  depends_on = [ azurerm_service_plan.sp ]
}
