
Check DSCPMark value:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R "/usr/bin/ba-cli Device.DHCPv6.Server.Pool.1.DSCPMark?" | grep -v '^>'
  Device.DHCPv6.Server.Pool.1.DSCPMark=48
  

