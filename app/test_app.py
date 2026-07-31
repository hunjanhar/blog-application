from unittest.mock import patch
import pytest
from . import create_app, db

@pytest.fixture
def client():
    with patch('redis.Redis'):
        app = create_app()
        app.config['TESTING'] = True
        
        with app.app_context():
            db.create_all()
            with app.test_client() as test_client:
                yield test_client
            db.drop_all()

def test_personal_blog_app_endpoint_structure(client):
    response = client.get('/')
    assert response.status_code == 200