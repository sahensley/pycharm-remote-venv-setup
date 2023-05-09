#!/usr/bin/env bash

# Exit if there are any non-zero return codes
set -o errexit

SETTINGSFILEFULLPATH="${HOME}/.configure-remote-venv-settings"
# Load script settings
# shellcheck source=configure-remote-venv-settings
source "${SETTINGSFILEFULLPATH}"

# Print help if no args were passed
if [ -z "${1}" ] ; then
    "${PYTHONBIN}" -m "${VENVCMD}"
    exit ${?}
# Print help if --help or -h were passed
elif [ -n "${1}" ] && { [ "${1}" = "--help" ] || [ "${1}" = "-h" ]; } ; then
    "${PYTHONBIN}" -m "${VENVCMD}" "${1}"
    exit ${?}
else
    VENVNAME="${1}" # Save venv name for variable clarity
    VENVARGS=("${@:2}") # Get all arguments other than script and venv names
fi

# Create directories or exit on error
mkdir -pv "${PROJECTSDIR}" || \
    { echo "Failed creating ${PROJECTSDIR}" && exit ${?}; }
mkdir -pv "${VENVSDIR}" || \
    { echo "Failed creating ${VENVSDIR}" && exit ${?}; }
mkdir -pv "${LOCALBINDIR}" || \
    { echo "Failed creating ${LOCALBINDIR}" && exit ${?}; }

# Create venv
"${PYTHONBIN}" -m "${VENVCMD}" "${VENVSDIR}/${VENVNAME}" "${VENVARGS[@]}" || \
    { echo "Failed creating ${VENVSDIR}/${VENVNAME}" && exit ${?}; }
echo "Created virtual environment at ${VENVSDIR}/${VENVNAME}"

# Create project directory
mkdir -p "${PROJECTSDIR}/${VENVNAME}" || \
    { echo "Failed creating ${PROJECTSDIR}/${VENVNAME}" && exit ${?}; }
echo "Created project directory at ${PROJECTSDIR}/${VENVNAME}"
