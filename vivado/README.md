# Vivado unattended install ussing web installer


Extract Web Installer Batch Mode Client & gen auth token
```
sh ./Xilinx_Unified_2020.1_0602_1208_Lin64.bin --keep --noexec --target ./
./xsetup -b AuthTokenGen

```
```
./xsetup -b ConfigGen
nano ~/.Xilinx/install_config.txt
sudo ./xsetup -b Install -a XilinxEULA,3rdPartyEULA,WebTalkTerms -c ~/.Xilinx/install_config.txt
```

# VivadoGit

## Installation

```
sudo sh ./install.sh  /tools/Xilinx/Vivado/2019.2/scripts/
```

## Use

Create a vivado project inside a folder named vivado_prj
In tcl console: 

```
fpga_tools::vivado_tcl
```

