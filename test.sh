#!/bin/bash

SHELL=$1
IMAGE_NAME="ubuntu-test-${SHELL}"
CONTAINER_NAME="${IMAGE_NAME}"

ln -s ${PROMPT_DIR}/test/${SHELL}/Dockerfile ${PROMPT_DIR}
docker build --tag ${IMAGE_NAME} .
rm Dockerfile

case ${SHELL} in
    bash)
        echo -e "${E_INFO}[INFO] Running container${E_NORMAL}"
        docker run \
            -it \
            --name ${CONTAINER_NAME} \
            --hostname ${CONTAINER_NAME} ${IMAGE_NAME} \
            '/bin/bash'
        ;;
    zsh)
        echo -e "${E_INFO}[INFO] Running container${E_NORMAL}"
        docker run \
            -it \
            --name ${CONTAINER_NAME} \
            --hostname ${CONTAINER_NAME} ${IMAGE_NAME} \
            '/bin/zsh'
        ;;
esac

echo -e "${E_INFO}[INFO] Remove container ${CONTAINER_NAME}${E_NORMAL}"
docker rm ${CONTAINER_NAME}

echo -e "${E_INFO}[INFO] Remove image ${IMAGE_NAME}${E_NORMAL}"
docker rmi ${IMAGE_NAME}
