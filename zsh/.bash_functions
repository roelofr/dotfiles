# vim: set ft=sh :

function run_command() {
    command_name="$1"
    command_exec="$( bash -c "which $command_name" )"
    shift
    "$command_exec" $@
}

function apt() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade|clean)
            echo "+sudo apt $@"
            sudo -p "Enter password for %u to $1 packages: " apt $@
            ;;
        *)
            run_command apt $@
            ;;
    esac
}

function apt-get() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade|clean)
            echo "+sudo apt-get $@"
            sudo -p "Enter password for %u to $1 packages: " apt-get $@
            ;;
        *)
            run_command apt-get $@
            ;;
    esac
}

function service() {
    case "$1" in
        reload|restart|stop|start) 
            echo "+sudo service $@"
            sudo -p "Password for %u to run $3 on service $2: " service $@
            ;;
        *)
            run_command service $@
            ;;
    esac
}

