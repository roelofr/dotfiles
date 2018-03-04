# vim: set ft=sh :

function run_command() {
    command_name="$1"
    command_exec="$( bash -c "which $command_name" )"
    shift
    "$command_exec" $@
}

function apt() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade)
            echo "+sudo apt $@"
            sudo apt $@
            ;;
        *)
            run_command apt $@
            ;;
    esac
}

function apt-get() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade)
            echo "+sudo apt-get $@"
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
            ;;
        *)
            run_command service $@
            ;;
    esac
}

