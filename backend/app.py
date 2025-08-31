from flask import Flask, jsonify
import socket
import datetime

app = Flask(__name__)

@app.route('/info')
def get_info():
    return jsonify({
        'hostname': socket.gethostname(),
        'timestamp': datetime.datetime.now().isoformat(),
        'message': 'Backend service is running!'
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)