#!/usr/bin/env bash


# Backups files into "backup" directory.
# Usage: backup <dir> <files...>
# Args:
#     dir    Where files will be moved to (prefixed by "backup").
#     files  Which files will be backed up. Please notice the target will be
#            their basename.
backup() {
    local dir="backup/$1"
    shift 1
    local files="$*"

    mkdir -p ${dir}

    for file in ${files}
    do
        basefile=$(basename ${file})

	if [[ -e "${dir}/${basefile}" ]]
	then
            echo " -- Backup already exists. Skipping. (\"${dir}/${basefile}\")"
            continue
	fi

        if [[ -e ${file} ]]
        then
            echo "  - Backing up ${file}"
            mv "${file}" "${dir}/${basefile}"
        else
            echo "  - No ${file}. Skipping."
        fi
    done
}


make-link() {
    local target="${1}"
    local source="${2}"

    ln -sf "$(pwd)/${target}" "${source}"
}


install-i3-configs() {
    backup i3 ~/.i3 ~/.config/i3
    make-link i3 ~/.config
}


install-conky-configs() {
    backup ./ ~/.config/conky
    make-link conky ~/.config
}


install-home-configs() {
    backup home ~/.profile
    make-link home/profile ~/.profile
}


install-all-configs() {
    local configs="conky home i3"
    echo "-- Installing All configs..."
    for config in ${configs}
    do
        install-config "${config}"
    done
    echo "-- All configs installed."
}


install-config() {
    local config="${1}"
    shift 1

    echo "== Installing ${1} configs..."
    install-${config}-configs $*
    echo "-- Done installing ${1} configs."
}


main() {
    local configs=$*

    if [[ -z ${configs} ]]
    then
        install-all-configs
    else
        echo "Installing configs: [${configs/ /, }]"
        for config in ${configs}
        do
            install-config ${config} $*
        done
        echo "Done."
    fi
}


main $*
