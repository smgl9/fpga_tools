# vivado 2020.1 unattended installation

1. Download and extract xilinx_unified package
2. Generate authentication token using xilinx account

```
./xsetup -b AuthTokenGen
```
3. Generate config file
```
./xsetup -b ConfigGen
```
4. installation
```
sudo ./xsetup --batch Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --config "~/.Xilinx/install_config.txt"
```

# Vivado 2020.1 unattended install ussing web installer

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

# Unattender hw_server installation

```
tar xzf Xilinx_HW_Server_Lin_2018.2_0614_1954.tar.gz
cd Xilinx_HW_Server_Lin_2018.2_0614_1954
sudo ./xsetup -b ConfigGen
#Edit the generated install_config.txt and after that:
sudo ./xsetup -a XilinxEULA,3rdPartyEULA,WebTalkTerms -b Install -c /root/.Xilinx/install_config.txt
```
