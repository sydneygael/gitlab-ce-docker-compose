#!/bin/env bash

# -u especially important: error if environment variable is unset.
set -eu

N_ATTEMPTS=0
# Initial start-up can take a while...
MAX_ATTEMPTS=60

sleep 45

# See also: https://stackoverflow.com/a/50583452/11477374
until $(curl --output /dev/null --silent --head --fail -L -H "Host: ${VIRTUAL_HOST}" ${VIRTUAL_HOST}); do
    if [ ${N_ATTEMPTS} -eq ${MAX_ATTEMPTS} ]
    then
      echo "Maximum number of attempts reached, exiting." >&2
      exit 1
    fi

    echo "Could not reach ${VIRTUAL_HOST}, trying again... (attempt number ${N_ATTEMPTS})"
    N_ATTEMPTS=$(( $N_ATTEMPTS + 1 ))
    sleep 5
done

echo "Reached ${VIRTUAL_HOST} after ${N_ATTEMPTS} tries, attempting to register runner."

gitlab-runner \
    register \
    --non-interactive \
    --url=http://${VIRTUAL_HOST} \
    --registration-token=${INITIAL_RUNNER_TOKEN} \
    --executor=docker \
    --docker-image=debian \
    --description=local

echo "Runner registration successful."
