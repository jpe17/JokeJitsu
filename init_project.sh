#!/bin/bash
# init_project.sh

PROJECT_NAME="JokeJitsu"
REPO_URL="https://github.com/jpe17/JokeJitsu"

mkdir $PROJECT_NAME && cd $PROJECT_NAME
git init
git remote add origin $REPO_URL

echo "$PROJECT_NAME initialized and connected to $REPO_URL"