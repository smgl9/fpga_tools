# connect to ssh

## install sshpass
```bash
sudo apt-get install sshpass
```

## Examples
```bash
SSHPASS='mypass' sshpass -e ssh root@zynq
SSHPASS='mypass' sshpass -e ssh root@zynq date
SSHPASS='mypass' sshpass -e ssh root@zynq w
SSHPASS='mypass' sshpass -e ssh -o StrictHostKeyChecking=no root@192.168.1.1
```

## putty cli

```
plink -serial /dev/ttyUSB0 -sercfg 115200,8,1,N,N
```
