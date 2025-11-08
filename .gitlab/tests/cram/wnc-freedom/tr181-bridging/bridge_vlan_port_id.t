
Add a VLAN with unique ID:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.VLAN.+{VLANID=100, Enable=1}? | grep -v '^>'
  Bridging.Bridge.1.VLAN.1.
  Bridging.Bridge.1.VLAN.1.Alias="cpe-VLAN-1"
  

Add a VLAN with duplicate ID:
  $ R "/usr/bin/ba-cli 'Bridging.Bridge.lan.VLAN.+{VLANID=100, Enable=1}?'" | grep -v '^>'
  ERROR: add Bridging.Bridge.lan.VLAN. failed (10 - invalid value)
  

Cleanup:
  $ R "/usr/bin/ba-cli Bridging.Bridge.lan.VLAN.[VLANID==100].-" | grep -v '^>'
  Bridging.Bridge.1.VLAN.1.
  