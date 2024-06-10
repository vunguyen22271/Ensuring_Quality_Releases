az vm image list --all --publisher Canonical --offer UbuntuServer --sku 18.04-LTS --query '[0].id' -o tsv

az image show --subscription $subscription_id --resource-group $resource_group --name $image_name --query id --output tsv