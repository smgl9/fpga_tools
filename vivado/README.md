# Installation

```
sudo sh ./install.sh  /tools/Xilinx/Vivado/2019.2/scripts/
```

# Use

Create a vivado project inside a folder named vivado_prj
In tcl console: 

```
fpga_tools::vivado_tcl
```

# Rebuild project

GUI:
```
vivado -> tools -> Run tcl script -> project.tcl
```
CLI:
```
vivado -mode batch –source project.tcl
```