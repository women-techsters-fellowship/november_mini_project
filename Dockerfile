FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libz-dev \
    libjpeg-dev \
    libpng-dev && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install --default-timeout=100 --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose Django default port
EXPOSE 8000

# Run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . .

# Run in production mode
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]


