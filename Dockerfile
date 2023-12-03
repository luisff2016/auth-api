# syntax=docker/dockerfile:1

# Stage 1: Base
# Use uma imagem Maven oficial com Alpine como base
FROM maven:3.9.5 AS base

WORKDIR /app
COPY . .

# Configurar o Maven wrapper
RUN mvn clean
RUN mvn package

COPY src ./src

# Estágio de desenvolvimento
FROM base as build
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.profiles=postgres", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

#Estágio de produção
FROM openjdk:17-jdk-slim
EXPOSE 8080
COPY --from=build /app/target/auth-0.0.1-SNAPSHOT.jar /auth.jar
CMD ["java", "-Xshare:off", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/auth.jar"]