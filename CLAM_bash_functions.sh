#!/bin/bash

## In theory, sets MATLAB path to find the data visualizations, in reality does not work due
## to permissions problems
function matlab_path_setup { 
    path_start=$CLAM_path
    sudo chown $USER /usr/local/MATLAB/R*/toolbox/local/pathdef.m
    r=$(find "$path_start/MATLAB_data_visualizations/" -type f -name "*.m" -exec dirname "{}" \; |sort -u)
    path1=""
    for folds in $r; do
        if [[ $path1 == "" ]]; then
            path1=\'$folds\';
        else
            path1="$path1,'$folds'";
        fi
    done
    matlab -r "addpath($path1);savepath;quit"
    sudo chown root /usr/local/MATLAB/R*/toolbox/local/pathdef.m
}

## Runs CLAM program to generate leases for all caching policies for all benchmarks
## for sizes provided by the user via command line prompts
## Argument -r: Sampling rate (default 256)
## Argument -s: Seed used to initialize sampling LFSR (default 1)
## Argument -m: Whether or not to generate for multi-level cache ['yes','no'] (default 'no')
## Argument -w: Set associativity (default fully associative) 
## Argument -c: Capacity of the cache (default 128 for single-level cache and 512 for multi-level)
## Inputs: User responses to prompts asking whether to generate for each benchmark size (small, medium, and large)
## Outputs: See clam help in README.md
function gen_leases {
    unset rate multi_level seed llt_size ways
    local OPTIND
#get options
    while getopts "m:r:s:l:w:c:" option; do
        case "$option" in
            r ) rate="$OPTARG";;
            s ) seed="$OPTARG";;
            m ) multi_level="$OPTARG";;
            l ) llt_size="$OPTARG";;
            w ) ways="$OPTARG";;
            c ) capacity="$OPTARG";;
            * ) return 0;;
        esac
    done
    #set defaults if not used
    capacity=${capacity:-128}
    rate=${rate-256}
    seed=${seed:-1}
    multi_level=${multi_level-no}
    if [[ "$multi_level" == "yes" ]]; then
        ways=${ways-512};
    else
        ways=${ways-128};
    fi
    llt_size=${llt_size-128}

     path_start=$CLAM_path
    
    cd "$path_start/software/CLAM";

    ./run.sh -m $multi_level -r $rate -s $seed -l $llt_size -w $ways -c $capacity;
    if [[ "$multi_level" == "yes" ]]; then
    ./post.sh $llt_size $ways $capacity
    else 
    ./post.sh $llt_size $ways $capacity
    fi
}

## Graphs the cache statistics from benchmark runs with MATLAB
## Argument $1: dataset_size ['small','medium','large','extra_large'] 
##      correspoinding to dataset size for which you want to plot statistics (optional)
## Argument $2: multi_level ['yes','no']
## Outputs: 
## miss graphs: plots the number of misses for different policies for different benchmarks 
##      for the given data set size and cache heriarchy normalized by the PLRU results.
## miss ratio: plots the number of misses as a percentage of total references for different 
##      policies for diferent benchmarks
## clock cycles: plots the number of clock cycles for different policies for 
##      different benchmarks normalized by the PLRU results
## Contention: On the bottom, the subplot displays the previously generated miss plot for reference 
##      On the top, the subplot is the ratio of random evictions to misses 
##      for different policies for different benchmarks, which is a measure of cache vacancy. 
## Scatter Absolute: plots the delta between projected and actual misses against the number of random evictions
##     	on a log log plot.
## Scatter percent error: plots the percent error between projected and actual misses against the ratio of random evictions
##      to total misses on a linear-linear plot.
## geomean.txt: The geomean values for misses and clock cycles
## All graphs are stored in:
##      $CLAM_path/MATLAB_data_visualizations/cache_statistics/cache_statistics_graphs
## geomean.txt is stored in:
##      $CLAM_path/MATLAB_data_visualizations/cache_statistics



function plot_cache_statistics {
    if [ "$#" -eq 2 ]; then
        matlab -nodesktop -r "plot_cache_summary "$1" "$2"; quit";
    elif [ "$#" -eq 1 ]; then
        matlab -nodesktop -r "plot_cache_summary "$1" "$2"; quit";
    else
        matlab -nodesktop -r "plot_cache_summary; quit";
    fi
}

