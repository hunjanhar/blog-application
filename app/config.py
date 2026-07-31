import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'secret123')
    
    if os.environ.get('DATABASE_URL'):
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    else:
        db_user = os.environ.get('MYSQL_USER', 'admin')
        db_pass = os.environ.get('MYSQL_PASSWORD', 'root')
        db_host = os.environ.get('MYSQL_HOST', 'mysql-service')
        db_name = os.environ.get('MYSQL_DB', 'blogapp')
        SQLALCHEMY_DATABASE_URI = f'mysql+pymysql://{db_user}:{db_pass}@{db_host}/{db_name}'

    SQLALCHEMY_TRACK_MODIFICATIONS = False

    REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
    REDIS_PORT = int(os.environ.get('REDIS_PORT') or 6379)
    REDIS_DB = int(os.environ.get('REDIS_DB', 0))

    AWS_BUCKET_NAME = os.environ.get('AWS_BUCKET_NAME')
    AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
    AWS_REGION = os.environ.get('AWS_REGION', 'ap-south-1')
    AWS_BUCKET_URL = os.environ.get('AWS_BUCKET_URL', '/static/uploads/')
    UPLOAD_FOLDER = os.path.join('static', 'uploads')