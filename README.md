# Project: Joke Collector

## Overview
This project consists of a multi-container Docker application designed to import jokes from a CSV file into a PostgreSQL database and make them accessible for future retrieval and analysis. The ultimate goal is to leverage this data to develop a Machine Learning model, expose it through FastAPI, and deploy it on AWS for broader accessibility.

## Architecture
- **Container 1**: A PostgreSQL database container for storing jokes.
- **Container 2**: A Python application container that reads jokes from a CSV file and imports them into the PostgreSQL database. This container is also responsible for retrieving jokes from the database.

## Components
- **Dockerfile**: Defines the Python application container, including the environment setup and the application's dependencies.
- **Bash Script**: Automates the setup process, including environment variable configuration, Docker network creation, and container deployment.
- **App**: A Python script that handles CSV file processing, database operations, and joke retrieval.

## Future Goals
- Develop a Machine Learning model to analyze and categorize jokes.
- Implement FastAPI to provide an HTTP interface for accessing and interacting with the jokes.
- Deploy the entire system on AWS for scalability and public access.

## Requirements
- Docker
- PostgreSQL
- Python 3.9

## Setup Instructions

### Environment Setup
1. Ensure Docker is installed and running on your machine.
2. Clone this repository to your local machine.
3. Navigate to the project directory in your terminal.

### Configuration
1. Create a `.env` file in the project root with the following variables:

```.env
APP_NAME=<your_app_name>
PORT=<your_app_port>
DB_NAME=<your_db_name>
DB_USER=<your_db_user>
DB_PASS=<your_db_password>
NETWORK_NAME=<your_network_name>
DB_HOST=postgres-container
```

### Building and Running

Execute the provided bash script to automate the building and deployment of your Docker containers:

```bash
./setup_environment.sh
```

## Usage

Once the application is running, it will automatically import jokes from the `shortjokes.csv` into the PostgreSQL database. You can then connect to the database to query the jokes or wait for future updates when an API will be provided for easier access.

## Future API Documentation

Stay tuned for updates on the API documentation, which will detail how to interact with the joke database through FastAPI endpoints.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please open an issue or pull request.

## License

Specify your project's license here.