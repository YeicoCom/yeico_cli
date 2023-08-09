#!/bin/bash -e

export LC_ALL=en_US.UTF-8

ACTION=$1
APP_NAME=$2
APP_SYNCD=${3:-127.0.0.1}
APP_HOME=/data/$APP_NAME
APP_PATH=/apps/$APP_NAME
APP_RUN=$APP_PATH/bin/$APP_NAME
APP_TMP=$APP_PATH/tmp

panic() { 
    >&2 echo $1
    exit 1
}

setup_host() {
    chmod -x /etc/update-motd.d/*
    mkdir -p /apps
    mkdir -p /data
    systemctl enable apps || echo Failure to enable apps
    systemctl restart apps || echo Failure to restart apps
}

run_app () {
    if ! (mount | grep $APP_TMP &>/dev/null); then
        echo App starting: $APP_NAME
        (mount tmpfs -t tmpfs $APP_TMP &>/dev/null) || panic "App tmp mount failed: $APP_NAME"
        trap "umount $APP_TMP &>/dev/null" EXIT
        mkdir -p $APP_HOME || panic "Home mkdir failure"
        cd $APP_HOME || panic "Home cd failure"
        $APP_RUN start
    else
        echo App already started: $APP_NAME
    fi
}

start_app () {
    if ! (mount | grep $APP_TMP &>/dev/null); then
        echo App starting: $APP_NAME
        (mount tmpfs -t tmpfs $APP_TMP &>/dev/null) || panic "App tmp mount failed: $APP_NAME"
        mkdir -p $APP_HOME || panic "Home mkdir failure"
        cd $APP_HOME || panic "Home cd failure"
        ($APP_RUN daemon &>/dev/null) || panic "App daemon failed: $APP_NAME"
        COUNTER=10
        while true; do
            APP_PID=$($APP_RUN pid 2>/dev/null || echo -n)
            [ "$APP_PID" == "" ] || break
            COUNTER=$[$COUNTER-1]
            [ $COUNTER == "0" ] && panic "App start timeout: $APP_NAME"
            sleep 1
        done
        echo App started: $APP_NAME $APP_PID
    else
        echo App already started: $APP_NAME
    fi
}

stop_app () {
    if (mount | grep $APP_TMP &>/dev/null); then
        echo App stopping: $APP_NAME
        # panicking here makes impossible to delete an app that won't start
        ($APP_RUN stop &>/dev/null) || echo "App stop failed: $APP_NAME"
        COUNTER=10
        while true; do
            umount $APP_TMP &>/dev/null || true
            (mount | grep $APP_TMP &>/dev/null) || break
            COUNTER=$[$COUNTER-1]
            [ $COUNTER == "0" ] && panic "App unmount timeout: $APP_NAME"
            sleep 1
        done
        echo App stopped: $APP_NAME
    else
        echo App not running: $APP_NAME
    fi
}

uninstall_app() {
    if [ -e $APP_PATH ]; then
        echo App uninstalling: $APP_NAME
        rm -fr $APP_PATH || panic "Remove app folder failure"
        echo App uninstalled: $APP_NAME
    else
        echo App not installed: $APP_NAME
    fi
}

rsync_app() {
    rsync -ar --delete $APP_SYNCD::$APP_NAME $APP_PATH || panic "Rsync failure"
    mkdir -p $APP_TMP || panic "Tmp mkdir failure"
    mkdir -p $APP_HOME || panic "Home mkdir failure"
    rm -f $APP_HOME/.iex.exs || panic ".iex.exs rm failure"
    [ -f $APP_PATH/.iex.exs ] && (ln -sf $APP_PATH/.iex.exs $APP_HOME/ || panic ".iex.exs link failure")
}

install_app() {
    if [ ! -e $APP_PATH ]; then
        echo App installing: $APP_NAME
        rsync_app
        echo App installed: $APP_NAME
    else
        echo App already installed: $APP_NAME
    fi
}

upgrade_app() {
    if ! (mount | grep $APP_TMP &>/dev/null); then
        echo App upgrading: $APP_NAME
        rsync_app
        echo App upgraded: $APP_NAME
    else
        echo App is running: $APP_NAME
    fi
}

list_apps() {
    cd /apps
    for app in $(ls)
    do
        # ignore erl_crash.dump
        [ -d $app ] || continue
        echo $app $($app/bin/$app pid 2>/dev/null)
    done    
}

case "$ACTION" in
    setup)
    setup_host
    ;;
    run)
    run_app
    ;;
    start)
    start_app
    ;;
    stop)
    stop_app
    ;;
    restart)
    stop_app
    start_app
    ;;
    install)
    install_app
    start_app
    ;;
    uninstall)
    stop_app
    uninstall_app
    ;;
    upgrade)
    stop_app
    upgrade_app
    start_app
    ;;
    list)
    list_apps
    ;;
    pid)
    $APP_RUN pid 2>/dev/null
    ;;
    shell)
    $APP_RUN remote
    ;;
    *)
    echo "Usage: $0 {setup|run|start|stop|restart|install|uninstall|upgrade|list|pid|shell}"
    exit 1
esac

exit 0
