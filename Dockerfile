# syntax=docker/dockerfile:1

# Stage 1: Base
# Use uma imagem Alpine como base
FROM alpine:latest AS base

# Atualize os pacotes e instale o Java e o Maven
RUN apk --no-cache update && \
    apk --no-cache add openjdk17 maven
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN mvn -N io.takari:maven:wrapper
RUN ./mvnw dependency:resolve
COPY src ./src

# Stage 2: Development
FROM base as development
CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=postgres", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

# Stage 3: Build
#FROM base as build
#RUN ./mvnw package

# Stage 4: Production
FROM alpine:latest as production
EXPOSE 8080
COPY --from=build /app/target/auth-0.0.1-SNAPSHOT.jar /auth.jar
CMD ["java", "-Xshare:off", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/auth.jar"]


