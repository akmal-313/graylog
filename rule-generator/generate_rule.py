import json
import time

rule = {
    "rule_id": "rule-001",
    "filter_field": "_custom_field",
    "filter_value": "value",
    "action": "route-to-destination"
}

while True:
    print(json.dumps(rule))
    time.sleep(10)

