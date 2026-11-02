#!/bin/bash
## @Author Alex Kneipp <ahk8565@rit.edu>
## Builds a release of the project for publication on github, allowing someone to download a 
## version of the project with the FPGA images already built and the benchmarks already sampled

#TODO
# [ ] Redirect all output to files, print colorful status messages
# [X] Compile all projects
# [X] Compile JTAG proxy
# [X] Compile all benchmarks
# [ ] Make sampling scripts
# [ ] Run sampling for all 
# (May need to try multiple times, do a timeout and check return code)
# [ ] Generate leases for all benchmarks
# [ ] make benchmark scripts
# NB. Do not need to run benchmarks for all, that can be done by end user
# [ ] Create release report which details all of the commands run
# [ ] Create readable release report which summarizes important information about the build state
# [X] Create zip file of release with necessary files


RELEASE_FILE="release.zip"
MSG_LEN=70

## Pretty print exit status corresponding to the provided error code and string length
status () {
    local ERR_CODE=$1
    if [[ $ERR_CODE -eq 0 ]] ; then
        printf "\033[0;32m [ SUCCESS! ]\033[0m\n" 
    else
        printf "\033[0;31m [ FAILURE! ]\033[0m\n"
    fi
}

print_message () {
    local MESSAGE="$1"
    local FIELD_WIDTH="$2"
    printf "%-${FIELD_WIDTH}s" "$MESSAGE"
}
# Get all of the CLAM utility functions so we don't need to repeat them
. ./CLAM_bash_functions.sh

#### BEGIN TESTING AREA ####
#### END TESTING AREA ####

#exit 0
rm -f "$RELEASE_FILE"

print_message "Making FPGA Proxy" $MSG_LEN
make_proxy > /dev/null
status $?

print_message "Making Benchmarks" $MSG_LEN
(cd software/benchmarks && ./makeall_benchmarks.sh) > /dev/null
status $?

# Compile all of the quartus projects (Takes a loooonnnnggg time)
print_message "Compiling PLRU cache project (May take a very long time)" $MSG_LEN
compile_plru > /dev/null
status $?

print_message "Compiling multi-level PLRU cache project (May take a very long time)" $MSG_LEN
compile_plru_multi_level > /dev/null
status $?

print_message "Compiling lease cache project (May take a very long time)" $MSG_LEN
compile_lease_scope > /dev/null
status $?

print_message "Compiling multi-level lease cache project (May take a very long time)" $MSG_LEN
compile_lease_scope_multi_level > /dev/null
status $?

print_message "Zipping up directory" $MSG_LEN
SAVED_DIR=$(pwd)
cd ..
zip -r "$(basename $SAVED_DIR)"/"$RELEASE_FILE" "$(basename $SAVED_DIR)"/* -x \*.o > /dev/null
status $?
cd "$SAVED_DIR"
