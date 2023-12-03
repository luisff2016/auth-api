# Usar uma imagem base do Java 17
FROM openjdk:17-jdk-alpine

# Variável para o diretório do aplicativo dentro do contêiner docker
ARG APP_DIR=/usr/app/

# Variável para o arquivo jar
ARG JAR_FILE=target/auth-api-0.0.1-SNAPSHOT.jar

# Criar diretório do aplicativo dentro do contêiner
RUN mkdir -p $APP_DIR

# Definir o diretório de trabalho
WORKDIR $APP_DIR

# Adicionar o arquivo jar ao contêiner
ADD ${JAR_FILE} app.jar

# Comando para executar a aplicação
ENTRYPOINT ["java","-jar","/usr/app/app.jar"]
