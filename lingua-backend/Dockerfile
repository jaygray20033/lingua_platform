FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build

COPY pom.xml ./
RUN mvn -B -q dependency:go-offline -DskipTests || true

COPY src ./src
RUN mvn -B -q package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/target/quarkus-app/lib/      /app/lib/
COPY --from=builder /build/target/quarkus-app/*.jar     /app/
COPY --from=builder /build/target/quarkus-app/app/      /app/app/
COPY --from=builder /build/target/quarkus-app/quarkus/  /app/quarkus/

ENV JWT_PRIVATE_KEY_LOCATION=/app/secrets/privateKey.pem
ENV HTTP_PORT=8080

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=5s --start-period=60s --retries=10 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/api/health || exit 1

ENTRYPOINT ["java", "-jar", "/app/quarkus-run.jar"]
