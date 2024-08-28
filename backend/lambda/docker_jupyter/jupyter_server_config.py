from s3contents import S3ContentsManager
import os

c = get_config()

# Configure Jupyter to use S3ContentsManager
c.ServerApp.contents_manager_class = S3ContentsManager
c.S3ContentsManager.endpoint_url = 'https://s3.' + os.getenv('REGION') + '.amazonaws.com'
c.S3ContentsManager.bucket = os.getenv("BUCKET")
c.S3ContentsManager.prefix = "notebooks"
c.ServerApp.password = os.getenv('HASHED_PW')
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.open_browser = False
c.ServerApp.allow_remote_access = True
c.ServerApp.port = 8888
