#!/bin/sh
#
# Print the key stored in a TPM device.
#

# Parameters must match what was used in create_tpm_key.sh
size=64
index=0x1500016
auth=0x40000001

# Read, format, and print the key
tpm2_nvread -x $index -a $auth -s $size -o 0 -T device | tail -n 1 |
	tr -d ' ' | /usr/bin/perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie'
