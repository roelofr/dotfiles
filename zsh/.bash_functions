# vim: set ft=sh :

function apt() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade)
            sudo apt $@
            ;;
        *)
            $( which apt ) $@
            ;;
    esac
}

function apt-get() {
    case "$1" in
        install|uninstall|purge|autoremove|update|upgrade)
            sudo apt-get $@
            ;;
        *)
            $( which apt-get ) $@
            ;;
    esac
}

function service() {
    case "$1" in
        reload|restart|stop|start) 
            sudo service $@
            ;;
        *)
            $( which service ) $@
            ;;
    esac
}

