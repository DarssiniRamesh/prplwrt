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

  $ R "ubus -t 60 wait_for Device.WiFi"

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

  $ R "ba-cli WiFi.SSID.*.MLDUnit=-1 > /dev/null"

Check all 6 VAPs contain WPA3-Personal-Compatibility in the Security.ModesAvailable list
  $ R "ba-cli WiFi.AccessPoint.*.Security.ModesAvailable? | grep WPA3-Personal-Compatibility | wc -l"
  6

Create one instances of Network.AccessPoint and push it to the agent:

  $ R logger -t cram "create instances of Network.AccessPoint and push them to the agent"

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint _add"
  {"object":"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.","index":1,"name":"1","parameters":{},"path":"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1."}
  {}
  {"amxd-error-code":0}

Since no persistent storage of NbAPI Network subsection, always index:1 after controller restart:

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"Band2_4G\":1,\"Band5GH\":1,\"Band5GL\":1,\"Band6G\":1}}'"
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

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"SSID\":\"SSIDforCRAM113\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"SSID":"SSIDforCRAM113"}}
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

Check that 3 SSID instances are operating:

  $ get_ssid_status_filtered Up
  Up
  Up
  Up

Check the new SSID SSIDforCRAM113 is applied 3 times

  $ get_ssid_ssid_filtered SSIDforCRAM113
  SSIDforCRAM113
  SSIDforCRAM113
  SSIDforCRAM113

Check wpa_key_mgmt is configured for WPA3 in 5GHz hostapd.conf and rsn override params are absent

  $ R "cat /tmp/wlan1_hapd.conf | grep \"wpa_key_mgmt=SAE\" | wc -l"
  1

  $ R "cat /tmp/wlan1_hapd.conf | grep \"rsn_override_key_mgmt=SAE\" | wc -l"
  0

Push WPA3-Personal-Compatibility and search for one rsn override parameter in hostapd.conf

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security _set '{\"parameters\":{\"ModeEnabled\":\"WPA3-Personal-Compatibility\",\"SAEPassphrase\":\"password\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security.":{"SAEPassphrase":"password","ModeEnabled":"WPA3-Personal-Compatibility"}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network AccessPointCommit"
  {"retval":""}
  {}
  {"amxd-error-code":0}

  $ sleep 5

  $ R "ba-cli -j -l WiFi.AccessPoint.[Enable==1].Security.ModeEnabled? | jsonfilter -e @[0]'[@].ModeEnabled'"
  WPA3-Personal-Compatibility
  WPA3-Personal-Compatibility
  WPA3-Personal-Compatibility

  $ R "cat /tmp/wlan1_hapd.conf | grep \"rsn_override_key_mgmt=SAE\" | wc -l"
  1

Check RSN Override 2 parameters are absent in hostapd.conf (we disabled MLO and implicitly 11BE)

  $ R "cat /tmp/wlan1_hapd.conf | grep \"rsn_override_key_mgmt_2\" | wc -l"
  0

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

Check RSNO2 parameter was added

  $ R "cat /tmp/wlan1_hapd.conf | grep \"rsn_override_key_mgmt_2\" | wc -l"
  1

Restore default SSID Values
  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1 _set '{\"parameters\":{\"SSID\":\"prplOS\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.":{"SSID":"prplOS"}}
  {}
  {"amxd-error-code":0}

Next two operations will push WPA2-WPA3-Personal to ALL VAPs that were used in this test. On 6GHz, this mode is not supported. PWHM shall fallback to the default WPA3-Personal
  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security _set '{\"parameters\":{\"ModeEnabled\":\"WPA3-Personal-Transition\",\"KeyPassphrase\":\"password\"}}'"
  {"X_PRPLWARE-COM_WiFiController.Network.AccessPoint.1.Security.":{"KeyPassphrase":"password","ModeEnabled":"WPA3-Personal-Transition"}}
  {}
  {"amxd-error-code":0}

  $ R "ubus -S call X_PRPLWARE-COM_WiFiController.Network AccessPointCommit"
  {"retval":""}
  {}
  {"amxd-error-code":0}

