#!/bin/bash

# Path to your .env file
ENV_FILE=".env"

# Load environment variables from .env file if it exists
if [ -f "$ENV_FILE" ]; then
    export $(cat $ENV_FILE | sed 's/#.*//g' | xargs)
fi

# Check Docker and Docker Compose dependency
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose could not be found. Please install Docker and Docker Compose to continue."
    exit 1
fi

echo "Ensuring Docker daemon is running..."
if ! docker info > /dev/null 2>&1; then
    echo "Docker daemon is not running. Please start Docker to continue."
    exit 1
fi

# Using Docker Compose to build and start the services, including data ingestion as part of the process
echo "Starting services with Docker Compose..."
docker-compose up -d --build || { echo "Failed to start services with Docker Compose"; exit 1; }

echo "Services started with Docker Compose successfully."