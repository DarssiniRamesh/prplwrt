Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Reset Stats:
  $ R "ba-cli 'Device.DHCPv4.Client.1.Stats.Reset()' | grep -Ev '^>|^$'"
  Device.DHCPv4.Client.1.Stats.Reset() returned
  [
      ""
  ]

Dump Stats object:

  $ R "ba-cli 'dump -p Device.DHCPv4.Client.1.Stats.' | grep -Ev '^>|^$'"
  .R...... <public>      singleton Device.DHCPv4.Client.1.Stats.
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Inform=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.DiscardedPackets=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Decline=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.OtherMessageTypes=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Offer=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Request=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Release=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.TransmitFailure=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.ForceRenew=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.NACK=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.ACK=0
  .R....V. <public>         uint32 Device.DHCPv4.Client.1.Stats.Discover=0
