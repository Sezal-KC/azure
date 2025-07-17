#!/bin/bash

FLASK_REPO=sezal33/todo-flask
FLASK_FILE=Dockerfile.flask

DB_REPO=sezal33/todo-db
DB_FILE=Dockerfile.db

FLASK_NAME=flask
DB_NAME=db

NETWORK=todo_network

echo "Building Backend Docker Image"
docker build -f $FLASK_FILE -t $FLASK_REPO .
echo "Building Database Docker Image"
docker build -f $DB_FILE -t $DB_REPO .

echo "Pushing Backend Docker Image"
docker push $FLASK_REPO
echo "Pushing Database Docker Image"
docker push $DB_REPO

echo "Removing all resources"
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
docker network prune -f
docker builder prune -a -f
echo "Creating docker network '$NETWORK'"
docker network create $NETWORK

echo "Running '$DB_NAME'"
docker run --name $DB_NAME -e MYSQL_ROOT_PASSWORD=password -v db_data:/var/lib/mysql --network $NETWORK -d $DB_REPO
echo "Running '$FLASK_NAME'"
docker run --name $FLASK_NAME -p 5000:5000 --network $NETWORK -d $FLASK_REPO
