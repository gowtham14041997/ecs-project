FROM maven:3.8.2-jdk-11 AS build
WORKDIR /opstreeApp
COPY . .
RUN mvn clean package

FROM tomcat:8.5.47-jdk8-openjdk
COPY --from=build /opstreeApp/target/Spring3HibernateApp.war /usr/local/tomcat/webapps

