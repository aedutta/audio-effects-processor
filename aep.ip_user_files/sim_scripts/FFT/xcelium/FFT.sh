#!/bin/bash -f
#**********************************************************************************************************
# Vivado (TM) v2024.1 (64-bit)
#
# Script generated by Vivado on Mon Dec 09 01:24:17 -0600 2024
# SW Build 5076996 on Wed May 22 18:37:14 MDT 2024
#
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved. 
#
# Filename     : FFT.sh
# Simulator    : Cadence Xcelium Parallel Simulator
# Description  : Simulation script generated by export_simulation Tcl command
# Purpose      : Run 'compile', 'elaborate', 'simulate' steps for compiling, elaborating and simulating the
#                design. The script will copy the library mapping file from the compiled library directory,
#                create design library directories and library mappings in the mapping file.
#
# Usage        : FFT.sh
#                FFT.sh [-lib_map_path] [-step] [-keep_index] [-noclean_files]*
#                FFT.sh [-reset_run]
#                FFT.sh [-reset_log]
#                FFT.sh [-help]
#
#               * The -noclean_files switch is deprecated and will not peform any function (by default, the
#                 simulator generated files will not be removed unless -reset_run switch is used)
#
# Prerequisite : Before running export_simulation, you must first compile the AMD simulation library
#                using the 'compile_simlib' Tcl command (for more information, run 'compile_simlib -help'
#                command in the Vivado Tcl shell). After compiling the library, specify the -lib_map_path
#                switch with the directory path where the library is created while generating the script
#                with export_simulation.
#
#                Alternatively, you can set the library path by setting the following project property:-
#
#                 set_property compxlib.<simulator>_compiled_library_dir <path> [current_project]
#
#                You can also point to the simulation library by either setting the 'lib_map_path' global
#                variable in this script or specify it with the '-lib_map_path' switch while executing this
#                script (type 'FFT.sh -help' for more information).
#
#                Note: For pure RTL based designs, the -lib_map_path switch can be specified later with the
#                generated script, but if design is targetted for system simulation containing SystemC/C++/C
#                sources, then the library path MUST be specified upfront when calling export_simulation.
#
#                For more information, refer 'Vivado Design Suite User Guide:Logic simulation (UG900)'
#
#**********************************************************************************************************

# catch pipeline exit status
set -Eeuo pipefail

# set xmvhdl compile options
xmvhdl_opts="-64bit -messages -logfile .tmp_log -update"

# set xmvlog compile options
xmvlog_opts="-64bit -messages -logfile .tmp_log -update"

# set xmelab elaboration options
xmelab_opts="-64bit -relax -access +rwc -namemap_mixgen -messages -logfile elaborate.log"

# set xmsim simulation options
xmsim_opts="-64bit -logfile simulate.log"

# set design libraries for elaboration
design_libs_elab="-libname xbip_utils_v3_0_13 -libname axi_utils_v2_0_9 -libname c_reg_fd_v12_0_9 -libname xbip_dsp48_wrapper_v3_0_6 -libname xbip_pipe_v3_0_9 -libname xbip_dsp48_addsub_v3_0_9 -libname xbip_addsub_v3_0_9 -libname c_addsub_v12_0_18 -libname c_mux_bit_v12_0_9 -libname c_shift_ram_v12_0_17 -libname xbip_bram18k_v3_0_9 -libname mult_gen_v12_0_21 -libname cmpy_v6_0_24 -libname floating_point_v7_0_23 -libname xfft_v9_1_12 -libname xil_defaultlib -libname secureip"

# set design libraries
design_libs=(simprims_ver xbip_utils_v3_0_13 axi_utils_v2_0_9 c_reg_fd_v12_0_9 xbip_dsp48_wrapper_v3_0_6 xbip_pipe_v3_0_9 xbip_dsp48_addsub_v3_0_9 xbip_addsub_v3_0_9 c_addsub_v12_0_18 c_mux_bit_v12_0_9 c_shift_ram_v12_0_17 xbip_bram18k_v3_0_9 mult_gen_v12_0_21 cmpy_v6_0_24 floating_point_v7_0_23 xfft_v9_1_12 xil_defaultlib)

# simulation root library directory
sim_lib_dir="xcelium_lib"

# script info
echo -e "FFT.sh - Script generated by export_simulation (Vivado v2024.1 (64-bit)-id)\n"

# main steps
run()
{
  check_args $*
  setup
  if [[ ($b_step == 1) ]]; then
    case $step in
      "compile" )
       init_lib
       compile
      ;;
      "elaborate" )
       elaborate
      ;;
      "simulate" )
       simulate
      ;;
      * )
        echo -e "ERROR: Invalid or missing step '$step' (type \"./FFT.sh -help\" for more information)\n"
        exit 1
      esac
  else
    init_lib
    compile
    elaborate
    simulate
  fi
}

