# ---------- Build Stage ----------
FROM --platform=$BUILDPLATFORM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /usr/src/app

# Copy pom first for layer caching
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -B clean package -DskipTests


# ---------- Runtime Stage ----------
FROM tomcat:9.0.85-jdk17-temurin

LABEL maintainer="opstree <opstree@gmail.com>"
LABEL app="spring3-hibernate"

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY --from=builder /usr/src/app/target/*.war \
  /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
