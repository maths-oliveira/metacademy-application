# Use an official Python 2.7 base image
FROM python:2.7

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    APP_HOME=/app/metacademy-application

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    gnupg2 \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Set the working directory
WORKDIR $APP_HOME

# Copy application files into the container
COPY . .

# Create a virtual environment and install dependencies
RUN pip install --upgrade pip \
    && pip install virtualenv \
    && virtualenv meta_venv \
    && meta_venv/bin/pip install -r requirements.txt

#RUN make



#RUN make test

# Expose the application port
EXPOSE 8080

# Start the application using the virtual environment
#CMD ["tail", "-f", "/dev/null"]
CMD ["bash", "-c", " source meta_venv/bin/activate && make && python server/manage.py loaddata dev_utils/graph_data.json && python server/manage.py runserver 0.0.0.0:8080"]
