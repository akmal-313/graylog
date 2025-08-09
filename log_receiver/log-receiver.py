import json
from flask import Flask, request

app = Flask(__name__)
output_file = "received_messages.json"

# Initialize or create the JSON file with an array if not exists
try:
    with open(output_file, 'r') as f:
        data = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    data = []

@app.route('/graylog_receiver', methods=['POST'])
def receive_logs():
    msg = request.json
    if msg:
        data.append(msg)
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        return {"status": "received"}, 200
    else:
        return {"error": "empty payload"}, 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
