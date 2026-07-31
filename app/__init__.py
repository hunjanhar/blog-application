import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
import redis

db = SQLAlchemy()
login_manager = LoginManager()
redis_client = None

def create_app():
    app = Flask(__name__, template_folder='../templates', static_folder='../static')
    app.config.from_object('app.config.Config')

    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

    db.init_app(app)
    
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    global redis_client
    redis_client = redis.Redis(
        host=app.config['REDIS_HOST'],
        port=app.config['REDIS_PORT'],
        db=app.config['REDIS_DB'],
        decode_responses=True
    )

    from app.routes.auth import auth_bp
    from app.routes.posts import posts_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(posts_bp)

    from app.models import User

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    @app.context_processor
    def inject_user_status():
        try:
            user_exists = User.query.first() is not None
        except Exception:
            user_exists = False
        return dict(user_exists=user_exists)

    with app.app_context():
        try:
            db.create_all()
        except Exception as e:
            print(f"Database connection error: {e}")

    return app