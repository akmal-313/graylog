# Use official lightweight Python 3.12 image
FROM python:3.12-slim

# Set work directory inside the container
WORKDIR /app

# Copy your Python script into the container
COPY ./log-receiver.py .

# Install any dependencies if needed (optional)
# RUN pip install -r requirements.txt

# Default command to run your Python script
CMD ["python", "log-receiver.py"]
