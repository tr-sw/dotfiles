MAKEFLAGS += --warn-undefined-variables
SHELL := bash

# 
# shell flags:
#    -e exit immediately if fail
#    -u exit with error if access undefined variable
#    -c default value for shellflags, must preserve it
#    -o pipleline if any fail, all fail with rc from last command
.SHELLFLAGS := -eu +x -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

DIR := $(patsubs %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

# Required environment variables
# ifeq ($(ABC),)
#$(error ABC not set)
# endif

help:
	@echo 
	@echo "  Run make with following targets:" 
	@echo "    > all               ... builds all" 
	@echo "    > clean             ... cleanup for new build" 
	@echo "    > check-system      ... checks system requirements" 
	@echo 

#
# Put targets and recipes here
#
 
all:
	@echo 
	@echo "==> Building all" 
	@echo 


check-system:
	@echo 
	@echo "==> Checking system requirements" 
	@echo 


clean:
	@echo 
	@echo "==> Cleaning up" 
	@echo 
