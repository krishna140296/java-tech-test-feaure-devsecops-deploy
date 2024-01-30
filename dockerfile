# Use the official Amazon Corretto 17 base image
FROM amazoncorretto:17-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file
COPY target/*.jar app.jar

# Expose the port that the application will run on
EXPOSE 8080

# Start the application using java -jar
CMD ["java", "-jar", "app.jar"]

