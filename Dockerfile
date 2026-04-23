# ─────────────────────────────────────────────
# Stage 1: Build the WAR with Maven
# ─────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copy POM first so dependency layer is cached
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -q

# ─────────────────────────────────────────────
# Stage 2: Run on Tomcat 10 (Jakarta EE)
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk21

# Remove the default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Deploy our WAR as ROOT so it serves from "/"
COPY --from=build /app/target/timetable-generator.war \
                  /usr/local/tomcat/webapps/ROOT.war

# Render assigns the port via $PORT env var; default Tomcat listens on 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
