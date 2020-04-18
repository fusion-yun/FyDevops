#!/usr/bin/bash

if [ -z "$SSH_AUTH_SOCK" ]
then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]
   then
        # Launch a new instance of the agent
        ssh-agent -s &> .ssh/ssh-agent
   fi
   eval `cat .ssh/ssh-agent`
fi


OS=centos
OS_VERSION=8
OS_TAG=${OS}${OS_VERSION}

mkdir -p ../build_${OS_TAG}

START_TIME=$(date)
echo "======= Build FyBox ${START_TIME}============ "  > /tmp/build_${OS_TAG}.log 2>&1     

# --ssh=default

docker build  --rm \
     -f "dockerfiles/fyos.${OS}.dockerfile" \
     --build-arg OS_VERSION=${OS_VERSION} \
     -t fyos:${OS_TAG} \
     ../build_${OS_TAG} \
      >> /tmp/build_${OS_TAG}.log 2>&1  


docker build  --rm \
     -f "dockerfiles/fybase.dockerfile" \
     --build-arg OS_TAG=${OS_TAG}  \
     -t fybase:${OS_TAG}  \
     ../build_${OS_TAG} \
     >> /tmp/build_${OS_TAG}.log 2>&1  

docker build --progress=plain  --rm \
     -f "dockerfiles/fypkgs.dockerfile" \
     --build-arg OS_TAG=${OS_TAG}  \
     -t fypkgs:${OS_TAG}  \
     ../build_${OS_TAG} \
     >> /tmp/build_${OS_TAG}.log 2>&1     



END_TIME=$(date)
echo "======= Build FyBox ${END_TIME}============ \n" >> /tmp/build_${OS_TAG}.log 2>&1    