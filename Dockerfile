# Stage 1: Build
FROM ubuntu:latest AS build

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven

# Variável para o diretório do aplicativo dentro do contêiner docker
ARG APP_DIR=/app

# Definir o diretório de trabalho
WORKDIR $APP_DIR

COPY . .

RUN mvn clean

RUN mvn install

# Stage 2: Runtime
FROM openjdk:17

# Definir o diretório de trabalho
WORKDIR $APP_DIR

EXPOSE 8080

COPY --from=build /app/target/auth-0.0.1-SNAPSHOT.jar auth.jar

# Comando para executar a aplicação
ENTRYPOINT ["java","-jar","auth.jar"]