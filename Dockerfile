# Use the official Node.js image as the base image
FROM node:22-bookworm-slim
# If you're using M1, M2 Mac, try this: 
# FROM  --platform=linux/amd64 node:22.2.0-alpine3.20

# Set the working directory
WORKDIR /usr/src/app

RUN apt-get update && apt-get upgrade -y && apt install -y git
RUN apt-get clean

ENV GIT_URL=
ENV BRANCH=main

RUN echo '#!/bin/bash \n\
set -e \n\
if [ ! -d "./$APP/.git" ]; then \n\
  git clone -b $BRANCH --single-branch $GIT_URL . \n\
else \n\
  git fetch origin; git reset --hard origin/$BRANCH; git clean -f -d; git pull; \n\
fi \n\
npm install ; npm start \n\
' > start.sh
RUN chmod +x start.sh

RUN cat start.sh 

# Expose the port
EXPOSE 3000

# Start the application
CMD [ "./start.sh" ]