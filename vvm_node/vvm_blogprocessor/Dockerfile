FROM python:3.5

MAINTAINER Thomas Willey <test@test.test>

ARG VVM_USER
ARG VVM_HOME_PATH

ENV NB_USER $VVM_USER
ENV NB_UID 1000
ENV VVM_HOME $VVM_HOME_PATH
ENV VVM_HOME_BLOG $VVM_HOME_PATH/_Blog
ENV APP_INSTALLLOC /tmp/pelicanyan_stage

USER root

# Create vivitics user with UID=1000 and in the 'users' group
# and give +rw perms to notebook user/author
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
      mkdir -p $APP_INSTALLLOC && \
      chown -R $NB_USER $APP_INSTALLLOC

COPY start.sh $APP_INSTALLLOC
COPY pelicanconf.py $APP_INSTALLLOC
COPY sample-post.md $APP_INSTALLLOC

RUN pip3 install pelican markdown typogrify watchdog ghp-import

# Install pelicanyan theme
# NOTE: NOW DONE THROUGH START.SH BC REQUIRES MOUNTED VOLUME
#RUN cd $APP_INSTALLLOC && git clone https://github.com/thomaswilley/pelicanyan.git \
#    && cd pelicanyan/static/css/ \
#    && wget https://raw.githubusercontent.com/poole/lanyon/master/public/css/lanyon.css \
#    && wget https://raw.githubusercontent.com/poole/lanyon/master/public/css/poole.css \
#    && wget https://raw.githubusercontent.com/poole/lanyon/master/public/css/syntax.css \
#    && cd $APP_INSTALLLOC

RUN sed -i 's/\r//' $APP_INSTALLLOC/start.sh
RUN chmod +x $APP_INSTALLLOC/start.sh

USER root

WORKDIR $APP_INSTALLLOC
CMD $APP_INSTALLLOC/start.sh --use-sample-post

# Note: evar VVM_PUBLIC_PATH must be set as part of running start.sh!
