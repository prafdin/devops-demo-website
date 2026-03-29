from flask import Flask, jsonify
import socket
import datetime
import requests

app = Flask(__name__)
HTTPBIN_DELAY_URL = "https://httpbin.org/delay/0.001"

@app.route('/info')
def get_info():
    resp = requests.get(HTTPBIN_DELAY_URL)
    return jsonify({
        'hostname': socket.gethostname(),
        'timestamp': datetime.datetime.now().isoformat(),
        'message': 'Backend service is running!'
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)