# RUN_STEP: <compile>
compile()
{
  xmvhdl -work xbip_utils_v3_0_13 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \
  2>&1 | tee compile.log; cat .tmp_log > xmvhdl.log 2>/dev/null

  xmvhdl -work axi_utils_v2_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work c_reg_fd_v12_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xbip_dsp48_wrapper_v3_0_6 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xbip_pipe_v3_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xbip_dsp48_addsub_v3_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xbip_addsub_v3_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_addsub_v3_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work c_addsub_v12_0_18 $xmvhdl_opts \
  "../../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work c_mux_bit_v12_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/c_mux_bit_v12_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work c_shift_ram_v12_0_17 $xmvhdl_opts \
  "../../../ipstatic/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xbip_bram18k_v3_0_9 $xmvhdl_opts \
  "../../../ipstatic/hdl/xbip_bram18k_v3_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work mult_gen_v12_0_21 $xmvhdl_opts \
  "../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work cmpy_v6_0_24 $xmvhdl_opts \
  "../../../ipstatic/hdl/cmpy_v6_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work floating_point_v7_0_23 $xmvhdl_opts \
  "../../../ipstatic/hdl/floating_point_v7_0_vh_rfs.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xfft_v9_1_12 -V200X $xmvhdl_opts \
  "../../../ipstatic/hdl/float_pkg.vhd" \
  "../../../ipstatic/hdl/cfloat_pkg.vhd" \
  "../../../ipstatic/hdl/DELAY.vhd" \
  "../../../ipstatic/hdl/CDELAY.vhd" \
  "../../../ipstatic/hdl/BDELAY.vhd" \
  "../../../ipstatic/hdl/DS.vhd" \
  "../../../ipstatic/hdl/CB.vhd" \
  "../../../ipstatic/hdl/DSN.vhd" \
  "../../../ipstatic/hdl/DSPFP32_GW.vhd" \
  "../../../ipstatic/hdl/InputSwap.vhd" \
  "../../../ipstatic/hdl/PARFFT2.vhd" \
  "../../../ipstatic/hdl/PARFFT4.vhd" \
  "../../../ipstatic/hdl/PARFFT.vhd" \
  "../../../ipstatic/hdl/R2BUTTERFLY.vhd" \
  "../../../ipstatic/hdl/R2TableFP32.vhd" \
  "../../../ipstatic/hdl/R4BUTTERFLY.vhd" \
  "../../../ipstatic/hdl/R4TableFP32.vhd" \
  "../../../ipstatic/hdl/STAGE.vhd" \
  "../../../ipstatic/hdl/SystolicFFT.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_core_ssr.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xfft_v9_1_12 $xmvhdl_opts \
  "../../../ipstatic/hdl/xfft_v9_1_viv_comp.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_comp.vhd" \
  "../../../ipstatic/hdl/pkg.vhd" \
  "../../../ipstatic/hdl/half_sincos_tw_table.vhd" \
  "../../../ipstatic/hdl/quarter_sin_tw_table.vhd" \
  "../../../ipstatic/hdl/quarter2_sin_tw_table.vhd" \
  "../../../ipstatic/hdl/adder.vhd" \
  "../../../ipstatic/hdl/adder_bypass.vhd" \
  "../../../ipstatic/hdl/logic_gate.vhd" \
  "../../../ipstatic/hdl/equ_rtl.vhd" \
  "../../../ipstatic/hdl/cnt_sat.vhd" \
  "../../../ipstatic/hdl/cnt_tc_rtl.vhd" \
  "../../../ipstatic/hdl/cnt_tc_rtl_a.vhd" \
  "../../../ipstatic/hdl/cnt_tc_rtl_b.vhd" \
  "../../../ipstatic/hdl/shift_ram.vhd" \
  "../../../ipstatic/hdl/srl_fifo.vhd" \
  "../../../ipstatic/hdl/mux_bus2.vhd" \
  "../../../ipstatic/hdl/mux_bus4.vhd" \
  "../../../ipstatic/hdl/mux_bus8.vhd" \
  "../../../ipstatic/hdl/mux_bus16.vhd" \
  "../../../ipstatic/hdl/mux_bus32.vhd" \
  "../../../ipstatic/hdl/dist_mem.vhd" \
  "../../../ipstatic/hdl/dpm.vhd" \
  "../../../ipstatic/hdl/dpm_hybrid.vhd" \
  "../../../ipstatic/hdl/reg_rs_rtl.vhd" \
  "../../../ipstatic/hdl/sub_byp.vhd" \
  "../../../ipstatic/hdl/sub_byp_j.vhd" \
  "../../../ipstatic/hdl/subtracter.vhd" \
  "../../../ipstatic/hdl/xor_bit_gate.vhd" \
  "../../../ipstatic/hdl/arith_shift1.vhd" \
  "../../../ipstatic/hdl/arith_shift3.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_hybrid.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_bypass.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_bypass_hybrid.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_mul_j_bypass.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_mul_j_bypass_hybrid.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_simd.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_simd_bypass.vhd" \
  "../../../ipstatic/hdl/butterfly_dsp48e_simd_mul_j_bypass.vhd" \
  "../../../ipstatic/hdl/bf_dsp.vhd" \
  "../../../ipstatic/hdl/bf_dsp_bypass.vhd" \
  "../../../ipstatic/hdl/bf_dsp_mul_j_bypass.vhd" \
  "../../../ipstatic/hdl/bfly_byp.vhd" \
  "../../../ipstatic/hdl/bfly_byp_j.vhd" \
  "../../../ipstatic/hdl/butterfly.vhd" \
  "../../../ipstatic/hdl/twos_comp.vhd" \
  "../../../ipstatic/hdl/cmpy.vhd" \
  "../../../ipstatic/hdl/dfly_byp.vhd" \
  "../../../ipstatic/hdl/dragonfly_dsp48_bypass.vhd" \
  "../../../ipstatic/hdl/so_xk_counter.vhd" \
  "../../../ipstatic/hdl/flow_control_b.vhd" \
  "../../../ipstatic/hdl/flow_control_c.vhd" \
  "../../../ipstatic/hdl/max2_2.vhd" \
  "../../../ipstatic/hdl/in_ranger.vhd" \
  "../../../ipstatic/hdl/in_switch4.vhd" \
  "../../../ipstatic/hdl/out_addr_gen_b.vhd" \
  "../../../ipstatic/hdl/out_switch4.vhd" \
  "../../../ipstatic/hdl/overflow_gen.vhd" \
  "../../../ipstatic/hdl/unbiased_round.vhd" \
  "../../../ipstatic/hdl/pe4.vhd" \
  "../../../ipstatic/hdl/r2_in_addr.vhd" \
  "../../../ipstatic/hdl/r2_ovflo_gen.vhd" \
  "../../../ipstatic/hdl/r2_pe.vhd" \
  "../../../ipstatic/hdl/range_r2.vhd" \
  "../../../ipstatic/hdl/r2_ranger.vhd" \
  "../../../ipstatic/hdl/r2_rw_addr.vhd" \
  "../../../ipstatic/hdl/r2_tw_addr.vhd" \
  "../../../ipstatic/hdl/twgen_distmem.vhd" \
  "../../../ipstatic/hdl/twgen_distmem_so.vhd" \
  "../../../ipstatic/hdl/twgen_half_sincos.vhd" \
  "../../../ipstatic/hdl/twgen_quarter_sin.vhd" \
  "../../../ipstatic/hdl/twiddle_gen.vhd" \
  "../../../ipstatic/hdl/r2_control.vhd" \
  "../../../ipstatic/hdl/scale_logic.vhd" \
  "../../../ipstatic/hdl/r2_datapath.vhd" \
  "../../../ipstatic/hdl/rw_addr_gen_b.vhd" \
  "../../../ipstatic/hdl/tw_gen_p2.vhd" \
  "../../../ipstatic/hdl/tw_gen_p4.vhd" \
  "../../../ipstatic/hdl/tw_addr_gen.vhd" \
  "../../../ipstatic/hdl/r4_control.vhd" \
  "../../../ipstatic/hdl/range_r4.vhd" \
  "../../../ipstatic/hdl/r4_ranger.vhd" \
  "../../../ipstatic/hdl/r4_datapath.vhd" \
  "../../../ipstatic/hdl/r22_twos_comp_mux.vhd" \
  "../../../ipstatic/hdl/r22_delay_mux.vhd" \
  "../../../ipstatic/hdl/r22_srl_memory.vhd" \
  "../../../ipstatic/hdl/r22_memory.vhd" \
  "../../../ipstatic/hdl/r22_bfly_byp.vhd" \
  "../../../ipstatic/hdl/r22_bf.vhd" \
  "../../../ipstatic/hdl/r22_bf_sp.vhd" \
  "../../../ipstatic/hdl/r22_cnt_ctrl.vhd" \
  "../../../ipstatic/hdl/r22_flow_ctrl.vhd" \
  "../../../ipstatic/hdl/r22_ovflo.vhd" \
  "../../../ipstatic/hdl/r22_busy.vhd" \
  "../../../ipstatic/hdl/r22_tw_gen.vhd" \
  "../../../ipstatic/hdl/r22_pe.vhd" \
  "../../../ipstatic/hdl/r22_right_shift.vhd" \
  "../../../ipstatic/hdl/r22_shift_decode.vhd" \
  "../../../ipstatic/hdl/r22_var_unbiased_round.vhd" \
  "../../../ipstatic/hdl/so_n_counter.vhd" \
  "../../../ipstatic/hdl/so_io_addr_gen.vhd" \
  "../../../ipstatic/hdl/so_run_addr_gen_rotator.vhd" \
  "../../../ipstatic/hdl/so_run_addr_gen_left_shift.vhd" \
  "../../../ipstatic/hdl/so_run_addr_gen.vhd" \
  "../../../ipstatic/hdl/so_addr_gen.vhd" \
  "../../../ipstatic/hdl/so_control_fsm.vhd" \
  "../../../ipstatic/hdl/so_control.vhd" \
  "../../../ipstatic/hdl/so_memory.vhd" \
  "../../../ipstatic/hdl/so_ranger.vhd" \
  "../../../ipstatic/hdl/so_datapath.vhd" \
  "../../../ipstatic/hdl/pipe_blank.vhd" \
  "../../../ipstatic/hdl/fp_get_block_max_exp.vhd" \
  "../../../ipstatic/hdl/fp_convert_to_block_fp.vhd" \
  "../../../ipstatic/hdl/fp_convert_to_fp.vhd" \
  "../../../ipstatic/hdl/fp_shift_ram_clr_op.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_axi_pkg.vhd" \
  "../../../ipstatic/hdl/axi_wrapper_input_fifo.vhd" \
  "../../../ipstatic/hdl/axi_wrapper_output_fifo.vhd" \
  "../../../ipstatic/hdl/axi_wrapper.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_b.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_c.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_d.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_e.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_fp.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_core.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1_viv.vhd" \
  "../../../ipstatic/hdl/xfft_v9_1.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null

  xmvhdl -work xil_defaultlib $xmvhdl_opts \
  "../../../../spectrogram.gen/sources_1/ip/FFT/sim/FFT.vhd" \
  2>&1 | tee -a compile.log; cat .tmp_log >> xmvhdl.log 2>/dev/null
}

