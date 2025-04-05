# Use a lightweight Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080
EXPOSE 8080

# Use Gunicorn to serve the app
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
