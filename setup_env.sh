#!/bin/bash
OPTSTRING=":ivhdfqn"
MODE="AUTOMATIC"
FORCE="false"
#Verbosity levels:
# 3 = details
# 2 = info
# 1 = warnings
# 0 = Errors
VERBOSITY=2

report_message () {
    # INFO level by default
    local message_level="2"
    local message="$1"
    if [[ $# -eq 2 ]] ; then
        message_level="$2"
    fi
    if [[ $VERBOSITY -ge $message_level ]] ; then
        echo "$message"
    fi
}

run_with_verbosity () {
    local command_verb_level=$1
    shift 1
    local command="$*"
    report_message "[DEBUG] Running command $command with verbosity level $command_verb_level" 5

    #If we're in dry-run mode, just say we ran the command, but don't
    if [[ $MODE == "DRYRUN" ]] ; then
        echo "RUN: $command"
        return 0
    fi

    # Run the command, redirecting output to /dev/null if the verbosity is too low
    if [[ $VERBOSITY -ge $command_verb_level ]] ; then
        $command
    else
        $command >/dev/null
    fi
}

# Process input arguments
# From https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/
while getopts "$OPTSTRING" opt ; do
    case ${opt} in
        # Interactive mode: Require user input for most steps, ask user questions
        i ) 
            MODE="INTERACTIVE"
            ;;
        # Verbose: increase verbosity by one level
        v )
            VERBOSITY=$(($VERBOSITY + 1))
            ;;
        # Debug: automatically set verbosity to max value
        # equivalent to "-vvvvvvvvvv"
        d )
            VERBOSITY=10
            ;;
        # Force: run things forcefully where available, generally a bad idea
        # Should not be documented in help message
        f )
            FORCE="true"
            ;;
        # Quiet: Make the script output fewer messages, may be specified multiple times
        q )
            VERBOSITY=$(($VERBOSITY - 1))
            if [[ $VERBOSITY -lt 0 ]] ; then
                VERBOSITY=0
            fi
            ;;
        # No Changes: do a "dry run" where nothing about the system is changed
        n )
            MODE="DRYRUN"
            ;;
        # Help
        h )
            echo "Usage: $0 [options]"
            echo Options:
            echo -e "-i\tRun in interactive mode"
            echo -e "-v\tVerbose: Include additional output (can be specified multiple times)"
            echo -e "-q\tQuiet: Run with less output"
            echo -e "-n\tNo Changes: run the script as a dry run"
            exit 0
            ;;
        # Invalid argument, inform the user
        \? )
            echo "Invalid Option: $OPTARG"
            echo "Use $0 -h for help"
            exit 1
            ;;
        # Argument which wanted a value didn't get one
        : )
            echo "Invalid Option: $OPTARG requires an argument" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [[ $FORCE == "true" ]] ; then
    report_message "[WARNING] Running commands forcefully!  This is usually not a good idea!" 1
fi

if [[ $0 != "./$(basename $0)" && $FORCE == "false" ]] ; then
    echo "[ERROR] You seem to be running the setup script from somewhere unintended." 1>&2
    echo "[ERROR] Please run the setup script from the root directory of the CLAM repository." 1>&2
    echo "[ERROR] (You may have also run the script with an absolute path, please run the script as ./$(basename $0))" 1>&2
    # If you're ABSOLUTELY POSITIVE you know what you're doing and you want to bypass this message
    # you can use -f to force it to run
    exit 1
fi

report_message "[DEBUG] Mode = $MODE" 5
report_message "[DEBUG] Verbosity = $VERBOSITY" 5
report_message "[DEBUG] Force = $FORCE" 5

if [[ $MODE == "AUTOMATIC" ]] ; then
    report_message "Setting up environment automatically.  The script will ask you for a sudo password and then will require no further input." 2
    report_message "To run interactively, press Ctrl-c twice, and then re-run script like './setup_env.sh -i'" 2
else
    report_message "Setting up environment interactively" 3
fi

sudo -v

report_message "Installing essential build packages" 2
if [[ "$MODE" == "INTERACTIVE" ]] ; then
    sudo apt update
    sudo apt install build-essential autoconf flex bison libtool clang-tools llvm-dev texinfo git
# For dry run or automatic mode, the "command" is the same, but whether is runs is different,
# which is checked by the run_with_verbosity
else 
    run_with_verbosity 3 sudo apt-get update --assume-yes
    run_with_verbosity 3 sudo apt-get install --assume-yes build-essential autoconf flex bison libtool clang-tools llvm-dev texinfo git
fi

