
Add an entry with a unique name:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R /usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.+{Name="eth100"}' | grep -v '^>'
  Device.Bridging.Bridge.1.Port.12.
  Device.Bridging.Bridge.1.Port.12.Alias="cpe-Port-12"
  

Add an entry with a duplicate name:
  $ R /usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.+{Name="eth100"}' | grep -v '^>'
  ERROR: add Device.Bridging.Bridge.lan.Port. failed (10 - invalid value)
  

Restore:
  $ R /usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.12-' | grep -v '^>'
  Device.Bridging.Bridge.1.Port.12.
  Device.Bridging.Bridge.1.Port.12.Stats.
  
