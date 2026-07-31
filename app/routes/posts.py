from flask import Blueprint, render_template, request, redirect, url_for
from flask_login import login_required, current_user
from app.models import Post
from app.services import handle_image_upload, cache_get, cache_set, cache_delete
from app import db

posts_bp = Blueprint('posts', __name__)

@posts_bp.route('/')
def index():
    # Try reading posts from Redis cache first
    cached_posts = cache_get('all_posts')
    if cached_posts:
        return render_template('index.html', posts=cached_posts)

    posts = Post.query.all()
    posts_data = [
        {'id': p.id, 'title': p.title, 'content': p.content, 'image': p.image}
        for p in posts
    ]
    # Cache query result for 5 minutes (300 seconds)
    cache_set('all_posts', posts_data, ttl=300)

    return render_template('index.html', posts=posts_data)

@posts_bp.route('/single/id=<int:id>')
def single_post(id):
    post = Post.query.get_or_404(id)
    return render_template('single.html', post=post)

@posts_bp.route('/create', methods=['GET', 'POST'])
@login_required
def create():
    if request.method == 'POST':
        file = request.files.get('image')
        image_path = handle_image_upload(file) if file else None

        post = Post(
            title=request.form['title'],
            content=request.form['content'],
            image=image_path,
            user_id=current_user.id
        )
        db.session.add(post)
        db.session.commit()

        # Invalidate post cache so the new post appears immediately
        cache_delete('all_posts')

        return redirect(url_for('posts.index'))

    return render_template('create_post.html')