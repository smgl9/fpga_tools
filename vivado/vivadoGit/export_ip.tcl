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
  namespace export ip_tcl

proc set_system_variables {} {
  variable g_dir_project
  variable g_dir_repo
  variable g_dir_repoSrc
  variable g_dir_repoBD
  variable g_dir_repoIp

  set g_dir_project [get_property DIRECTORY [get_projects]]

  set g_dir_repo [file dirname ${g_dir_project}]
  set g_dir_repoSrc ${g_dir_repo}/src
  set g_dir_repoIp ${g_dir_repoSrc}/ip
}

proc ip_tcl {} {
  variable g_dir_repoIp
  variable v_file_ips_tcl
  
  set_system_variables
  
  file mkdir ${g_dir_repoIp}

  set v_file_ips_tcl [file join ${g_dir_repoIp} ips.tcl]
  set ips_tcl [open "${v_file_ips_tcl}" "w"]
  set ip_list [get_ips -filter {SCOPE == ""}]

  puts ${ips_tcl} "# IPCores "
  foreach ip_name ${ip_list} {
    set ip_properties_list [list_property [get_ips ${ip_name}]]
    set ip_def [get_property IPDEF [get_ips ${ip_name}]]
    regexp {([^:]+):([^:]+):([^:]+):([^:]+)} ${ip_def} => ip_def_vendor ip_def_library ip_def_name ip_def_version
    puts ${ips_tcl} "#  ${ip_def_name} Properties definition "
    puts ${ips_tcl} "set ip_name ${ip_name}"
    puts ${ips_tcl} "create_ip -name ${ip_def_name} -vendor ${ip_def_vendor} -library ${ip_def_library} -version ${ip_def_version} -module_name \${ip_name}"
    puts ${ips_tcl} "set_property -dict \[list \\"
    foreach ip_property ${ip_properties_list} {
      if { [string match *CONFIG.* ${ip_property} ] } {
        set ip_value_pro [get_property ${ip_property} [get_ips ${ip_name}] ]
        puts ${ips_tcl} "  ${ip_property} \{${ip_value_pro}\} \\"
      }
    }
    puts ${ips_tcl} "  \] \[get_ips \${ip_name}\]"
    puts ${ips_tcl} "#  ${ip_def_name}  "
    puts ${ips_tcl} ""
  }
  close ${ips_tcl}
}

}
