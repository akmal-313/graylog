import requests
import time
import json
import logging

graylog_url = "http://graylog:12202/gelf"  # Replace host/port according to your setup

# Configure logging to file
logging.basicConfig(
    filename='gelf_send.log',         # Log file name
    level=logging.INFO,               # Log level
    format='%(asctime)s - %(levelname)s - %(message)s'
)

id_counter = 0
max_id = 10

while True:
    # Format ID with zero-padded number from 00 to 10
    current_id = f"IDXXX{id_counter:02d}"
    
    gelf_message = {
        "version": "1.1",
        "host": "HOSTX0001",
        "short_message": "Test log message",
        "timestamp": time.time(),
        "level": 6,           # 6 = informational
        "_id": current_id      # custom field rotating ID
    }
    
    try:
        response = requests.post(
            graylog_url,
            data=json.dumps(gelf_message),
            headers={"Content-Type": "application/json"}
        )
        msg = f"Sent GELF log with _id={current_id}, response code: {response.status_code}"
        print(msg)
        logging.info(msg)  # Log success
    except Exception as e:
        error_msg = f"Failed to send GELF log with _id={current_id}: {e}"
        print(error_msg)
        logging.error(error_msg)  # Log failure with error info

    # Increment and rollover counter to stay between 00 and 10
    id_counter = (id_counter + 1) % (max_id + 1)

    time.sleep(1)  # Send every second