## generate plots of eviction tracking results
## Argument $1: multi-level or single-level ['yes','no']
## Argument $2: dataset_size ['small','medium','large','extra_large']
## Outputs:
## eviction_tracking_graphs: Plots the reference data over time as a bar with different colors depending if there is no eviction
##     	random eviction, multi-expiry evictions, or single-expiry eviction for each benchmark for that dataset size. All policies for the same
##     	benchmark will be placed on a single graph.

function generate_eviction_tracking_results {
    if [ "$#" -eq 2 ]; then
        matlab -nodesktop -r "plot_eviction_tracking_results "$1" "$2"; quit";
    elif [ "$#" -eq 1 ]; then
        matlab -nodesktop -r "plot_eviction_tracking_results "$1";  quit";
    else
        matlab -nodesktop -r "plot_eviction_tracking_results; quit";
    fi
}

## Generates cache tenancy spectrums using data from the proxy TRACK command.
function generate_cache_spectrums {

    if [ "$#" -eq 4 ]; then 
        matlab -nodesktop -r "plot_tracking_results('"$1"','"$2"','"$3"',"$4"); quit"
    elif [ "$#" -eq 3 ]; then
        matlab -nodesktop -r "plot_tracking_results  "$1" "$2" "$3"; quit"
    elif [ "$#" -eq 2 ]; then
        matlab -nodesktop -r "plot_tracking_results  "$1" "$2"; quit"
    elif [ "$#" -eq 1 ]; then
        matlab -nodesktop -r "plot_tracking_results  "$1"; quit"
    else
        matlab -nodesktop -r "plot_tracking_results; quit";
    fi
}

## Changes directory to the FPGA proxy directory
function goto_proxy {
    path_start=$CLAM_path
    cd "$path_start/software/fpga_proxy"
}

## Changes directory to hardware base
function goto_hw {
    path_start=$CLAM_path
    cd "$path_start/hardware"
}

## Runs the FPGA proxy
## Argument -c: A double quoted command to run in the proxy. 
##      Individual commands may be separated by a ":"
## Postcondition: the user shell has the working directory $CLAM_path/software/fpga_proxy
##      The fpga proxy is running
function run_proxy {
    path_start=$CLAM_path
    goto_proxy;
    if [[ "$#" == 2 ]]; then
        ./bin/main $1 "$2";
    elif [[ "$#" == 0 ]]; then
        ./bin/main;
    fi
}

## Builds the fpga proxy
## Argument $1: if "multi-level" will make for a multi-level cache
##      Otherwise will build for a single level cache
function make_proxy {
    path_start=$CLAM_path
    if [[ "$1" == "multi-level" ]]; then
        (cd "$path_start/software/fpga_proxy" && make multi_level);
    else
        (cd "$path_start/software/fpga_proxy" && make);
    fi
}

## Opens the Quartus project for the single-level PLRU cache
function open_plru {
    path_start=$CLAM_path

    (cd $path_start/hardware/top/system_fa_plru_perfected/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}

function open_plru_multicore {
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_PLRU_multicore/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}



## Opens the Quartus project for the single-level lease cache
function open_lease_scope {
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_perfected/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}

## Opens the Quartus project for the multi-level lease cache
function open_lease_scope_multi_level {
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_multi_level/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}

## Opens the Quartus project for the multicore lease cache
function open_lease_multicore {
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_multicore/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}

## Opens the Quartus project for the multi-level PLRU cache
function open_plru_multi_level {
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_PLRU_multi_level/project
        /opt/intelFPGA/22.1std/quartus/bin/quartus --64bit *.qpf);
}

## Compiles all benchmarks for the policy and dataset size corresponding to the 
##      current working directory.
## NB: All benchmarks are compiled in parallel, and may briefly freeze the system
## Outputs: Compiled benchmark binaries and associated files
## Outputs are stored in the corresponding benchmark folder under the policy and dataset size folder
make_benchmarks (){
shopt -s nocasematch
# Run in a subshell so as not to mess with current shell's working directory
# CD into each benchmark directory and run make in parallel
(for i in *; do 
  
    if [ -d "$i" ]; then  
        cd  "$i" 

        make scope -s opt_level=O3 >/dev/null &
        cd ..; 
    fi
    
done)
shopt -u nocasematch
}

