output "dns_zone_ids" {
  value = {
    dfs   = azurerm_private_dns_zone.dfs.id
    blob  = azurerm_private_dns_zone.blob.id
    kv    = azurerm_private_dns_zone.kv.id
    syn_d = azurerm_private_dns_zone.syn_d.id
    syn_s = azurerm_private_dns_zone.syn_s.id
  }
}