report_message "Installing libpng12 which is necessary for quartus to work" 2
if [[ "$MODE" == "INTERACTIVE" ]] ; then
    sudo add-apt-repository ppa:linuxuprising/libpng12
    sudo apt update
    sudo apt install libpng12-0
# For dry run or automatic mode, the "command" is the same, but whether is runs is different,
# which is checked by the run_with_verbosity
else 
    run_with_verbosity 3 sudo add-apt-repository --yes ppa:linuxuprising/libpng12
    run_with_verbosity 3 sudo apt-get update --assume-yes
    run_with_verbosity 3 sudo apt-get install --assume-yes libpng12-0
fi

report_message "Setting up research path variable" 2
CLAM_path=$(pwd)
report_message "CLAM_path is $CLAM_path" 3
run_with_verbosity 2 echo "export CLAM_path=$CLAM_path >>~/.bashrc"

report_message "Adding bash functions to bashrc" 2
run_with_verbosity 2 echo "if [ -f $CLAM_path/CLAM_bash_functions.sh ]; then >> ~/.bashrc"
run_with_verbosity 2 echo "	. $CLAM_path/CLAM_bash_functions.sh >> ~/.bashrc"
run_with_verbosity 2 echo "fi >> ~/.bashrc"

report_message "Installing GNU RISCV-Embedded GCC" 2
if [[ $MODE == "INTERACTIVE" ]] ; then
    sudo apt install npm
    sudo npm install n -g
    sudo n stable
    sudo npm install --global xpm@latest
    xpm install --global @xpack-dev-tools/riscv-none-embed-gcc@8.3.0-2.3.1 --verbose
else
    run_with_verbosity 3 sudo apt-get install --assume-yes npm
    run_with_verbosity 3 sudo npm install n -g
    run_with_verbosity 3 sudo n stable
    run_with_verbosity 3 sudo npm install --global xpm@latest
    run_with_verbosity 3 xpm install --global @xpack-dev-tools/riscv-none-embed-gcc@8.3.0-2.3.1 --verbose
fi

# Do a little bit of extra work here in order to show the text of the file created in a dryrun
report_message "Setting up USB blaster device files" 2
if [[ $MODE == "DRYRUN" ]] ; then
    echo "CREATE: 51-usbblaster.rules"
    run_with_verbosity 3 sudo mv ./51−usbblaster.rules /etc/udev/rules.d/51−usbblaster.rules
    report_message "Text of 51-usbblaster.rules" 3
    report_message "# USB-Blaster" 3
    report_message "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6001\", MODE=\"0666\"" 3
    report_message "\"SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6002\", MODE=\"0666\"" 3
    report_message " " 3
    report_message "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6003\", MODE=\"0666\"" 3
    report_message " " 3
    report_message "# USB-Blaster II" 3
    report_message "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6010\", MODE=\"0666\"" 3
    report_message "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6810\", MODE=\"0666\"" 3
else
    # TODO check that this actually goes to the file with the extra EOF at the beginning
    cat > 51−usbblaster.rules<< EOF
"# USB-Blaster"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
"SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"

SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"

# USB-Blaster II
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
EOF
    run_with_verbosity 3 sudo mv ./51−usbblaster.rules /etc/udev/rules.d/51−usbblaster.rules
fi

report_message "Installing curl" 2
if [[ $MODE == "INTERACTIVE" ]] ; then
    sudo apt install curl
else
    run_with_verbosity 3 sudo apt-get install --assume-yes curl 
fi

report_message "Installing rust and rust cargo package manager" 2
if [[ $MODE == "DRYRUN" ]] ; then
    run_with_verbosity 3 "curl https://sh.rustup.rs -sSf | sh"
    run_with_verbosity 3 echo . "$HOME/.cargo/env >> ~/.bashrc"
elif [[ $MODE == "INTERACTIVE" ]] ; then
    curl https://sh.rustup.rs -sSf | sh
    echo . "$HOME/.cargo/env" >> ~/.bashrc
else
    # YOU MADE ME DO THIS BASH
    curl https://sh.rustup.rs -sSf -o "__rustup.sh"
    chmod u+x ./__rustup.sh
    run_with_verbosity 3 ./__rustup.sh -q -y
    echo . "$HOME/.cargo/env" >> ~/.bashrc
    rm -f ./__rustup.sh
fi

report_message "Installing Pluto optimizing compiler" 2
if [[ $MODE == "INTERACTIVE" ]] ; then
    mkdir -p ~/.cache/build
    OLD_DIR="$(pwd)"
    cd ~/.cache/build
    git clone https://github.com/bondhugula/pluto.git
    cd pluto
    git checkout v0.11.4
    git submodule init
    git submodule update
    ./configure
    make
    make test
    sudo make install
fi


echo Done!
