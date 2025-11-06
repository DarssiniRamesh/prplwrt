Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ . ${CRAM_FUNCTIONS}

Set AutoChannelEnable=0 on all WiFi.Radio. interfaces:

  $ R "ba-cli -j -l WiFi.Radio.*.AutoChannelEnable=0 | sed '/^$/d'"
  [{"WiFi.Radio.1.":{"AutoChannelEnable":0},"WiFi.Radio.2.":{"AutoChannelEnable":0},"WiFi.Radio.3.":{"AutoChannelEnable":0}}]

Set channel to a non DFS one:

  $ R "ba-cli -j -l WiFi.Radio.2.Channel=36 | sed '/^$/d'"
  [{"WiFi.Radio.2.":{"Channel":36}}]

  $ sleep 5

Configure controller, requires PPM-3022 to work:

  $ R logger -t cram "Stop prplmesh"

  $ R "( /etc/init.d/prplmesh stop ; sleep 2 )  2>&1 > /dev/null"


  $ R "sed -i 's/use_dataelements_vap_configs=0/use_dataelements_vap_configs=1/g' /opt/prplmesh/config/beerocks_controller.conf"

Restart prplmesh:

  $ R logger -t cram "Restart prplmesh"

  $ R "( /etc/init.d/prplmesh gateway_mode ; sleep 2 ) > /tmp/prplmesh-gw-mode.log 2>&1 ; logger -t prplmesh-gateway-mode < /tmp/prplmesh-gw-mode.log"

  $ R "ubus -t 60 wait_for X_PRPLWARE-COM_WiFiController.Network.Device.1"

First call of AccessPointCommit, controller should push empty config to agents:

  $ R logger -t cram "first call of AccessPointCommit pushes empty config, global teardown"

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network AccessPointCommit"
  {"retval":""}
  {}
  {"amxd-error-code":0}

  $ R sleep 15

Check all AccessPoint.{i} instances are disabled (independent on number of VAPs)

  $ R "ba-cli -l -j WiFi.AccessPoint.[Enable==1].Enable?  | jsonfilter -e @[0]'[@].Enable' | wc -l"
  0

Silently disable MLO

  $ R "ba-cli \'WiFi.SSID.*.MLDUnit=-1\' > /dev/null"

Create one instances of Network.AccessPoint and push it to the agent:

  $ R logger -t cram "create instances of Network.AccessPoint and push them to the agent"

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint _add"
  {"object":"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.","index":1,"name":"1","parameters":{},"path":"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1."}
  {}
  {"amxd-error-code":0}

Since no persistent storage of NbAPI Network subsection, always index:1 after controller restart:

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"Band5GH\":1,\"Band5GL\":1}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"Band5GH":true,"Band6G":true,"Band2_4G":true,"Band5GL":true}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"MultiApMode\":\"Fronthaul+Backhaul\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"MultiApMode":"Fronthaul+Backhaul"}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security _set '{\"parameters\":{\"ModeEnabled\":\"WPA3-Personal\",\"KeyPassphrase\":\"password\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security.":{"KeyPassphrase":"password","ModeEnabled":"WPA3-Personal"}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"SSID\":\"SSIDforStaticPunct\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"SSID":"SSIDforStaticPunct"}}
  {}
  {"amxd-error-code":0}

In case the controller does not yet have this parameter, catch error here isof later during teardown test:
  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"Enable\":1}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"Enable":true}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network AccessPointCommit"
  {"retval":""}
  {}
  {"amxd-error-code":0}


  $ sleep 15

Check that only 1 SSID instance is operating:

  $ get_ssid_status_filtered Up
  Up


Check the new SSID SSIDforStaticPunct is applied 1 time

  $ get_ssid_ssid_filtered SSIDforStaticPunct
  SSIDforStaticPunct


No NBAPI function to set channel; taking advantage of gateway mode and write directly to PWHM. grep to remove empty line
  $ R "ba-cli -l \'WiFi.Radio.[OperatingFrequencyBand==\"5GHz\"].OperatingChannelBandwidth=\"80MHz\"\' | grep 80"
  80MHz

  $ sleep 5

