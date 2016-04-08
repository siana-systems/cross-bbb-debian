#!/bin/bash

: ${BBB_IMAGE:=siana/cross-bbb-debian}

docker build -t $BBB_IMAGE .
