Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Verify CPUs — Data Model of OSPv2 Board:

  $ R "ba-cli -lj CPUs.?" | jq .
  [
    {
      "CPUs.CPU.2.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "powersave",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "performance,powersave",
        "ScalingMaxFrequency": 1716000,
        "Enable": 1,
        "MaxFrequency": 1716000,
        "ScalingAvailableFrequencies": "624000,780000,936000,1092000,1248000,1404000,1560000,1716000",
        "ScalingMinFrequency": 624000,
        "MinFrequency": 624000
      },
      "CPUs.CPU.1.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "powersave",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "performance,powersave",
        "ScalingMaxFrequency": 1716000,
        "Enable": 1,
        "MaxFrequency": 1716000,
        "ScalingAvailableFrequencies": "624000,780000,936000,1092000,1248000,1404000,1560000,1716000",
        "ScalingMinFrequency": 624000,
        "MinFrequency": 624000
      },
      "CPUs.CPU.1.": {
        "Alias": "cpe-cpu0"
      },
      "CPUs.": {
        "CPUNumberOfEntries": 2
      },
      "CPUs.CPU.2.": {
        "Alias": "cpe-cpu1"
      }
    }
  ]
