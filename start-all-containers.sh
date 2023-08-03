#!/bin/bash

for folder in argos-setting-containers/*;
do
	(
		cd $folder
		../../start-argos-container.sh -f $folder -d bams-aws.refinitiv.com -t argos-adf -m 16g -c 0.00
		sleep 600s
	)
done
