# Installation
This was done on a clean Ubuntu 20.4 server.

## Node JS LTS
```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g npm
```
## Tomcat
```bash
sudo apt install tomcat9
```
## PostgreSQL
```bash
sudo apt install postgresql
```
## HAPI FHIR
### Create Database and User
```bash
sudo -u postgres psql
create database hapi;
create user hapi with encrypted password 'PASS';
grant all privileges on database hapi to hapi;
\q
```
### Install Maven
```bash
sudo apt install maven
```
### Compile HAPI
```bash
git clone https://github.com/hapifhir/hapi-fhir-jpaserver-starter.git
cd hapi-fhir-jpaserver-starter
```
Edit ```pom.xml``` and change the following line from hapi-fhir-jpaserver:
```xml
    <finalName>hapi</finalName>
```
Edit ```src/main/resources/hapi.properties``` and set the following:
```
server_address=http://localhost:8080/hapi/fhir/

datasource.driver=org.postgresql.Driver
datasource.url=jdbc:postgresql://localhost:5432/hapi
datasource.username=hapi
datasource.password=PASS

hibernate.dialect=org.hibernate.dialect.PostgreSQL95Dialect

hibernate.search.default.indexBase=/var/lib/tomcat9/webapps/hapi/target/lucenefiles
```
Create war file
```bash
mvn clean install -DskipTests
sudo mkdir /var/lib/tomcat9/target
sudo chown tomcat:tomcat /var/lib/tomcat9/target
sudo cp target/hapi.war /var/lib/tomcat9/webapps
```