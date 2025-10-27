# Use an official lightweight Python image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

RUN mkdir -p /app/out
# Copy the application code
COPY app.py /app

# Install dependencies
RUN pip install flask

# Expose the application port
EXPOSE 9001

# Define environment variables
ENV FLASK_APP=app.py

# Run the application
CMD ["python", "app.py"]
           
      
