#!/bin/bash
ROOT_PATH=$(cd $(dirname $0);pwd)
BIN_PATH=$ROOT_PATH"/bin"
DATA_PATH=$ROOT_PATH"/data"


function pathadd() {
    newelement=${1%/}
    bash_file=$HOME"/.bash_profile"
    if [ -d "$1" ] && ! cat $bash_file | grep -E -q "$newelement" ; then
        if [ "$2" = "after" ] ; then
            #PATH="$PATH:$newelement"
            add='export PATH="$PATH:'"$newelement"'"'
        else
            #PATH="$newelement:$PATH"
            add='export PATH="'"$newelement"':$PATH"'
        fi
        echo "$add" >> $bash_file
        source $bash_file
        echo "请重启终端使环境变量生效。"
        echo "或手动执行: source $bash_file"
        exit 1
    fi
}

function pathrm() {
    PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

function mv_brtconf() {
    if [ ! -f $DATA_PATH"/brt.conf" ] ; then
        cp $DATA_PATH"/brt.conf.example" $DATA_PATH"/brt.conf"
    fi
}


# 1. copy brt.conf
mv_brtconf

# 5. 添加 PATH
pathadd "$BIN_PATH" before
echo "===== tools install ok ====="