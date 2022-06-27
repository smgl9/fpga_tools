# usefull comands

```
sudo adduser $USER dialout
```

```
cd /tools/Xilinx/Vivado/2019.2/data/xicom/cable_drivers/lin64/install_script/install_drivers
sudo ./install_drivers
```

# vivado repo git ignore

```
/.project
vivado_prj/
node_modules/
vunit_out/
html/
tmp
*.gcda
*.gcno
*.info
*.o
*.cf
*.tmp
*.csv
*.txt
*.project
*.pyc
*.s
out.xml
modelsim.do
hls_*/
venv/
fpga_modules/**/*.tcl
*.log
```
# Vivado docker

## Add Tini
```docker
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
```

# vivado locale

export LC_ALL=en_US.UTF-8