## Generates an FPGA proxy script to run all benchmarks for the policy and dataset
##      size corresponding to the current working directory.
## Outputs: fpga_proxy scripts to run the benchmarks for sampling.
##      Stored in $CLAM_path/software/fpga_proxy/scripts as run_all_<profile and size>.pss
make_run_all_script () 
{ 
    # Very similar to "make_sample_all_script" see comments there for explanation
    variant=$(pwd |sed -n 's/.*\/\([0-9A-Za-z_]*\)/\1/p');
    script_name=run_all_"$variant".pss;
    file_path=../../fpga_proxy/scripts/;
    rm -f "$file_path"/"$script_name";
    for i in *;
    do
        if [[ "$variant" == "SHEL"* || "$variant" == "C-SHEL"* ]]; then
            if [[ -d "$i" && "$i" != "atax" && "$i" != "bicg" && "$i" != "cholesky" && "$i" != "floyd-warshall" && "$i" != "gemm" && "$i" != "gesummv" \
                && "$i" != "gramschmidt" && "$i" != "jacobi-1d" && "$i" != "nussinov" && "$i" != "seidel-2d" && "$i" != "symm" && "$i" != "syr2k" && "$i" != "syrk" && "$i" != "trisolv" && "$i" != "trmm" && "$i" != "doitgen" && "$i" != "durbin"  ]]; then
                echo RUN ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
            fi;
        else
                echo RUN ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
        fi;
    done

}

## Generates an FPGA proxy script to run all benchmarks for the policy and dataset
##      size corresponding to the current working directory. Generates RUN_DUAL
## Outputs: fpga_proxy scripts to run the benchmarks for sampling.
##      Stored in $CLAM_path/software/fpga_proxy/scripts as run_all_<profile and size>.pss
make_run_all_script () 
{ 
    # Very similar to "make_sample_all_script" see comments there for explanation
    variant=$(pwd |sed -n 's/.*\/\([0-9A-Za-z_]*\)/\1/p');
    script_name=run_all_"$variant".pss;
    file_path=../../fpga_proxy/scripts/;
    rm -f "$file_path"/"$script_name";
    for i in *;
    do
        if [[ "$variant" == "SHEL"* || "$variant" == "C-SHEL"* ]]; then
            if [[ -d "$i" && "$i" != "atax" && "$i" != "bicg" && "$i" != "cholesky" && "$i" != "floyd-warshall" && "$i" != "gemm" && "$i" != "gesummv" \
                && "$i" != "gramschmidt" && "$i" != "jacobi-1d" && "$i" != "nussinov" && "$i" != "seidel-2d" && "$i" != "symm" && "$i" != "syr2k" && "$i" != "syrk" && "$i" != "trisolv" && "$i" != "trmm" && "$i" != "doitgen" && "$i" != "durbin"  ]]; then
                echo RUN ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
            fi;
        else
                echo RUN ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
        fi;
    done

}

## Generates an FPGA proxy script to track evictions for all benchmarks for the policy and dataset
##      size corresponding to the current working directory.
## Outputs: fpga_proxy scripts to run the benchmarks for sampling.
##      Stored in $CLAM_path/software/fpga_proxy/scripts as evict_track_all_<profile and size>.pss
make_evict_track_all_script () 
{ 
    # Very similar to "make_sample_all_script" see comments there for explanation
    variant=$(pwd |sed -n 's/.*\/\([0-9A-Za-z_]*\)/\1/p');
    script_name=evict_track_all_"$variant".pss;
    file_path=../../fpga_proxy/scripts/;
    rm -f "$file_path"/"$script_name";
    for i in *;
    do
        if [[ "$variant" == "SHEL"* || "$variant" == "C-SHEL"* ]]; then
            if [[ -d "$i" && "$i" != "atax" && "$i" != "bicg" && "$i" != "cholesky" && "$i" != "floyd-warshall" && "$i" != "gemm" && "$i" != "gesummv" \
                && "$i" != "gramschmidt" && "$i" != "jacobi-1d" && "$i" != "nussinov" && "$i" != "seidel-2d" && "$i" != "symm" && "$i" != "syr2k" && "$i" != "syrk" && "$i" != "trisolv" && "$i" != "trmm" && "$i" != "doitgen" && "$i" != "durbin"  ]]; then
                echo TRACKEV ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
            fi;
        else
                echo TRACKEV ../benchmarks/"$variant"/"$i"/program >> "$file_path"/"$script_name";
        fi;
    done

}


