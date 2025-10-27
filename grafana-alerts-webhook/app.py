from flask import Flask, request
import os
import datetime
import json


app = Flask(__name__)

SAVE_DIR = "out"
os.makedirs(SAVE_DIR, exist_ok=True)
alerts = []


@app.route("/")
def index():
    return "OK"


def getMessage(message):
    message = (
        json.dumps(message, indent=2)
        .replace("\\n", "")
        .replace("\\r", " ")
        .replace("\\", "")
    )
    data = json.loads(message)
    severity = data["severity"]
    alertname = data["alert_name"]
    phase = data["phase"]
    value = ""
    return message


def getAlertData(alert):
    phase = ""
    value = ""
    name = ""
    alertData = json.loads(alert)
    pretty_json = json.dumps(alertData, indent=2)

    # message = getMessage(alertData["message"])
    # value_row=f"<td>{name}</td><td>{phase}</td><td>{value}</td>"

    return pretty_json


@app.route("/alerts")
def dashboard():
    result = f"<p>Alerts:{len(alerts)}</p><br>"
    # result = "<table><tr><th>Name</th><th>Phase</th><th>Value</th></tr>"
    result = "<table border=1><tr><th>Sl No.</th><th>Raw Data</th></tr>"
    for i in range(len(alerts)):
        data = getAlertData(alerts[i])
        result = result + f"<tr><td>{i}</td><td><pre>{data}</pre></td></tr>"
    result = result + "</table>"
    return result


@app.route("/webhook", methods=["POST"])
def webhook():
    # Timestamp for unique file naming
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S_%f")

    # Raw request body
    data = request.get_data(as_text=True)
    alerts.append(data)
    # File name for each payload
    filename = os.path.join(SAVE_DIR, f"webhook_{timestamp}.json")

    # Write the payload to file
    with open(filename, "w", encoding="utf-8") as f:
        f.write(data)

    print(f"✅ Webhook received and saved to {filename}", flush=True)
    print("-----------------------------")
    return "", 204


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9001, debug=True)
