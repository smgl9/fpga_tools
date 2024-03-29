# Copyright 2021
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
  namespace export project_tcl

proc set_system_variables {} {
  variable g_dir_project
  variable g_dir_repo
  variable g_dir_repoSrc
  variable g_dir_repoBD
  variable g_dir_repoIp
  variable g_dir_project_BD
  variable g_dir_projConf
  variable g_dir_projImpl
  variable g_dir_projPR
  variable g_dir_ipRepos
  variable g_vivado_prjFolder

  variable g_current_project
  variable g_project_name
  variable g_top_name
  variable g_default_lib
  variable g_part
  variable g_simulator_language
  variable g_target_language
  variable g_target_simulator
  variable g_board_part
  variable g_project_type

  set g_dir_project [get_property DIRECTORY [get_projects]]

  set g_dir_repo [file dirname ${g_dir_project}]
  set g_dir_repoSrc ${g_dir_repo}/src
  set g_dir_repoBD ${g_dir_repoSrc}/bd
  set g_dir_repoIp ${g_dir_repoSrc}/ip
  set g_dir_projConf ${g_dir_repoSrc}/config
  set g_dir_projImpl ${g_dir_repoSrc}/impl
  set g_dir_projPR ${g_dir_repoSrc}/pr
  set g_dir_ipRepos [get_property ip_repo_paths [current_project ]]
  set g_vivado_prjFolder "vivado_prj"

  set g_current_project [current_project]
  set g_project_name [get_property -name "name" -object ${g_current_project}]
  set g_top_name [get_property top [current_fileset]]
  set g_default_lib [get_property -name "default_lib" -object ${g_current_project}]
  set g_part [get_property -name "part" -object ${g_current_project}]
  set g_simulator_language [get_property -name "simulator_language" -object ${g_current_project}]
  set g_target_language [get_property -name "target_language" -object ${g_current_project}]
  set g_target_simulator [get_property -name "target_simulator" -object ${g_current_project}]
  set g_board_part [get_property -name "board_part" -object ${g_current_project}]
  set g_project_type [get_property -name "project_type" -object ${g_current_project}]

  set g_dir_project_BD [file join ${g_dir_project} ${g_project_name}.srcs/sources_1/bd]
}

# relative path function
proc get_rel_path { abs_dir rel_dir } {

  set file_split [file split ${abs_dir}]
  set repo_split [file split ${rel_dir}]

  set file_count [llength ${file_split}]
  set repo_count [llength ${repo_split}]

  set index 0

  while { [lindex ${file_split} ${index}] == [lindex ${repo_split} ${index}] } {
    incr index
    if { (${index} == ${file_count}) || (${index} == ${repo_count}) } {
      break;
    }
  }

  if { ${index} != 0 } {
    set pp_dir ""
    set pp_index $index

    while { (${pp_index} != ${repo_count}) } {
      set pp_dir "../$pp_dir"
      incr pp_index
    }

    set src_dir ""
    set src_index $index

    while { (${src_index} != ${file_count}) } {
      if { (${src_index} == ${index}) } {
        set src_dir [lindex $file_split $src_index]
      } else {
        set src_dir "${src_dir}/[lindex $file_split $src_index]"
      }
      incr src_index
    }
    set result ${pp_dir}${src_dir}
  } else {
    set result $file_path
  }

  return $result
}

