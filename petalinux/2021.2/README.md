# Petalinux docker 

Tested for petalinux 2021.2

Copy petalinux-v2021.2-final-installer.run file to this folder. Then run:
```
docker build --build-arg VERSION=2021.2 --build-arg RUN_FILE=petalinux-v2021.2-final-installer.run -t petalinux:2021.2 .
```
After installation, launch petalinux with:

```
docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" --user $(id -u):$(id -g) -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/Projects:/home/vivado/project petalinux:2021.2 /bin/bash
```

```
docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" --user $(id -u):$(id -g) -v /home/ismael/path_to_somewhere/:/home/vivado/project petalinux:2021.2 /bin/bash
```

## Petalinux build

Basic flow to build a proyect
```
petalinux-create --type project --template zynq --name project_name -s system_base.bsp
petalinux-create -t project --template zynqMP -n project_name -s system_base.bsp
```
```
cd project_name
```
```
petalinux-config --get-hw-description path_to_xsa_file
```
```
petalinux-build
```
Building images with files from default paths or custom paths. 
```
petalinux-package --boot --fsbl  --fpga  --u-boot
petalinux-package --boot --fsbl zynqmp_fsbl.elf --u-boot u-boot.elf --pmufw pmufw.elf --fpga system.bit --force
```
Generate BSP.
```
petalinux-build -x mrproper
petalinux-package --bsp -p . --output ../petalinux_bsp.bsp
```

### Ubuntu rootfs

https://highlevel-synthesis.com/2019/12/15/running-ubuntu-on-ultra96v2-using-petalinux-2019-2-with-networking-and-linux-header/

### Reserve DDR

https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841683/Linux+Reserved+Memory

