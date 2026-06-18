from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({'message': 'DevOps Project', 'version': '1.0'})

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    # We run on 0.0.0.0 so it's accessible outside the container
    app.run(host='0.0.0.0', port=5000)