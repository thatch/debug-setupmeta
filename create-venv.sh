#!/bin/bash

SETUPTOOLS_VERSION=${1:-68.2.2}
SETUPMETA_SRC=~/github/setupmeta  # Point to checkout of setupmeta
PYTHON=python3.10  # Point to your python installation
VENV=venv-$SETUPTOOLS_VERSION
OUTCOME=outcome-$SETUPTOOLS_VERSION

set -ex

if [[ ! -d $VENV ]]; then
    $PYTHON -m venv $VENV
    $VENV/bin/pip install -U pip wheel setuptools==$SETUPTOOLS_VERSION
    $VENV/bin/pip install -e $SETUPMETA_SRC
fi

rm -rf $OUTCOME
mkdir -p $OUTCOME/dist_info
$VENV/bin/python setup.py dist_info -e $OUTCOME/dist_info
# If successful, *.dist-info/METADATA will have the line "Dist-Requires: thx"
grep Requires-Dist: $OUTCOME/dist_info/foo-0.0.0.dist-info/METADATA

$VENV/bin/pip -vvv wheel --no-deps -w $OUTCOME/wheel .
pushd $OUTCOME/wheel
unzip foo-0.0.0-py3-none-any.whl
grep Requires-Dist: foo-0.0.0.dist-info/METADATA
popd
