import json
from typing import Dict

from example_routes import router as example_router
from shared.router import LambdaRouter

# create a router and register the routes
router = LambdaRouter()
router.update(example_router)


def handler(event: Dict, context: Dict):
    print("Event Received: {}".format(json.dumps(event)))

    return router.handle_route(event, context)
