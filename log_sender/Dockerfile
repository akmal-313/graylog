FROM python:3.11-alpine

# Install any extra utilities (optional: bash, curl, etc.)
RUN apk add --no-cache bash

# Create working directory
WORKDIR /app

# Copy script into the container
COPY ./send_gelf.py .

# Install required Python packages
RUN pip install --no-cache-dir requests

# Run the script
CMD ["python", "send_gelf.py"]