## Generates an FPGA proxy script to run all benchmarks for the policy and dataset
##      size corresponding to the current working directory and track cache line usage.
## Argument $1: (optional) tracker sampling rate, if not provided will use default of 256 references
## Outputs: fpga_proxy scripts to run the benchmarks for tracking.
##      Stored in $CLAM_path/software/fpga_proxy/scripts as track_all_<profile and size>.pss
make_track_all_script () 
{ 
    # Very similar to "make_sample_all_script" see comments there for explanation
    variant=$(pwd |sed -n 's/.*\/\([0-9A-Za-z_]*\)/\1/p');
    script_name=track_all_"$variant".pss;
    file_path=../../fpga_proxy/scripts/;
    rm -f "$file_path"/"$script_name";
    for i in *;
    do
        if [[ "$variant" == "SHEL"* || "$variant" == "C-SHEL"* ]]; then
            if [[ -d "$i" && "$i" != "atax" && "$i" != "bicg" && "$i" != "cholesky" && "$i" != "floyd-warshall" && "$i" != "gemm" && "$i" != "gesummv" \
                && "$i" != "gramschmidt" && "$i" != "jacobi-1d" && "$i" != "nussinov" && "$i" != "seidel-2d" && "$i" != "symm" && "$i" != "syr2k" && "$i" != "syrk" && "$i" != "trisolv" && "$i" != "trmm" && "$i" != "doitgen" && "$i" != "durbin" ]]; then
                echo TRACK ../benchmarks/"$variant"/"$i"/program $1>> "$file_path"/"$script_name";
            fi;
        else
                echo TRACK ../benchmarks/"$variant"/"$i"/program $1>> "$file_path"/"$script_name";
        fi;
    done

}

## Generates the script for fpga_proxy to command the fpga to run all benchmarks for
## the policy and dataset size as determined by the current directory when the function is run
## Argument $1:(optional) sample rate for sampler, default is 256
## Argument $2:(optional)  LFSR seed for sample, default is 1
## Outputs: fpga_proxy scripts to run the benchmarks for sampling.
##      Stored in $CLAM_path/software/fpga_proxy/scripts as sample_all_<profile and size>.pss
make_sample_all_script () 
{ 
    # Variant is the name of the current directory.
    # should be a Policy/dataset size directory such as software/benchmarks/CLAM_medium
    # $CLAM_path/software/benchmarks/CLAM_medium should yield "CLAM_medium"
    variant=$(pwd |sed -n 's/.*\/\([0-9A-Za-z_]*\)/\1/p');
    script_name=sample_all_"$variant".pss;
    file_path=../../fpga_proxy/scripts/;
    # Clear out any existing scripts
    rm -f "$file_path"/"$script_name";
    # For each benchmark
    for i in *;
    do
        # SHEL and C-SHEL Don't run all of the benchmarks, the ones it does are below
        if [[ "$variant" == "SHEL"* || "$variant" == "C-SHEL"* ]]; then
            if [[ -d "$i" && "$i" != "atax" && "$i" != "bicg" && "$i" != "cholesky" && "$i" != "floyd-warshall" && "$i" != "gemm" && "$i" != "gesummv" \
                && "$i" != "gramschmidt" && "$i" != "jacobi-1d" && "$i" != "nussinov" && "$i" != "seidel-2d" && "$i" != "symm" && "$i" != "syr2k" && "$i" != "syrk" && "$i" != "trisolv" && "$i" != "trmm" && "$i" != "doitgen" && "$i" != "durbin" ]]; then
                echo SAMPLE ../benchmarks/"$variant"/"$i"/program $1 $2>> "$file_path"/"$script_name";
            fi;
        # PRL and CLAM do run all of the benchmarks, so no need for the big check as above
        else
                echo SAMPLE ../benchmarks/"$variant"/"$i"/program $1 $2>> "$file_path"/"$script_name";
        fi;
    done

}


## Programs the FPGA with a multi-level lease Cache system
program_lease_scope_multi_level (){
    path_start=$CLAM_path
    (cd "$path_start/hardware/top/system_fa_dynamic_lease_multi_level/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;top.sof")
}

## Programs the FPGA with a multi-level PLRU Cache system
program_lease_multicore (){
    path_start=$CLAM_path
    (cd "$path_start/hardware/top/system_fa_PLRU_multicore/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;top.sof")
}

