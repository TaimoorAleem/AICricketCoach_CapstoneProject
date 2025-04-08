# Use the official Python image
FROM python:3.10-slim AS builder

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV TMPDIR=/app/tmp

# Set the working directory
WORKDIR /app

# Ensure /app is writable
RUN mkdir -p $TMPDIR && chmod -R 777 /app

# Install system dependencies for OpenCV
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file to the working directory
COPY requirements.txt /app/

# Install dependencies (no cache to reduce size)
RUN pip install --no-cache-dir --no-compile -r requirements.txt \
    && rm -rf /root/.cache

# Copy the rest of the application code
COPY ../../../just_backend/vp%20-%20Copy /app/

# Now the final image will be built with only the necessary files
FROM python:3.10-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies again in the final stage
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed dependencies from the builder image
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["gunicorn", "--timeout", "300", "--workers", "4", "--bind", "0.0.0.0:8080", "app:app"]
