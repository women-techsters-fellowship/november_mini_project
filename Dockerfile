# FROM python:3.11-slim

# # Set working directory
# WORKDIR /app

# # Copy requirements and install dependencies
# COPY requirements.txt .
# RUN pip3 install --default-timeout=100 --no-cache-dir -r requirements.txt

# # Copy the rest of the application
# COPY . .

# # Expose Django default port
# EXPOSE 8000

# # Run the application
# CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]


FROM python:3.11-slim

# Install system dependencies required for Pillow
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    tk-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose Django port
EXPOSE 8000

# Run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

