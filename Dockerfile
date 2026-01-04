# ---- Build stage ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /workspace

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN ./mvnw -q -DskipTests dependency:go-offline

COPY src src
RUN ./mvnw -q -DskipTests package

# ---- Runtime stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app

ENV PORT=8080
EXPOSE 8080

RUN useradd -r -u 1001 quarkus
COPY --chown=1001:1001 --from=build /workspace/target/quarkus-app/ /app/
USER 1001

ENV JAVA_OPTS=""
CMD ["sh","-c","java $JAVA_OPTS -jar /app/quarkus-run.jar"]
