# Start with an official Python 3.9 base image
FROM python:3.9

# Set an environment variable to store the directory where our application will live inside the container
ENV APP_HOME /app

COPY shortjokes.csv APP_HOME/app/shortjokes.csv

# Set the working directory to our application home directory
WORKDIR $APP_HOME

# Install system dependencies required for runtime
# This includes curl and unzip for the AWS CLI installation, and git
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the AWS CLI
# Note: Adjust the command below if you're targeting a different architecture or AWS CLI version
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip ./aws

# Copy the local requirements file to the container
COPY requirements.txt .

# Install any Python packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code to the container
COPY . .

# Expose port 80 to allow communication to/from the server
EXPOSE 80

# The command to run our application
CMD ["python", "app.py"]

# Run uvicorn when the container launches
CMD ["uvicorn", "api_service:app", "--host", "0.0.0.0", "--port", "80"]