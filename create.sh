#!/bin/bash

set -o nounset

TARGET_APP_NAME="Netbeans.app"

function usage () {
    echo "Creates Apache Netbeans start application for MacOS."
    echo "Parameters:"
    echo "  -n : full qualified path to Apache Netbeans directory"
    exit 0
}

while getopts n:h opt; do
    case "${opt}" in
        n) eval "NETBEANS_DIR='${OPTARG%/}'";;
        h) usage ;;
        \?) usage
    esac
done

if [ ! -f "${NETBEANS_DIR}/bin/netbeans" ]; then
    echo "Failure: no netbeans script available at ${NETBEANS_DIR}/bin/netbeans"
    echo "Abort"
    exit 1
fi

if [ -d "./target" ]; then
    rm -rf "./target"
fi

mkdir "./target"

cp -r "Netbeans.template" "./target/${TARGET_APP_NAME}"

echo "${NETBEANS_DIR}/bin/netbeans" >> "./target/${TARGET_APP_NAME}/Contents/MacOS/netbeans.command"
echo "exit 0" >> "./target/Netbeans.app/Contents/MacOS/netbeans.command"

echo "Netbeans.app successfully created in target folder."

if [ -d "${HOME}/Applications" ]; then
    echo "Should I copy to ${HOME}/Applications? [y/n]"
    read -n 1 copy_answer
    if [ "${copy_answer}" == 'y' ] || [ "${copy_answer}" == 'Y' ]; then
        if [ -d "${HOME}/Applications/${TARGET_APP_NAME}" ]; then
            echo "Existing ${TARGET_APP_NAME} found at ${HOME}/Applications/${TARGET_APP_NAME}"
            echo "Should I replace it or change app name? [y/c/n]"
            read -n 1 replace_answer
            if [ "${replace_answer}" == 'y' ] || [ "${replace_answer}" == 'Y' ]; then
                rm -rf "${HOME}/Applications/${TARGET_APP_NAME}"
            else
                exit 0
            fi
        fi

        cp -r "./target/${TARGET_APP_NAME}" "${HOME}/Applications/"
        echo "Successfully installed ${TARGET_APP_NAME} in ${HOME}/Applications/"
    fi
fi

exit 0
