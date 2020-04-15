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
namespace eval ::fpga_tools {
  namespace export bd_tcl

proc set_system_variables {} {
    variable g_dir_project
    variable g_dir_repo
    variable g_dir_repoSrc
    variable g_dir_repoBD

    set g_dir_project [get_property DIRECTORY [get_projects]]

    set g_dir_repo [file dirname ${g_dir_project}]
    set g_dir_repoSrc ${g_dir_repo}/src
    set g_dir_repoBD ${g_dir_repoSrc}/bd
}

proc bd_tcl {} {
  variable g_dir_repoBD
  set_system_variables
  set bds_files [get_files -filter {FILE_TYPE == "Block Designs"}]
  if {[file isdirectory ${g_dir_repoBD}]} {
    file delete -force ${g_dir_repoBD}
  }
  file mkdir ${g_dir_repoBD}
  foreach bd_name ${bds_files} {
    open_bd_design ${bd_name}
    set bd_name_file [file rootname [file tail $bd_name]]
    write_bd_tcl -make_local -force "${g_dir_repoBD}/${bd_name_file}.tcl"
    close_bd_design [current_bd_design]
  }
}

}
