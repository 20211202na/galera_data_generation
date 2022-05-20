#!/bin/bash

for ((j=0;j<300;j++));do
{
    python maria.py -f ${j}
    wait
    python init.py 155.98.36.56
}
done