Check that 5GHz Radio reports opClass 115 channels : 36,40,44,48
  $ R "ba-cli -j -l \'WiFi.Radio.[OperatingFrequencyBand==\"5GHz\"].ChannelsInUse?\' | jsonfilter -e @[0]'[*].ChannelsInUse'"
  36,40,44,48

Push 0b0001 0d01 - disable channel 36
  $ R "ba-cli \'X_PRPLWARE-COM_WiFiController.Network.Device.*.Radio.*.BSS.*.SetEHTOperations(DisabledSubchannelBitmap=1)\' > /dev/null"

  $ sleep 2

Check channel 36
  $ R "ba-cli -j -l \'WiFi.Radio.[OperatingFrequencyBand==\"5GHz\"].StaticPuncturing.DisabledSubChannels?\'  | jsonfilter -e @[0]'[*].DisabledSubChannels' "
  36

Push 0b0010 0d02 - disable channel 40
  $ R "ba-cli \'X_PRPLWARE-COM_WiFiController.Network.Device.*.Radio.*.BSS.*.SetEHTOperations(DisabledSubchannelBitmap=2)\' > /dev/null"

  $ sleep 2

Check channel 40
  $ R "ba-cli -j -l \'WiFi.Radio.[OperatingFrequencyBand==\"5GHz\"].StaticPuncturing.DisabledSubChannels?\'  | jsonfilter -e @[0]'[*].DisabledSubChannels' "
  40

Push 0b0101 0d05 - disable channels 36 and 44
  $ R "ba-cli \'X_PRPLWARE-COM_WiFiController.Network.Device.*.Radio.*.BSS.*.SetEHTOperations(DisabledSubchannelBitmap=2)\' > /dev/null"

  $ sleep 2

Check channels 36 and 44
  $ R "ba-cli -j -l \'WiFi.Radio.[OperatingFrequencyBand==\"5GHz\"].StaticPuncturing.DisabledSubChannels?\'  | jsonfilter -e @[0]'[*].DisabledSubChannels' "
  36,44

Push 0b0000 0d00 - clear Radio.StaticPuncturing.DisabledSubChannels list
  $ R "ba-cli \'X_PRPLWARE-COM_WiFiController.Network.Device.*.Radio.*.BSS.*.SetEHTOperations(DisabledSubchannelBitmap=0)\' > /dev/null"


Restore MLDUnit to default values

  $ R logger -t cram "Restore default MLD configuration"

  $ R "ba-cli -j -l WiFi.AccessPoint.1.SSIDReference+.MLDUnit=0 |jsonfilter -e @[0]'[*].MLDUnit' "
  0

  $ R "ba-cli -j -l WiFi.AccessPoint.2.SSIDReference+.MLDUnit=1 |jsonfilter -e @[0]'[*].MLDUnit' "
  1

  $ R "ba-cli -j -l WiFi.AccessPoint.3.SSIDReference+.MLDUnit=0 |jsonfilter -e @[0]'[*].MLDUnit' "
  0

  $ R "ba-cli -j -l WiFi.AccessPoint.4.SSIDReference+.MLDUnit=1 |jsonfilter -e @[0]'[*].MLDUnit' "
  1

  $ R "ba-cli -j -l WiFi.AccessPoint.5.SSIDReference+.MLDUnit=0 |jsonfilter -e @[0]'[*].MLDUnit' "
  0

  $ R "ba-cli -j -l WiFi.AccessPoint.6.SSIDReference+.MLDUnit=1 |jsonfilter -e @[0]'[*].MLDUnit' "
  1

  $ sleep 2

Restore default SSID Values
  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"SSID\":\"prplOS\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"SSID":"prplOS"}}
  {}
  {"amxd-error-code":0}

Next two operations will push WPA2-WPA3-Personal to ALL VAPs that were modified in this test (first instance of WiFi.AccessPoint on 5GHz Radio)
  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security _set '{\"parameters\":{\"ModeEnabled\":\"WPA3-Personal-Transition\",\"KeyPassphrase\":\"password\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security.":{"KeyPassphrase":"password","ModeEnabled":"WPA3-Personal-Transition"}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network AccessPointCommit"
  {"retval":""}
  {}
  {"amxd-error-code":0}

