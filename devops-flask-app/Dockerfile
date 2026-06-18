# Step 1: Use an official lightweight Python image
FROM python:3.11-slim

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy dependency list first to leverage Docker cache
COPY requirements.txt .

# Step 4: Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the rest of the application code
COPY . .

# Step 6: Expose port 5000
EXPOSE 5000

# Step 7: Define the command to run the application
CMD ["python", "app.py"]