import socket
import json
import time

graylog_host = "graylog"
graylog_port = 12201

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

gelf_message = {
    "version": "1.1",
    "host": "logsource",
    "short_message": "Test log message",
    "level": 6,
    "_custom_field": "value"
}

while True:
    sock.sendto(json.dumps(gelf_message).encode(), (graylog_host, graylog_port))
    print("Sent GELF log")
    time.sleep(5)

