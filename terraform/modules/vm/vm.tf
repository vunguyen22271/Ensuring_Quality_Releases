resource "azurerm_network_interface" "example_nic" {
  name                = "${var.application_type}-${var.resource_type}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = var.location
  resource_group_name = var.resource_group
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.example_nic.id]
  source_image_id       = var.packer_image
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/3Bvb01xnbIIYRxPeRtpdzSpiK7Y5R0rwdjMoUVL3oxLoIgJXbjaFH/5bEK2dBKU65pfPB9kxLmGcGwHh+d3219tUgJS/tPR+rKuir+w880vTRP48wWLOexDyY4rMcBPcVVpHfgY7qyaEiPFtAoRfpLjBapikKPqRbqTmvZ87rgr8EQ9VNfVB9ong9sw09HS9Lw80v86gD1VWXvKnnxPcF7MmMdbAhUQPVlnK/XuqnsQmvAV2JG8+DdMHoNnyQKqkGzRv67Qkil70tNQpForn3BBeDm/4OLJBA/VxrEnVz3033Va3Pwypj198g00+x3u6uzaG4qtS9UuBSv64M59xdd2lCV4dGmPuhX8fLCxGv6yi6rPT45RYYx40G5F30953PdVo4WHUpRsbBE4afm6kGDRBMkR/CpCfS9/5gyRMOI8accxNCcEwUIA05CntTcvOjBeSW35Ql8lc5yrLcVkhuhwaaz66Zc1iv1S8kmG7mXc5D1+ct52NbNTKi0bvdcs= mac@Macs-MacBook-Pro.local"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "18.04-LTS"
  #   version   = "latest"
  # }
}
