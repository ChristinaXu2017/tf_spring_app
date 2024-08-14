import json
from typing import Dict


# this is not an HTTP API function, this is an invoke call from another lambda, SNS, etc
def handler(event: Dict, _: Dict):
    print("Event Received: {}".format(json.dumps(event)))

    return {
        "success": True,
    }


if __name__ == "__main__":
    # an example test
    event = {
        "test": "1234",
    }

    res = handler(event, "")
    print(res)
