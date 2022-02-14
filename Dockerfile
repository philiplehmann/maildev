#
# MailCatcher Dockerfile
#

FROM ruby:3.1-slim-bullseye

# Install MailHog:
RUN apt update \
  && apt install -y build-essential sqlite3 libsqlite3-dev \
  && gem install mailcatcher --no-document \
  && apt remove -y build-essential \
  && apt autoremove -y

RUN useradd -ms /bin/bash -u 1000 mailcatcher

WORKDIR /home/mailcatcher

USER mailcatcher

# Expose the SMTP and HTTP ports:
EXPOSE 1025 1080

ENTRYPOINT ["mailcatcher", "--foreground", "--verbose", "--ip=0.0.0.0"]
