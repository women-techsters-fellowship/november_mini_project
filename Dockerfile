FROM python:3.11-slim

#Install system dependencies needed by pillow
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*


# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip3 install --default-timeout=100 --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose Django default port
EXPOSE 8000

# Run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

