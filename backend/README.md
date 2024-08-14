# Template Backend

This folder contains all the codes of the backend.

## Introduction

All the routing is handled by the `rest-api` folder. This way we can have a low powered lambda to show content, do basic routing, etc.

## Adding a new lambda function

You can add terraform definitions in terraform folder. To create the corresponding python code, use the following steps.

1. Create a new folder inside `lambda` folder. Use `snakecase` naming.

2. Create a `hanlder.py` and add a function named `handler(event, content)`. Now this function is ready to be wired up in terraform.

## Adding new routes

Open `lambda/rest-api/hanlder.py` file. You can use the following template to add routes.

```python
import json

from router import LambdaRouter

router = LambdaRouter()


@router.attach("/get_upload_urls", "get", None)
def test(event, context):

    return {"success": True, "event": json.dumps(event)}


def handler(event, context):
    print("Event Received: {}".format(json.dumps(event)))

    return router.handle_route(event, context)
```

If you want to create a separate file for a router, follow the same approach and import the router instance to the `handler.py` and register as follows.

```python
import json

from router import LambdaRouter
from second_endpoints import second_router

router = LambdaRouter()
router.update(second_router)
```

Updating `handler.py` router with other routers is essential for functionality.