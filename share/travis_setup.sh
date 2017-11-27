#!/bin/bash
set -evx

mkdir ~/.innovacore

# safety check
if [ ! -f ~/.innovacore/.innova.conf ]; then
  cp share/innova.conf.example ~/.innovacore/innova.conf
fi
