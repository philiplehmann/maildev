#
# maildev Dockerfile
#

FROM node:20.7.0

WORKDIR /home/maildev

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn install

RUN useradd -ms /bin/bash maildev

USER maildev

# Expose the SMTP and HTTP ports:
EXPOSE 1025 1080

ENTRYPOINT ["yarn", "maildev"]
