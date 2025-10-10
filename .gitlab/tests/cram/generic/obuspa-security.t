
Create R alias for remote execution:
  $ alias R="${CRAM_REMOTE_COMMAND:-}"

ba-cli and obuspa output for Device.Security shall be the same:

  $ R "ba-cli 'Device.Security.?' | grep -E 'Device.+[^.?]$' | sed 's/\\\"//g' | sort > /tmp/ba-cli.kv"
  $ R "obuspa -c get 'Device.Security.' | grep '=>' | sed 's/ => /=/' | sed 's/true/1/' | sed 's/fals e/0/' | sort > /tmp/obuspa.kv"
  $ R "cmp /tmp/ba-cli.kv /tmp/obuspa.kv"