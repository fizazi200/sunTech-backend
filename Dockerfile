FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copier le jar depuis l'étape build
COPY ./target/*.jar app.jar

# Exposer le port (par défaut Spring Boot)
EXPOSE 8080

# Commande de lancement
CMD ["java", "-jar", "app.jar"]