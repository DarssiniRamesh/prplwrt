
Check Aiging time type:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R "/usr/bin/ba-cli 'dump -p Bridging.Bridge.1.'" | grep 'AgingTime'
  P....... <public>         uint32 Bridging.Bridge.1.AgingTime=300