# Tcl project generation
proc project_tcl { } {
  variable g_dir_project
  variable g_dir_repo
  variable g_dir_repoSrc
  variable g_dir_repoBD
  variable g_dir_repoIp
  variable g_dir_projConf
  variable g_dir_projImpl
  variable g_dir_projPR
  variable g_dir_ipRepos
  variable g_vivado_prjFolder
  
  variable g_project_name
  variable g_top_name
  variable g_part
  variable g_board_part
  variable g_target_language
  variable g_default_lib

  set_system_variables
  
  set file_name_bd_top 0

  set v_file_top_tcl ${g_dir_repo}/${g_project_name}.tcl
  set prj_tcl [open "${v_file_top_tcl}" "w"]
  
  puts ${prj_tcl} "# Init Project "
  puts ${prj_tcl} "set script_path \[file normalize \[info script\]\]"
  puts ${prj_tcl} "set script_dir \[file dirname \${script_path}\]"
  puts ${prj_tcl} "set ${g_vivado_prjFolder} \[file dirname \${script_path}\]"

  puts ${prj_tcl} "file mkdir \${script_dir}/${g_vivado_prjFolder}"
  puts ${prj_tcl} "create_project ${g_project_name} \${script_dir}/${g_vivado_prjFolder} -force"

  puts ${prj_tcl} "# Properties "
  puts ${prj_tcl} "set_property target_language ${g_target_language} \[current_project\]"
  puts ${prj_tcl} "set_property default_lib ${g_default_lib} \[current_project\]"
  if {[string trim $g_board_part] != ""} {
    puts ${prj_tcl} "set_property board_part ${g_board_part} \[current_project\]"  
    } else {
      puts ${prj_tcl} "set_property part ${g_part} \[current_project\]"
    }
  

  puts ${prj_tcl} "# Sources"
  puts ${prj_tcl} "update_compile_order -fileset \[get_filesets sources_1\]"
  puts ${prj_tcl} "remove_files \[get_files -filter {IS_AUTO_DISABLED}\]"

  set list_files [get_files -all -of [get_filesets {sources_1}] -filter {FILE_TYPE == VHDL || FILE_TYPE == VERILOG}]
  puts ${prj_tcl} "# HDL Sources"
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    set file_split [file split ${rel_val}]
    if { ([lindex ${file_split} 0] != ${g_vivado_prjFolder}) } {
      puts ${prj_tcl} "add_files -fileset \[get_filesets sources_1\] \${script_dir}\/${rel_val}"
    }
  }

  # Memory File
  set list_files [get_files -all -of [get_filesets {sources_1}] -filter {FILE_TYPE == "Memory File"}]
  puts ${prj_tcl} "# Memory files"
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    set file_split [file split ${rel_val}]
    if { ([lindex ${file_split} 0] != ${g_vivado_prjFolder}) } {
      puts ${prj_tcl} "add_files -fileset \[get_filesets sources_1\] \${script_dir}\/${rel_val}"
    }
  }

  # Coefficient Files
  set list_files [get_files -all -of [get_filesets {sources_1}] -filter {FILE_TYPE == "Coefficient Files"}]
  puts ${prj_tcl} "# Coefficient Files"
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    set file_split [file split ${rel_val}]
    if { ([lindex ${file_split} 0] != ${g_vivado_prjFolder}) } {
      puts ${prj_tcl} "add_files -fileset \[get_filesets sources_1\] \${script_dir}\/${rel_val}"
    }
  }

  # Constraints
  set list_files [get_files -all -of [get_filesets {constrs_1}] -filter {FILE_TYPE == XDC}]
  puts ${prj_tcl} "# XDC files"
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    set file_split [file split ${rel_val}]
    if { ([lindex ${file_split} 0] != ${g_vivado_prjFolder}) } {
      puts ${prj_tcl} "add_files -fileset \[get_filesets constrs_1\] \${script_dir}\/${rel_val}"
    }
  }
  # DCP files
  set list_files [get_files -all -of [get_filesets {sources_1}] -filter {FILE_TYPE == "Design Checkpoint"}]
  puts ${prj_tcl} "# Design Checkpoint files"
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    set file_split [file split ${rel_val}]
    if { ([lindex ${file_split} 0] != ${g_vivado_prjFolder}) } {
      puts ${prj_tcl} "add_files -fileset \[get_filesets sources_1\] \${script_dir}\/${rel_val}"
    }
  }
  
  # Set repositories.
  puts ${prj_tcl} "#  Set Repository"
  
  foreach file_path ${g_dir_ipRepos} {
    set rel_val [get_rel_path ${file_path} ${g_dir_repo}]
    puts ${prj_tcl} "set_property  ip_repo_paths  \${script_dir}\/${rel_val} \[current_project\]"
  }
  puts ${prj_tcl} "update_ip_catalog -rebuild"
  
  # Add extra tcl script
  puts ${prj_tcl} "# Config tcl"
  set list_files [glob -nocomplain ${g_dir_projConf}/*.tcl]
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${g_dir_projConf} ${g_dir_repo}]
    set file_name [file tail ${file_path}]
    puts ${prj_tcl} "source \${script_dir}\/${rel_val}/${file_name}"
  }
  
  puts ${prj_tcl} "# IP tcl"
  set rel_val [get_rel_path ${g_dir_repoIp} ${g_dir_repo}]
  puts ${prj_tcl} "source \${script_dir}\/${rel_val}/ips.tcl"
  
  puts ${prj_tcl} "# BD tcl"
  set list_files [glob -nocomplain ${g_dir_repoBD}/*.tcl]
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${g_dir_repoBD} ${g_dir_repo}]
    set file_name [file tail ${file_path}]
    set bd_name [file rootname $file_name]
    set bd_wrapper ${bd_name}_wrapper
    if { ${bd_wrapper} eq ${g_top_name} } {
        set file_name_bd_top ${bd_name}
    } else {
        puts ${prj_tcl} "source \${script_dir}\/${rel_val}/${file_name}"
    }
  }
  # Top BD is the last to load
  if {${file_name_bd_top} != 0} {
    puts ${prj_tcl} "source \${script_dir}\/${rel_val}/${file_name_bd_top}.tcl"
  }
  
  #top generation
  puts ${prj_tcl} "# Project top"
  puts ${prj_tcl} "set_property top ${g_top_name} \[current_fileset\]"
  puts ${prj_tcl} "set project_top \[get_property top \[current_fileset\]\]"
  if {${file_name_bd_top} != 0} {
    puts ${prj_tcl} "if {!\[info exists \${project_top}\]} {
        make_wrapper -files \[get_files \${script_dir}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${file_name_bd_top}/${file_name_bd_top}.bd\] -top
        add_files -norecurse \${script_dir}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${file_name_bd_top}/hdl/${file_name_bd_top}_wrapper.vhd}"
    }

  # Config options per BD
  set list_files [glob -nocomplain ${g_dir_repoBD}/*.tcl]
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${g_dir_repoBD} ${g_dir_repo}]
    set file_name [file tail ${file_path}]
    set bd_name [file rootname $file_name]
    set g_synth_ooc [get_property synth_checkpoint_mode [get_files  ${g_dir_repo}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd]]
    puts ${prj_tcl} "#  Synthesis config for ${bd_name} block design"
    puts ${prj_tcl} "set_property synth_checkpoint_mode ${g_synth_ooc} \[get_files \${script_dir}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd\]"
#   puts ${prj_tcl} "set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects \[get_runs synth_1\]"
    }
  
    # Set DXF configuration if vivado supports it.
    set vivado_version_text [version]
    set vivado_version [string map {"." ""} [string range $vivado_version_text 8 13]]
    if {${vivado_version} >= 20211} {
        set pr_flow_config [get_property PR_FLOW [current_project]]
        if {${pr_flow_config} == 1} {
            puts ${prj_tcl} "# PR flow config"
            puts ${prj_tcl} "set_property PR_FLOW ${pr_flow_config} \[current_project\]"
            puts ${prj_tcl} "open_bd_design {\[\${script_dir}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${file_name_bd_top}/${file_name_bd_top}.bd\]}"
            # add partial reconfiguration script.
            puts ${prj_tcl} "# Partial reconfiguration tcl"
            set list_files [glob -nocomplain ${g_dir_projPR}/*.tcl]
            foreach file_path ${list_files} {
                set rel_val [get_rel_path ${g_dir_projPR} ${g_dir_repo}]
                set file_name [file tail ${file_path}]
                puts ${prj_tcl} "source \${script_dir}\/${rel_val}/${file_name}"
            }
            puts ${prj_tcl} "validate_bd_design"
            puts ${prj_tcl} "save_bd_design"
            puts ${prj_tcl} "generate_target all \[get_files \${script_dir}/${g_vivado_prjFolder}/${g_project_name}.srcs/sources_1/bd/${file_name_bd_top}/${file_name_bd_top}.bd\]"
        }
    }
    
  # Add extra tcl script. Post-configuration/implementation script.
  puts ${prj_tcl} "# Implementation tcl"
  set list_files [glob -nocomplain ${g_dir_projImpl}/*.tcl]
  foreach file_path ${list_files} {
    set rel_val [get_rel_path ${g_dir_projImpl} ${g_dir_repo}]
    set file_name [file tail ${file_path}]
    puts ${prj_tcl} "source \${script_dir}\/${rel_val}/${file_name}"
  }
  
  close ${prj_tcl}
}

}
