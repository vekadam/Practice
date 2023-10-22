FROM adoptopenjdk/openjdk11:alpine-jre
ARG artifact=target/spring-boot-web.jar
WORKDIR /opt/app 
COPY ${ARG} app.jar
ENTRYPOINT ["java","-jar","app.jar"]


