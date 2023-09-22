To repro the problem:

::

    python -m venv .venv
    source .venv/bin/activate
    pip install -U pip wheel setupmeta
    pip install -e /path/to/setuptools
    python setup.py dist_info

    # If successful, *.dist-info/requires.txt will exist and
    *.dist-info/METADATA will have the line "Dist-Requires: thx"

`/path/to/setuptools` is presumed to be a checkout of the setuptools repo, which
succeeds at `3c9d6ac96bb76670adc48535816fa3331b027c80^` and fails at
`3c9d6ac96bb76670adc48535816fa3331b027c80` itself (and several arbitrary commits
after, including today's main, `2255e6366c70b9813d115ae0a0bba329affbd0ac`

This does not appear to be limited to calling `setup.py` directly, and is
possible to trigger with `pip wheel` and others.  The `egg_info` contains
dependencies, but the `dist_info` does not.
