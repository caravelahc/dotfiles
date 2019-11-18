#!/usr/bin/env bash


backup() {
    local dir="backups/$1"
    shift 1
    local files="$*"

    mkdir -p ${dir}

    for file in ${files}
    do
        basefile=$(basename ${file})
        if [[ -f ${file} ]] && [[ ! -f "${dir}/${basefile}" ]]
        then
            echo "  - Backing up ${file}"
            mv "${file}" "${dir}/${basefile}"
        fi
    done
}


install-i3-configs() {
    echo "== Installing i3 configs..."
    backup i3 ~/.i3 ~/.config/i3
    ln -sf i3 ~/.config/
    echo "-- Done installing i3 configs."
}


install-conky-configs() {
    echo "== Installing Conky configs..."
    backup ./ ~/.config/conky
    ln -sf conky ~/.config/
    echo "-- Done installing conky configs."
}


install-all-configs() {
    echo "-- Installing All configs..."
    echo "-- All configs installed."
}


main() {
    local configs=$*

    if [[ -z ${configs} ]]
    then
        configs="i3 conky"
    fi

    echo "Installing configs..."
    for config in ${configs}
    do
        install-${config}-configs $*
    done
    echo "Done."
}


main $*
