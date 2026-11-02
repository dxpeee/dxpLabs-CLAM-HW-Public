#!/usr/bin/sh

# Directories to search for .sof files
SEARCH_DIRS="./top/system_fa_plru_perfected/project/output_files ./top/system_fa_dynamic_lease_perfected/project/output_files ./top/system_fa_slider_perfected/project/output_files ./top/system_fa_plru_multi_level/project/output_files ./top/system_fa_dynamic_lease_multi_level/project/output_files ./top/system_fa_slider_multi_level/project/output_files"

# make a temp file to hold the paths to sofs we find
SOF_LIST=$(mktemp)

# find all the .sof in the search dirs
for dir in $SEARCH_DIRS; do
    if [ -d "$dir" ]; then
        find "$dir" -type f -name "*.sof" >> "$SOF_LIST"
    fi
done

# Find the number of files
NUM_FILES=$(wc -l < "$SOF_LIST")

# check for no files
if [ "$NUM_FILES" -eq 0 ]; then
    echo "No .sof files found"
    rm -rf "$SOF_LIST"
    exit 1
fi

echo "Found the following .sof files:"
i=1
# Go though temp file and read line by line and create a variable SOF_# for the corresponding to the .sof it is tied to
while IFS= read -r file; do
    printf " [%2d] %s\n" "$i" "$file"
    eval "SOF_$i=\"$file\""
    i=$((i+1))
done < "$SOF_LIST"


echo
echo "Enter the number of the file to program: "
read ANSWER

# Choose the sof file we want
eval "SOF_FILE=\$SOF_$ANSWER"

if [ -z "$SOF_FILE" ]; then
    echo "Invalid selection"
    rm -f "$SOF_LIST"
    exit 1
fi

echo "Selected: $SOF_FILE"
echo "Program FPGA with this file? (y/n): "
read CONFIFM

# Verify
if [ "$CONFIFM" != "y" ] && [ "$CONFIFM" != "Y" ]; then
    echo "Aborted"
    rm -f "$SOF_LIST"
    exit 1
fi

# program
/opt/intelFPGA/22.1std/quartus/bin/quartus_pgm -c USB-BlasterII -m JTAG -o "P;$SOF_FILE"
echo "\n"
