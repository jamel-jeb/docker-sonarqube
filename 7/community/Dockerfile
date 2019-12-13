FROM sonarqube:7.9-community

ENV SONAR_VERSION=7.9.1 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonarwapp@sonarqubehp2db \
    SONARQUBE_JDBC_PASSWORD=Sonar2019 \
    SONARQUBE_JDBC_URL=jdbc:postgresql://sonarqubehp2db.postgres.database.azure.com:5432/sonarwapp


ENTRYPOINT ["./bin/run.sh"]
