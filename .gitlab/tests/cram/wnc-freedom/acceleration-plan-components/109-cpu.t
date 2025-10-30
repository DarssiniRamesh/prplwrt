Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Verify CPUs — Data Model of Freedom Board:

  $ R "ba-cli -lj CPUs.?" | jq .
  [
    {
      "CPUs.CPU.3.": {
        "Alias": "cpe-cpu2"
      },
      "CPUs.CPU.1.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "performance",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "conservative,ondemand,userspace,powersave,performance",
        "ScalingMaxFrequency": 2208000,
        "Enable": 1,
        "MaxFrequency": 2208000,
        "ScalingAvailableFrequencies": "936000,1104000,1416000,1488000,1800000,2208000",
        "ScalingMinFrequency": 936000,
        "MinFrequency": 936000
      },
      "CPUs.CPU.4.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "performance",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "conservative,ondemand,userspace,powersave,performance",
        "ScalingMaxFrequency": 2208000,
        "Enable": 1,
        "MaxFrequency": 2208000,
        "ScalingAvailableFrequencies": "936000,1104000,1416000,1488000,1800000,2208000",
        "ScalingMinFrequency": 936000,
        "MinFrequency": 936000
      },
      "CPUs.CPU.2.": {
        "Alias": "cpe-cpu1"
      },
      "CPUs.CPU.2.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "performance",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "conservative,ondemand,userspace,powersave,performance",
        "ScalingMaxFrequency": 2208000,
        "Enable": 1,
        "MaxFrequency": 2208000,
        "ScalingAvailableFrequencies": "936000,1104000,1416000,1488000,1800000,2208000",
        "ScalingMinFrequency": 936000,
        "MinFrequency": 936000
      },
      "CPUs.CPU.4.": {
        "Alias": "cpe-cpu3"
      },
      "CPUs.CPU.3.DVFS.": {
        "CurrentFrequency": \d+, (re)
        "ScalingGovernor": "performance",
        "Status": "Enabled",
        "Supported": 1,
        "ScalingAvailableGovernors": "conservative,ondemand,userspace,powersave,performance",
        "ScalingMaxFrequency": 2208000,
        "Enable": 1,
        "MaxFrequency": 2208000,
        "ScalingAvailableFrequencies": "936000,1104000,1416000,1488000,1800000,2208000",
        "ScalingMinFrequency": 936000,
        "MinFrequency": 936000
      },
      "CPUs.CPU.1.": {
        "Alias": "cpe-cpu0"
      },
      "CPUs.": {
        "CPUNumberOfEntries": 4
      }
    }
  ]
