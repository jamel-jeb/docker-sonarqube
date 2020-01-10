FROM sonarqube:7.9-community

ENV SONAR_VERSION=7.9.2 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonarwapp@sonarqubehp2db \
    SONARQUBE_JDBC_PASSWORD=Sonar2019 \
    SONARQUBE_JDBC_URL=jdbc:postgresql://sonarqubehp2db.postgres.database.azure.com:5432/sonarwapp

USER root    
RUN apt-get update && apt-get -y install procps && apt-get install -y sudo
#RUN sudo sysctl -q -w vm.max_map_count=262144
#RUN echo "vm.max_map_count=262144" >> /etc/sysctl.conf
#RUN sudo sysctl -p


USER sonarqube
ENTRYPOINT ["./bin/run.sh"]
