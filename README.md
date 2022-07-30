![daedalus](daedalus.png "Daedalus")

# Virtualbox
```sh
packer init daedalus.pkr.hcl
^init^build^
```

# Kvm
```sh
ssh-keygen \
  -P "" \
  -f packer \
  -t ed25519 \
  ;
cp packer.pub preseed/
packer init daedalus-qemu.pkr.hcl
^init^build^
```
