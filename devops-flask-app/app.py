import os
# pyrefly: ignore [missing-import]
import redis
# pyrefly: ignore [missing-import]
from flask import Flask, jsonify

app = Flask(__name__)

# Connect to Redis using the hostname from environment variable
# Docker Compose networking lets us use the service name as hostname
redis_host = os.environ.get('REDIS_HOST', 'localhost')
redis_client = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.route('/')
def home():
    # Increment and read the visit counter stored in Redis
    visit_count = redis_client.incr('visits')
    return jsonify({
        'message': 'DevOps Project - Day 5: Flask + Redis',
        'version': '2.0',
        'visit_count': visit_count,
        'redis_host': redis_host
    })

@app.route('/health')
def health():
    # Also check Redis connectivity as part of health check
    try:
        redis_client.ping()
        redis_status = 'connected'
    except Exception as e:
        redis_status = f'error: {str(e)}'

    return jsonify({
        'status': 'healthy',
        'redis': redis_status
    })

@app.route('/reset')
def reset():
    redis_client.set('visits', 0)
    return jsonify({'message': 'Visit counter reset to 0'})

if __name__ == '__main__':
    # Binds to 0.0.0.0 so it's accessible outside the container
    app.run(host='0.0.0.0', port=5000)