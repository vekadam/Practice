FROM ubuntu:latest 

#set the working directory 
WORKDIR /app

#copy the files from host fs to the image fs
COPY . /app

#install necessary packages
RUN apt-get update && apt-get install -y python3 python3-pip 

#set environment variables 
ENV NAME World 

#run a command to start the application 
CMD ["python3", "app.py"]