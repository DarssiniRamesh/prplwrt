Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check lan bridge ports:

  $ R ip link show | grep 'master br-lan' | cut -d: -f2 | sort
   lan1
   lan2
   lan3
   lan4
   wlan0
   wlan0.1
   wlan1
   wlan1.1
   wlan2
   wlan2.1


Check lan bridge ports in HLAPI:

  $ R ba-cli 'Device.Bridging.Bridge.lan.Port.?' | grep 'LowerLayers'
  Device.Bridging.Bridge.1.Port.1.LowerLayers="Device.Bridging.Bridge.1.Port.2,Device.Bridging.Bridge.1.Port.3,Device.Bridging.Bridge.1.Port.4,Device.Bridging.Bridge.1.Port.5,Device.Bridging.Bridge.1.Port.6,Device.Bridging.Bridge.1.Port.7,Device.Bridging.Bridge.1.Port.8,Device.Bridging.Bridge.1.Port.9,Device.Bridging.Bridge.1.Port.10,Device.Bridging.Bridge.1.Port.11"
  Device.Bridging.Bridge.1.Port.10.LowerLayers="Device.WiFi.SSID.7"
  Device.Bridging.Bridge.1.Port.11.LowerLayers="Device.WiFi.SSID.8"
  Device.Bridging.Bridge.1.Port.2.LowerLayers="Device.Ethernet.Interface.2"
  Device.Bridging.Bridge.1.Port.3.LowerLayers="Device.Ethernet.Interface.3"
  Device.Bridging.Bridge.1.Port.4.LowerLayers="Device.Ethernet.Interface.4"
  Device.Bridging.Bridge.1.Port.5.LowerLayers="Device.Ethernet.Interface.5"
  Device.Bridging.Bridge.1.Port.6.LowerLayers="Device.WiFi.SSID.1"
  Device.Bridging.Bridge.1.Port.7.LowerLayers="Device.WiFi.SSID.2"
  Device.Bridging.Bridge.1.Port.8.LowerLayers="Device.WiFi.SSID.4"
  Device.Bridging.Bridge.1.Port.9.LowerLayers="Device.WiFi.SSID.5"

Replace a port with WAN interface:

  $ R ba-cli 'Device.Bridging.Bridge.lan.Port.5.LowerLayers=Device.Ethernet.Interface.1' >/dev/null
  $ R ba-cli 'Device.Bridging.Bridge.lan.Port.5.Name?' | grep -v '^>'
  Device.Bridging.Bridge.1.Port.5.Name="wan"
  

Check lan bridge ports:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ R ip link show | grep 'master br-lan' | cut -d: -f2 | sort
   lan1
   lan2
   lan3
   wan
   wlan0
   wlan0.1
   wlan1
   wlan1.1
   wlan2
   wlan2.1


Restore:

  $ R ba-cli 'Device.Bridging.Bridge.lan.Port.5.LowerLayers=Device.Ethernet.Interface.5' | grep -v '^>'
  Device.Bridging.Bridge.1.Port.5.
  Device.Bridging.Bridge.1.Port.5.LowerLayers="Device.Ethernet.Interface.5"
  
