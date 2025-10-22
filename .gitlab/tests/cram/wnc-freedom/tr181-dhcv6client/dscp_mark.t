Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check DSCPMark value:

  $ R "/usr/bin/ba-cli Device.DHCPv6.Client.1.DSCPMark?" | grep -v '^>'
  Device.DHCPv6.Client.1.DSCPMark=48
  

