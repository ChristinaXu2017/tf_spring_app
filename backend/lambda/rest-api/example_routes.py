import json
from typing import Dict
from shared.router import AuthError, LambdaRouter
from shared.test import shared_example

router = LambdaRouter()


@router.attach("/hello", "get", None)
def get_upload_urls(event: Dict, context: Dict):
    body = json.loads(event["body"])

    # example print
    print(body)
    # example func call
    shared_example()

    return {"success": True}


# auth example
def my_auth(event: Dict, context: Dict):
    body = json.loads(event["body"])

    if body.get("auth", False) == False:
        raise AuthError(403, "Condition not met")


# this function uses authentication
@router.attach("/savedata", "post", my_auth)
def get_upload_urls(event: Dict, context: Dict):
    body = json.loads(event["body"])

    # example print
    print(body)
    # example func call
    shared_example()

    return {"success": True}
