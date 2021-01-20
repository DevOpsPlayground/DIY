#!/bin/bash 

for f in $(find ../ -name '*.tf' ); do terraform-docs markdown . ; done