#!/bin/bash
#
# Generate a random key stored in TPM to be used in Luks.
#

# Parameters
size=64
key=tpmluks.key
index=0x1500016
auth=0x40000001
dev=/dev/sdb
name=sdb_crypt

# Generate key and write it to TPM device
tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w $((size - 1)) | head -n 1 > $key
#tpm2_nvrelease -x $index -a $auth #XXX don't release automatically
tpm2_nvdefine  -x $index -a $auth -T device -s $size -t 0x2000A
tpm2_nvwrite   -x $index -a $auth -T device -f $key
rm $key

echo Next steps ...
echo "1. Add key to LUKS        # cryptsetup luksAddKey $dev $key"
echo "2. Update /etc/crypttab   # $name $dev none luks,discard,initramfs,keyscript=/path/to/get_tpm_key.sh"
echo "3. Verify TPM-LUKS setup  # cryptdisks_start $name"
echo "4. Install initrd hook    # install -m0755 -oroot -groot decrypt_tpm_key /etc/initramfs-tools/hooks/decrypt_tpm_key"
echo "5. Remake initrd          # mkinitramfs -o ..."
echo "6. Reboot and verify      # reboot"
