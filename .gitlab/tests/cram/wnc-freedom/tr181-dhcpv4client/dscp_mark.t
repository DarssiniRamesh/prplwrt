
Set DSCPMark to negative value:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R /usr/bin/ba-cli 'Device.DHCPv4.Client.1.DSCPMark=-1' | grep -Ev '^>|^$'
  ERROR: set Device.DHCPv4.Client.1.DSCPMark failed (10 - invalid value)

Set DSCPMark to value bigger than 63:
  $ R /usr/bin/ba-cli 'Device.DHCPv4.Client.1.DSCPMark=64' | grep -Ev '^>|^$'
  ERROR: set Device.DHCPv4.Client.1.DSCPMark failed (10 - invalid value)

Set DSCPMark to acceptable value:
  $ R /usr/bin/ba-cli 'Device.DHCPv4.Client.1.DSCPMark=63' | grep -Ev '^>|^$'
  Device.DHCPv4.Client.1.
  Device.DHCPv4.Client.1.DSCPMark=63

Restore default value:
  $ R /usr/bin/ba-cli 'Device.DHCPv4.Client.1.DSCPMark=48' | grep -Ev '^>|^$'
  Device.DHCPv4.Client.1.
  Device.DHCPv4.Client.1.DSCPMark=48
