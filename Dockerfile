# ---------- Build Stage ----------
FROM --platform=$BUILDPLATFORM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /usr/src/app

COPY pom.xml .



COPY src ./src
RUN mvn -B clean package -DskipTests


# ---------- Runtime Stage ----------
FROM tomcat:9.0.85-jdk17-temurin

LABEL maintainer="opstree <opstree@gmail.com>"
LABEL app="spring3-hibernate"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /usr/src/app/target/*.war \
  /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
