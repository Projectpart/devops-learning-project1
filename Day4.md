Step 1 → Start from a base image
Step 2 → Create workspace
Step 3 → Copy dependencies
Step 4 → Install dependencies
Step 5 → Copy app code
Step 6 → Document port
Step 7 → Start application
 
 
 
Day 4: Dockerfile + Your Project App
 
Task Overview
Successfully containerized a custom Python Flask application by writing an optimized, multi-layer `Dockerfile`[cite: 1]. The image has been built, tested locally, and pushed to Docker Hub to allow seamless deployment on any machine running Docker[cite: 1].
 
 
Project Architecture & Files
 
1.requirements.txt
Contains the necessary application dependencies
Flask==3.0.3
 
2. app.py
 
A simple Flask web application featuring a home route and a dedicated health-check endpoint.
 
from flask import Flask, jsonify
app = Flask(__name__)
 
@app.route('/')
def home():
    return jsonify({'message': 'DevOps Project', 'version': '1.0'})
 
@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})
 
if __name__ == '__main__':
    # Binds to 0.0.0.0 to ensure accessibility outside the container
    app.run(host='0.0.0.0', port=5000)
 
 
 3. Dockerfile
 
Optimized by copying `requirements.txt` and running package installation *before* copying the source code to maximize Docker layer caching benefits.
 
dockerfile
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
 
# Step 7: Define the default command to execute the application
CMD ["python", "app.py"]
 
 
Commands Executed
 
1. Build the Docker Image
 
docker build -t your_dockerhub_username/flask-app:v1.0 .
 
 
2. Run and Verify Locally
 
# Run container in detached mode with port mapping
docker run -d -p 5000:5000 --name my-running-app your_dockerhub_username/flask-app:v1.0
 
# Verify endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
 
# Check runtime logs
docker logs my-running-app
 
3. Push Registry Release
 
docker login
docker push your_dockerhub_username/flask-app:v1.0
 
4. Cleanup
docker stop my-running-app && docker rm my-running-app
 
 
Key Takeaways
 
Layer Optimization: Learned that changing any line in a `Dockerfile` invalidates the cache for all subsequent steps. Structuring code copies *after* package installations drastically cuts down build times.
 
 
Port Mapping: Mastered routing host traffic using the `-p host_port:container_port` convention to make containerized services reachable.