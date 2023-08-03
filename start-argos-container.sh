#!/bin/bash

usage()
{
    echo "Usage: -f <folder> -d <domain> -t <tag> -m <memory> -c <cpus>"
    echo -e "\t-f or --folder (required)"
    echo -e "\t\tfolder help"
    echo -e "\t-d or --domain (required)"
    echo -e "\t\tSpecify a domain name you'd like to access container"
    echo -e "\t-t or --tag (required)"
    echo -e "\t\tSpecify a version of an image you'd like to run the container with"
    echo -e "\t-m or --memory"
    echo -e "\t\tMemory limit (format: <number>[<unit>]). Number is a positive integer. Unit can be one of b, k, m, or g."
    echo -e "\t-c or --cpus"
    echo -e "\t\tNumber of CPUs. Number is a frational number. 0.000 means no limit."
}

position=()
host_hostname=$(hostname)
host_host_ip=$(hostname -I | sed "s/ *$//" | sed -e "s/ /, /g")
memory="2g"
cpus="2"

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -f | --folder )
            folder="$2"
            shift
            shift
            ;;
        -d | --domain )
            domain="$2"
            shift
            shift
            ;;
        -t | --tag )
            tag="$2"
            shift
            shift
            ;;
        -m | --memory )
            memory="$2"
            shift
            shift
            ;;
        -c | --cpus )
            cpus="$2"
            shift
            shift
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            position+=("$1")
            shift
            ;;
    esac
done
set -- "${position[@]}"

if [ "${domain}" != "" ] && [ "${tag}" != "" ]
then
    echo "DOMAIN  : ${domain}"
    echo "TAG     : ${tag}"
    echo "MEMORY  : ${memory}"
    echo "CPUS    : ${cpus}"
else
    echo "[ERROR]: no required arguments(s) provided."
    exit 1
fi

if [ "${folder}" != "" ]
then
    if [ ! -d "${PWD}/resources" ]
    then
        echo "[ERROR]: resources folder not found"
        exit 1
    else
        echo "VOLUME  : ${PWD}/resources:/argos/resources"
        docker run -d -e "HOST_HOSTNAME=${host_hostname}" -e "HOST_HOST_IP=${host_host_ip}" -e "DOCKER_NAME=$(basename ${PWD})" --name $(basename ${folder}) --memory-swap -1 --memory ${memory} --cpus "${cpus}" --restart always -v "${PWD}/resources:/argos/resources" ${domain}:5001/tsbkk-innovation/argos/argos-deploy:${tag}
    fi
else
    if [ ! -d "${folder}/resources" ]
    then
        echo "[ERROR]: resources folder not found"
        exit 1
    else
        echo "VOLUME  : ${folder}/resources:/argos/resources"
        docker run -d -e "HOST_HOSTNAME=${host_hostname}" -e "HOST_HOST_IP=${host_host_ip}" -e "DOCKER_NAME=$(basename ${folder})" --name $(basename ${folder}) --memory-swap -1 --memory ${memory} --cpus "${cpus}" --restart always -v "${folder}/resources:/argos/resources" ${domain}:5001/tsbkk-innovation/argos/argos-deploy:${tag}
    fi
fi
