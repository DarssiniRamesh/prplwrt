
Check default value:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.STP.BridgePriority? | grep -v '^>'
  Bridging.Bridge.1.STP.BridgePriority=32768
  

Try to set a negative value:
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.STP.BridgePriority=-1 | grep -v '^>'
  ERROR: set Bridging.Bridge.lan.STP.BridgePriority failed (10 - invalid value)
  

Try to set a value bigger than allowed:
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.STP.BridgePriority=61441 | grep -v '^>'
  ERROR: set Bridging.Bridge.lan.STP.BridgePriority failed (10 - invalid value)
  

Try to set the maximal allowed value:
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.STP.BridgePriority=61440 | grep -v '^>'
  Bridging.Bridge.1.STP.
  Bridging.Bridge.1.STP.BridgePriority=61440
  

Restore:
  $ R /usr/bin/ba-cli Bridging.Bridge.lan.STP.BridgePriority=32768 | grep -v '^>'
  Bridging.Bridge.1.STP.
  Bridging.Bridge.1.STP.BridgePriority=32768
  