## Programs the FPGA with a multicore PLRU Cache system
program_plru_multicore (){
    path_start=$CLAM_path
    (cd "$path_start/hardware/top/system_fa_PLRU_multicore/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;top.sof")
}

## Programs the FPGA with a multi-level PLRU Cache system
program_plru_multi_level (){
    path_start=$CLAM_path
    (cd "$path_start/hardware/top/system_fa_PLRU_multi_level/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;top.sof")
}

## Programs the FPGA with a single-level lease Cache system
program_lease_scope (){
    path_start=$CLAM_path

    if [ $# -eq 0 ]; then
        variant="none"
        s="128"
        echo "Programming top_${variant}_${s}"
    elif [ $# -eq 3 ]; then
        case "$1" in 
            "TRACKER") variant="TRACKER";;
            *) variant="none";;
        esac
        case "$2" in
            "64")s="64";;
            "128")s="128";;
            *)s="128";;
        esac
        case "$3" in
            "OPT_EVICT")opt="OPTIMIZED_EVICTION_STRATEGIES";;
            *)opt="none";;
        esac
    else
        echo "Erro: too many arguments"
    fi

    top_file="top_${variant}_${opt}_${s}"
    (cd "$path_start/hardware/top/system_fa_dynamic_lease_perfected/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;${top_file}.sof")
}

## Programs the FPGA with a single-level PLRU Cache system
program_plru (){
    path_start=$CLAM_path

    if [ $# -eq 0 ]; then
        variant="none"
        s="128"
        echo "Programming top_${variant}_${s}"
    elif [ $# -eq 2 ]; then
        case "$1" in 
            "SAMPLER") variant="SAMPLER";;
            "TRACER") variant="TRACER";;
            "none") variant="none";;
            *);;
        esac
        case "$2" in
            "64")s="64";;
            "128")s="128";;
            *)s="128";;
        esac
    else
        echo "Erro: too many arguments"
    fi

    top_file="top_${variant}_${s}"
    (cd "$path_start/hardware/top/system_fa_plru_perfected/project/output_files/"
    /opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;${top_file}.sof")
}

## Synthesizes the single-level lease cache system
compile_lease_scope (){
    start=$(date +%s)   # Get how long it took in seconds
    if [ $# -eq 0 ]; then
        echo "No Arguments"
    elif [ $# -eq 1 ]; then
        case "$1" in 
            TRACKER)
                echo "Compiling with $1";;
            *)
                echo "Error: Invalid argument '${1}'"
                echo "Valid Lease Scope configurations are TRACKER or no arguments"
                return
        esac
    else
        echo "Error: Too many arguments"
        return
    fi
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_perfected/project
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)

    end=$(date +%s)
    elapsed=$((end - start))
    mins=$((elapsed / 60))
    secs=$((elapsed % 60))
    printf "Elapsed time: %d:%02d (min:sec)\n" "$mins" "$secs"
}

## Synthesizes the multi-core cache system
compile_plru_multicore (){
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_PLRU_multicore/project
    
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)
}

compile_lease_multicore (){
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_multicore/project
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)
}

## Synthesizes the single-level PLRU cache system
compile_plru (){
    start=$(date +%s)   # Get how long it took in seconds
    if [ $# -eq 0 ]; then
        echo "No Arguments"
    elif [ $# -eq 1 ]; then
        case "$1" in 
            SAMPLER|TRACER|TRACKER)
                echo "Compiling with $1";;
            *)
                echo "Error: Invalid argument '${1}'"
                echo "Valid PLRU configurations are SAMPLER, TRACER, TRACKER, or no arguments"
                return
        esac
    else
        echo "Error: Too many arguments"
        return
    fi
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_plru_perfected/project
    
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top --verilog_macro=${1}
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)

    end=$(date +%s)
    elapsed=$((end - start))
    mins=$((elapsed / 60))
    secs=$((elapsed % 60))
    printf "Elapsed time: %d:%02d (min:sec)\n" "$mins" "$secs"
}

## Synthesizes the multi-level lease cache system
compile_lease_scope_multi_level (){
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_dynamic_lease_multi_level/project
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)
}

## Synthesizes the multi-level PLRU cache system
compile_plru_multi_level (){
    path_start=$CLAM_path
    (cd $path_start/hardware/top/system_fa_PLRU_multi_level/project
    
    /opt/intelFPGA/22.1std/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top
    /opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top)
}