# RUN_STEP: <elaborate>
elaborate()
{
  xmelab $xmelab_opts $design_libs_elab xil_defaultlib.FFT
}

# RUN_STEP: <simulate>
simulate()
{
  xmsim $xmsim_opts xil_defaultlib.FFT -input simulate.do
}

# STEP: setup
setup()
{
  # delete previous files for a clean rerun
  if [[ ($b_reset_run == 1) ]]; then
    reset_run
    echo -e "INFO: Simulation run files deleted.\n"
    exit 0
  fi

 # delete previous log files
  if [[ ($b_reset_log == 1) ]]; then
    reset_log
    echo -e "INFO: Simulation run log files deleted.\n"
    exit 0
  fi

  # add any setup/initialization commands here:-

  # <user specific commands>

}

# simulator index file/library directory processing
init_lib()
{
  if [[ ($b_keep_index == 1) ]]; then
    # keep previous design library mappings
    true
  else
    # define design library mappings
    create_lib_mappings
  fi

  if [[ ($b_keep_index == 1) ]]; then
    # do not recreate design library directories
    true
  else
    # create design library directories
    create_lib_dir
  fi
}

# define design library mappings
create_lib_mappings()
{
  file="hdl.var"
  touch $file

  file="cds.lib"
  if [[ -e $file ]]; then
    if [[ ($lib_map_path == "") ]]; then
      return
    else
      rm -rf $file
    fi
  fi

  touch $file


  if [[ ($lib_map_path != "") ]]; then
    incl_ref="INCLUDE $lib_map_path/cds.lib"
    echo $incl_ref >> $file
  fi

  for (( i=0; i<${#design_libs[*]}; i++ )); do
    lib="${design_libs[i]}"
    mapping="DEFINE $lib $sim_lib_dir/$lib"
    echo $mapping >> $file
  done
}

# create design library directory
create_lib_dir()
{
  if [[ -e $sim_lib_dir ]]; then
    rm -rf $sim_lib_dir
  fi
  for (( i=0; i<${#design_libs[*]}; i++ )); do
    lib="${design_libs[i]}"
    lib_dir="$sim_lib_dir/$lib"
    if [[ ! -e $lib_dir ]]; then
      mkdir -p $lib_dir
    fi
  done
}

# delete generated data from the previous run
reset_run()
{
  files_to_remove=(xmvlog.log xmvhdl.log xmsc.log compile.log elaborate.log simulate.log diag_report.log xsc_report.log FFT_sc.so .tmp_log xcelium_lib waves.shm c.obj)
  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      rm -rf $file
    fi
  done
}

# delete generated log files from the previous run
reset_log()
{
  files_to_remove=(xmvlog.log xmvhdl.log xmsc.log compile.log elaborate.log simulate.log diag_report.log xsc_report.log .tmp_log)
  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      rm -rf $file
    fi
  done
}

# check switch argument value
check_arg_value()
{
  if [[ ($1 == "-step") && (($2 != "compile") && ($2 != "elaborate") && ($2 != "simulate")) ]];then
    echo -e "ERROR: Invalid or missing step '$2' (type \"./top.sh -help\" for more information)\n"
    exit 1
  fi

  if [[ ($1 == "-lib_map_path") && ($2 == "") ]];then
    echo -e "ERROR: Simulation library directory path not specified (type \"./FFT.sh -help\" for more information)\n"
    exit 1
  fi
}

# check command line arguments
check_args()
{
  arg_count=$#
  if [[ ("$#" == 1) && (("$1" == "-help") || ("$1" == "-h")) ]]; then
    usage
  fi
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -step)          check_arg_value $1 $2;step=$2;         b_step=1;         shift;;
      -lib_map_path)  check_arg_value $1 $2;lib_map_path=$2; b_lib_map_path=1; shift;;
      -gen_bypass)    b_gen_bypass=1    ;;
      -reset_run)     b_reset_run=1     ;;
      -reset_log)     b_reset_log=1     ;;
      -keep_index)    b_keep_index=1    ;;
      -noclean_files) b_noclean_files=1 ;;
      -help|-h)       ;;
      *) echo -e "ERROR: Invalid option specified '$1' (type "./top.sh -help" for more information)\n"; exit 1 ;;
    esac
     shift
  done

  # -reset_run is not applicable with other switches
  if [[ ("$arg_count" -gt 1) && ($b_reset_run == 1) ]]; then
    echo -e "ERROR: -reset_run switch is not applicable with other switches (type \"./top.sh -help\" for more information)\n"
    exit 1
  fi

  # -reset_log is not applicable with other switches
  if [[ ("$arg_count" -gt 1) && ($b_reset_log == 1) ]]; then
    echo -e "ERROR: -reset_log switch is not applicable with other switches (type \"./top.sh -help\" for more information)\n"
    exit 1
  fi

  # -keep_index is not applicable with other switches
  if [[ ("$arg_count" -gt 1) && ($b_keep_index == 1) ]]; then
    echo -e "ERROR: -keep_index switch is not applicable with other switches (type \"./top.sh -help\" for more information)\n"
    exit 1
  fi

  # -noclean_files is not applicable with other switches
  if [[ ("$arg_count" -gt 1) && ($b_noclean_files == 1) ]]; then
    echo -e "ERROR: -noclean_files switch is not applicable with other switches (type \"./top.sh -help\" for more information)\n"
    exit 1
  fi
}

