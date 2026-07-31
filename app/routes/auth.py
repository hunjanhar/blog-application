from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from werkzeug.security import generate_password_hash, check_password_hash
from app.models import User
from app import db

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    existing_admin = User.query.first()
    if existing_admin:
        flash("Admin already exists. Registration is closed.")
        return redirect(url_for('auth.login'))
    
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        hashed_pw = generate_password_hash(password)

        user = User(email=email, password=hashed_pw, is_admin=True)
        db.session.add(user)
        db.session.commit()

        flash("Admin account created! Please login.")
        return redirect(url_for('auth.login'))

    return render_template('register.html')

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = User.query.filter_by(email=request.form['email']).first()
        admin = User.query.first()
        
        if user and check_password_hash(user.password, request.form['password']):
            if user.id != admin.id:
                flash("Only admin has access")
                return redirect(url_for('auth.login'))
            login_user(user)
            return redirect(url_for('posts.index'))
        
        flash("Invalid credentials")
    return render_template('login.html')

@auth_bp.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('posts.index'))