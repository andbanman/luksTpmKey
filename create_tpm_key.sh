#!/bin/bash
#
# Generate a random key to be used in Luks
#

# Parameters
size=64
key=root.key
index=0x1500016
auth=0x40000001
dev=/dev/sdb

# Generate key and write it to TPM device
tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w $((size - 1)) | head -n 1 > $key
#tpm2_nvrelease -x $index -a $auth #XXX don't release automatically
tpm2_nvdefine  -x $index -a $auth -T device -s $size -t 0x2000A
tpm2_nvwrite   -x $index -a $auth -T device -f $key

# now add to Luks and crytptab
echo Next steps ...
echo "1. cryptsetup luksAddKey $dev $key"
echo "2. /etc/crypttab : [name] $dev none luks,discard,keyscript=/path/to/getkey.sh"
echo "3. cryptdisks_start [name]"
echo "4. rm $key"
