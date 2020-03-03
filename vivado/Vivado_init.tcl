# Copyright 2020
# Ismael Pérez Rojo (ismaelprojo@gmail.com)
#
# This file is part of FPGA_tools.
#
# FPGA_tools is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# FPGA_tools is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FPGA_tools.  If not, see <https://www.gnu.org/licenses/>.

package require Vivado 1.2017.1
set vivado_prj_tcl [file dirname [info script]]

source ${vivado_prj_tcl}/vivadoGit/export_bd.tcl
namespace import fpga_tools::bd_tcl

source ${vivado_prj_tcl}/vivadoGit/export_ip.tcl
namespace import fpga_tools::ip_tcl

source ${vivado_prj_tcl}/vivadoGit/export_top.tcl
namespace import fpga_tools::project_tcl

source ${vivado_prj_tcl}/vivadoGit/export_project.tcl
namespace import fpga_tools::vivado_tcl
