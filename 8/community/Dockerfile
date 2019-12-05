FROM openjdk:11-jre-slim

RUN apt-get update \
    && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get update \
    && apt-get install -y sudo \
    && sudo apt install -y cifs-utils

# Http port
EXPOSE 9000
RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

#Déclarer le fileshare dans AzureFile

ENV mntPath="/mnt/totalhp2welrs/sonarqube"

ARG SONARQUBE_VERSION=8.0
ARG SONARQUBE_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
ENV SONAR_VERSION=${SONARQUBE_VERSION} \
    SONARQUBE_HOME="$mntPath/opt/sq" \
    SONARQUBE_PUBLIC_HOME="$mntPath/opt/sonarqube" \
    SONARQUBE_OPT="$mntPath/opt/"

    
SHELL ["/bin/bash", "-c"]

#installer package docker
RUN sudo apt-get update \
    && apt-get install \
    && apt-transport-https \
    && ca-certificates \
    && curl \
    && gnupg-agent \
    && software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
 RUN sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
 RUN sudo apt-get update \
     && apt-get install docker-ce docker-ce-cli containerd.io
     
#Mount Azurefile
ENV resourceGroupName="RG-TOTAL-HP2-WE-SONARQUBE" \
    storageAccountName="totalhp2welrs" \
    fileShareName="sonarqube" \
    mntPath="/mnt/totalhp2welrs/sonarqube"

RUN sudo mkdir -p $mntPath \
    && sudo mkdir /etc/smbcredentials \
    && sudo bash -c 'echo "username=totalhp2welrs" >> /etc/smbcredentials/totalhp2welrs.cred' \
    && sudo bash -c 'echo "password=C0xP848pOZVZAZ1dUqMfe8kir4W/IQl2IDL3LgWFUKlk7K/bvMNlKKoC4O7ZhNEdt5GwvpXoOZFSr6wV6Uiu+w==" >> /etc/smbcredentials/totalhp2welrs.cred' \
    && sudo chmod 600 /etc/smbcredentials/totalhp2welrs.cred \
    && sudo bash -c 'echo "//totalhp2welrs.file.core.windows.net/sonarqube /mnt/totalhp2welrs cifs nofail,vers=3.0,credentials=/etc/smbcredentials/totalhp2welrs.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab' \
    && sudo mount -t cifs //totalhp2welrs.file.core.windows.net/sonarqube /mnt/totalhp2welrs -o vers=3.0,credentials=/etc/smbcredentials/totalhp2welrs.cred,dir_mode=0777,file_mode=0777,serverino

#############
RUN sed -i -e "s?securerandom.source=file:/dev/random?securerandom.source=file:/dev/urandom?g" \
  "$JAVA_HOME/conf/security/java.security"

RUN set -x \
    && cd "$SONARQUBE_OPT" \
# download and unzip SQ
    && curl -o sonarqube.zip -fsSL "$SONARQUBE_ZIP_URL" \
    && rm -Rf "${SONARQUBE_ZIP_DIR}" \
    && unzip -q sonarqube.zip \
    && mv "sonarqube-${SONARQUBE_VERSION}" sq \
    && rm sonarqube.zip* \
# empty bin directory from useless scripts
# create copies or delete directories allowed to be mounted as volumes, original directories will be recreated below as symlinks
    && rm --recursive --force "$SONARQUBE_HOME/bin"/* \
    && mv "$SONARQUBE_HOME/conf" "$SONARQUBE_HOME/conf_save" \
    && mv "$SONARQUBE_HOME/extensions" "$SONARQUBE_HOME/extensions_save" \
    && rm --recursive --force "$SONARQUBE_HOME/logs" \
    && rm --recursive --force "$SONARQUBE_HOME/data" \

# create directories to be declared as volumes
# copy into them to ensure they are initialized by 'docker run' when new volume is created
# 'docker run' initialization will not work if volume is bound to the host's filesystem or when volume already exists
# initialization is implemented in 'run.sh' for these cases
    && mkdir --parents "$SONARQUBE_PUBLIC_HOME/conf" \
    && mkdir --parents "$SONARQUBE_PUBLIC_HOME/extensions" \
    && mkdir --parents "$SONARQUBE_PUBLIC_HOME/logs" \
    && mkdir --parents "$SONARQUBE_PUBLIC_HOME/data" \
    && cp --recursive "$SONARQUBE_HOME/conf_save"/* "$SONARQUBE_PUBLIC_HOME/conf/" \
    && cp --recursive "$SONARQUBE_HOME/extensions_save"/* "$SONARQUBE_PUBLIC_HOME/extensions/" \
# create symlinks to volume directories
    && ln -s "$SONARQUBE_PUBLIC_HOME/conf" "$SONARQUBE_HOME/conf" \
    && ln -s "$SONARQUBE_PUBLIC_HOME/extensions" "$SONARQUBE_HOME/extensions" \
    && ln -s "$SONARQUBE_PUBLIC_HOME/logs" "$SONARQUBE_HOME/logs" \
    && ln -s "$SONARQUBE_PUBLIC_HOME/data" "$SONARQUBE_HOME/data" \
    && chown --recursive sonarqube:sonarqube "$SONARQUBE_HOME" "$SONARQUBE_PUBLIC_HOME" 

COPY --chown=sonarqube:sonarqube run.sh "$SONARQUBE_HOME/bin/"
USER sonarqube
WORKDIR $SONARQUBE_HOME

ENTRYPOINT ["./bin/run.sh"]
