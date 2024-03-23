#!/bin/bash

# Path to your .env file
ENV_FILE=".env"

# Load environment variables from .env file if it exists
if [ -f "$ENV_FILE" ]; then
    export $(cat $ENV_FILE | sed 's/#.*//g' | xargs)
fi

# Function to prompt for a variable if it's not set in the environment
prompt_for_variable() {
  local var_name=$1
  local current_value=$(eval echo \$$var_name)

  if [[ -z "$current_value" ]]; then
    read -p "Please enter value for $var_name: " input_value
    export $var_name="$input_value"
  fi
}

# Define required variables
required_variables=("APP_NAME" "PORT" "DB_NAME" "DB_USER" "DB_PASS" "NETWORK_NAME")

# Check and prompt for each required variable
for var in "${required_variables[@]}"; do
  prompt_for_variable $var
done

# Check Docker dependency
if ! command -v docker &> /dev/null; then
    echo "Docker could not be found. Please install Docker to continue."
    exit 1
fi

echo "Ensuring Docker daemon is running..."
if ! docker info > /dev/null 2>&1; then
    echo "Docker daemon is not running. Please start Docker to continue."
    exit 1
fi

# Build the Docker image
echo "Building Docker image for $APP_NAME..."
docker build -t $APP_NAME . || { echo "Docker build failed"; exit 1; }

echo "Pulling PostgreSQL image..."
docker pull postgres || { echo "Failed to pull PostgreSQL image"; exit 1; }

# Create network if it doesn't exist
if ! docker network ls | grep -qw $NETWORK_NAME; then
    echo "Creating Docker network: $NETWORK_NAME..."
    docker network create $NETWORK_NAME || { echo "Failed to create Docker network"; exit 1; }
fi

# Run PostgreSQL container if it doesn't exist
if ! docker ps -a --format "{{.Names}}" | grep -qw postgres-container; then
    echo "Running PostgreSQL container..."
    docker run -d \
      --name postgres-container \
      --network $NETWORK_NAME \
      -e POSTGRES_DB=$DB_NAME \
      -e POSTGRES_USER=$DB_USER \
      -e POSTGRES_PASSWORD=$DB_PASS \
      -p 5432:5432 \
      postgres || { echo "Failed to run PostgreSQL container"; exit 1; }
fi

# Check if a container with the same name is already running and remove it
if docker ps --filter "name=$APP_NAME" --format "{{.Names}}" | grep -qw $APP_NAME; then
    echo "Stopping and removing the existing $APP_NAME container..."
    docker stop $APP_NAME
    docker rm $APP_NAME
fi

# Run the Docker container with environment variables
echo "Running Docker container for $APP_NAME..."
docker run -dp $PORT:$PORT \
-e APP_NAME=$APP_NAME \
-e PORT=$PORT \
-e DB_NAME=$DB_NAME \
-e DB_USER=$DB_USER \
-e DB_PASS=$DB_PASS \
-e DB_HOST=$DB_HOST \
-e NETWORK_NAME=$NETWORK_NAME \
--name $APP_NAME \
--network $NETWORK_NAME \
$APP_NAME || { echo "Failed to run $APP_NAME container"; exit 1; }

echo "Connecting $APP_NAME container to $NETWORK_NAME network..."
docker network connect $NETWORK_NAME $APP_NAME || { echo "Failed to connect $APP_NAME container to $NETWORK_NAME network"; exit 1; }

echo "Deployment completed successfully."
