# Backup
```sh
time guestfish <<EOF
add ~/daedalus.qcow2
run
mount /dev/debian-vg/root /
tar-out /home/packer/.local/share/Daedalus/mainnet/chain/ ~/chain-backup.tar.gz compress:gzip
EOF
```

# Restore
```sh
cp output-daedalus-qemu/packer-daedalus-qemu ~/daedalus.qcow2
time guestfish <<EOF
add ~/daedalus.qcow2
run
mount /dev/debian-vg/root /
mkdir-p /home/packer/.local/share/Daedalus/mainnet/chain/
tar-in ~/chain-backup.tar.gz /home/packer/.local/share/Daedalus/mainnet/chain/ compress:gzip
EOF
```
