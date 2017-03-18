#!/bin/bash
# (c) Thomas Willey, 2017
# Most of the credit goes to: https://github.com/roninkenji/dropbox-docker
# after building, do a docker logs <containername> to get link to activate;
# activate by following link; docker logs <containername> to verify it worked!
# /dropbox now available

# evars or defaults
DROPBOX_USER=${DROPBOX_USER:=jovyan}
DROPBOX_USERID=${DROPBOX_USERID:=1000}
DROPBOX_GROUP=${DROPBOX_GROUP:=users}
DROPBOX_GROUPID=${DROPBOX_GROUPID:=100}

# create default groups
getent group ${DROPBOX_GROUP} 2>&1 > /dev/null || groupadd -g ${DROPBOX_GROUPID} ${DROPBOX_GROUP}
getent passwd ${DROPBOX_USER} 2>&1 > /dev/null && usermod -d /dropbox -s /bin/bash ${DROPBOX_USER}
getent passwd ${DROPBOX_USER} 2>&1 > /dev/null || useradd -d /dropbox -g ${DROPBOX_GROUP} -G users -u ${DROPBOX_USERID} -s /bin/bash ${DROPBOX_USER}

# correct some permissions
chown ${DROPBOX_USER}:${DROPBOX_GROUP} -R /dropbox /dropbox/.dropbox /dropbox/.dropbox-dist /dropbox/Dropbox

[ ! -f /dropbox/.dropbox-dist/dropboxd ] && su -l ${DROPBOX_USER} -c "cp -r /usr/local/.dropbox-dist /dropbox/."
[ $( cat /dropbox/.dropbox-dist/VERSION ) != $( sort -rV /dropbox/.dropbox-dist/VERSION /usr/local/.dropbox-dist/VERSION | head -n 1 ) ] && su -l ${DROPBOX_USER} -c "rm -fr /dropbox/.dropbox-dist/*; cp -r /usr/local/.dropbox-dist/* /dropbox/.dropbox-dist"

su -l ${DROPBOX_USER} -c "/dropbox/.dropbox-dist/dropboxd" &
while true; do sleep infinity; done
