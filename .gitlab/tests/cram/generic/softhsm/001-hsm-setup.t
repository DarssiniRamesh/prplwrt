Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"
  $ alias C="${CRAM_REMOTE_COPY:-}"


Verify that SoftHSM slot is initialised

  $ R "softhsm2-util --show-slots | grep -q -e 'Initialized.*yes'"


Verify that the expected keys are stored in SoftHSM

  $ R "pkcs11-tool --module /usr/lib/softhsm/libsofthsm2.so --login --pin 1234 --list-objects 2>&1 | grep -q 'ca-key'"
  $ R "pkcs11-tool --module /usr/lib/softhsm/libsofthsm2.so --login --pin 1234 --list-objects 2>&1 | grep -q 'server-key'"


Check pkcs11 openssl support:

  $ R "openssl engine -t | grep -q 'pkcs11 engine'"


Create a certificate using PKCS11 URIs

  $ R "openssl req -new -engine pkcs11 -keyform ENGINE -key 'pkcs11:object=server-key;type=private' -out /tmp/server.csr -subj '/CN=prplOS.lan' &> /dev/null"
  $ R "ls /tmp/server.csr &> /dev/null"
  $ R "openssl x509 -req -in /tmp/server.csr -CA /root/certs/ca.crt -engine pkcs11 -CAkeyform ENGINE -CAkey 'pkcs11:object=ca-key;type=private' -CAcreateserial -out /tmp/server.crt -days 3650 -sha256 &> /dev/null"
  $ R "ls /tmp/server.crt &> /dev/null"