# script usage
usage()
{
  msg="Usage: FFT.sh [-help]\n\
Usage: FFT.sh [-step]\n\
Usage: FFT.sh [-lib_map_path]\n\
Usage: FFT.sh [-reset_run]\n\
Usage: FFT.sh [-reset_log]\n\
Usage: FFT.sh [-keep_index]\n\
Usage: FFT.sh [-noclean_files]\n\n\
[-help] -- Print help information for this script\n\n\
[-step <name>] -- Execute specified step (simulate)\n\n\
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Delete simulator generated data files from the previous run and recreate simulator setup\n\
file/library mappings for a clean run. This switch will not execute steps defined in the script.\n\n\
NOTE: To keep simulator index file settings from the previous run, use the -keep_index switch\n\
NOTE: To regenerate simulator index file but keep the simulator generated files, use the -noclean_files switch\n\n\
[-reset_log] -- Delete simulator generated log files from the previous run\n\n\
[-keep_index] -- Keep simulator index file settings from the previous run\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run\n"
  echo -e $msg
  exit 0
}

# initialize globals
step=""
lib_map_path=""
b_step=0
b_lib_map_path=0
b_gen_bypass=0
b_reset_run=0
b_reset_log=0
b_keep_index=0
b_noclean_files=0

# launch script
run $*