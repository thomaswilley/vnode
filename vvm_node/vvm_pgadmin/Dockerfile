FROM python:3.5

MAINTAINER Thomas Willey <test@test.test>

ARG VVM_USER
ARG VVM_HOME_PATH

ENV NB_USER $VVM_USER
ENV NB_UID 1000
ENV APP_INSTALLLOC '/vvm_pgadmin_install'
ENV PGADMIN4_PKG_DIR /usr/local/lib/python3.5/site-packages/pgadmin4/

USER root

# Create vivitics user with UID=1000 and in the 'users' group
# and give +rw perms to notebook user/author
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
      mkdir -p $APP_INSTALLLOC && \
      chown -R $NB_USER $APP_INSTALLLOC && \
      mkdir -p /var/log/pgadmin4 && \
      mkdir -p /var/lib/pgadmin4 && \
      chown -R $NB_USER /var/log/pgadmin4 && \
      chown -R $NB_USER /var/lib/pgadmin4 && \
      apt-get update -y && apt-get install vim -y

# install pgadmin4 v1.3
ADD https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v1.3/pip/pgadmin4-1.3-py2.py3-none-any.whl $APP_INSTALLLOC
RUN cd $APP_INSTALLLOC && \
      pip install pgadmin4-1.3-py2.py3-none-any.whl

# bring in settings
COPY config_local.py $PGADMIN4_PKG_DIR

# patch
# set app root to /pg/
#RUN sed -i "s#baseUrl: ''#baseUrl: '/pg/'#" /usr/local/lib/python3.5/site-packages/pgadmin4/pgadmin/templates/base.html
#RUN awk -v n=$(grep -n 'app = create_app()' $PGADMIN4_PKG_DIR/pgAdmin4.py | cut -f1 -d:) \
#        -v s="app.config[\"APPLICATION_ROOT\"] = \"/pg/\"" \
#        'NR == n+1 {print s} {print}' $PGADMIN4_PKG_DIR/pgAdmin4.py > $PGADMIN4_PKG_DIR/pgAdmin4.py.modified && \
#    mv $PGADMIN4_PKG_DIR/pgAdmin4.py.modified $PGADMIN4_PKG_DIR/pgAdmin4.py

EXPOSE 5051

# prepare for run
#USER $NB_USER
CMD ["python", "/usr/local/lib/python3.5/site-packages/pgadmin4/pgAdmin4.py"]
