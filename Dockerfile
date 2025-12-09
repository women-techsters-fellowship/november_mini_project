
#BUILDER STAGE

FROM python:3.11-slim AS builder

# Install build dependencies required only for building wheels (Pillow, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies into a temporary directory
COPY requirements.txt .
RUN pip3 install --no-cache-dir --prefix=/install -r requirements.txt

#FINAL RUNTIME STAGE

FROM python:3.11-slim

# Install ONLY the runtime libraries (much smaller)
RUN apt-get update && apt-get install -y --no-install-recommends \
    zlib1g \
    libjpeg62-turbo \
    libfreetype6 \
    libpng16-16 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built Python packages from builder stage
COPY --from=builder /install /usr/local

# Copy only application files
COPY . .

EXPOSE 8000

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
