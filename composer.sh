#!/usr/bin/env bash
#供Cygwin调用，以防止无限循环调用composer劫持函数本身！
SCRIPTDIR=$(dirname "$0")

# Run truely composer commands...
$SCRIPTDIR/composer $@