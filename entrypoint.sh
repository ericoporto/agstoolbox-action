#!/bin/bash

# Fail on errors.
set -e

# Make sure .bashrc is sourced
. /root/.bashrc

# Allow the workdir to be set using an env var.
# Useful for CI pipiles which use docker for their build steps
# and don't allow that much flexibility to mount volumes
SRCDIR=$1

# NOTE: when things are more stable, perhaps we could pull it from pip?
# python -m pip install --upgrade pip wheel setuptools

wget -nv https://github.com/ericoporto/agstoolbox/releases/download/0.3.10/atbx.exe
mkdir /wine/drive_c/agstoolbox/
mkdir /wine/drive_c/editors/
mv atbx.exe /wine/drive_c/agstoolbox/
echo 'wine '\''C:\agstoolbox\atbx.exe'\'' "$@"' > /usr/bin/atbx
chmod +x /wine/drive_c/agstoolbox/atbx.exe
chmod +x /usr/bin/atbx 

if [ -f ${SRCDIR} ]; then
  cd ${SRCDIR}
fi

atbx settings set tools_install_dir C:\\editors
atbx settings show tools_install_dir
atbx install editor . -q -f
atbx list editors
atbx list projects
atbx build .

find . -type f -name "*.exe"
