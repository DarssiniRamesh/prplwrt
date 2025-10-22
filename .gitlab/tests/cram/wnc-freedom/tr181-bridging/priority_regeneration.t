
Check priority regeneration on eth0:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R /usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration?' | grep -Ev '^>'
  Device.Bridging.Bridge.1.Port.1.PriorityRegeneration="0,1,2,3,4,5,6,7"
  

Set the value bigger than allowed:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6,8\"'" | grep -Ev '^>'
  ERROR: set Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration failed (10 - invalid value)
  

Set the value lower than allowed:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6,-1\"'" | grep -v '^>'
  ERROR: set Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration failed (10 - invalid value)
  

Set the value with an extra item:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6,7,7\"'" | grep -v '^>'
  ERROR: set Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration failed (10 - invalid value)
  

Set the value with a missing item:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6\"'" | grep -v '^>'
  ERROR: set Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration failed (10 - invalid value)
  

Set a correct value:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6,6\"'" | grep -v '^>'
  Device.Bridging.Bridge.1.Port.1.
  Device.Bridging.Bridge.1.Port.1.PriorityRegeneration="0,1,2,3,4,5,6,6"
  

Restore:
  $ R "/usr/bin/ba-cli 'Device.Bridging.Bridge.lan.Port.1.PriorityRegeneration=\"0,1,2,3,4,5,6,7\"'" | grep -v '^>'
  Device.Bridging.Bridge.1.Port.1.
  Device.Bridging.Bridge.1.Port.1.PriorityRegeneration="0,1,2,3,4,5,6,7"
  
