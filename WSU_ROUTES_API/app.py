import os
from flask import Flask, request, jsonify, render_template, url_for, redirect, Response, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import uuid #for generating unique ids for profiles, pins, and events
#setup for database

app = Flask(__name__)
app.debug = True
CORS(app)

database = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///my_database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # Disable tracking to save memory

dataBase = SQLAlchemy(app)

class Profile(dataBase.Model): #inital profile class
    __tablename__ = 'profiles'
    id = dataBase.Column(dataBase.String, primary_key=True, unique=True, nullable=False) #different from event and pin id
    name = dataBase.Column(dataBase.String)
    email = dataBase.Column(dataBase.String)
    notifOn = dataBase.Column(dataBase.Boolean)
    isClub = dataBase.Column(dataBase.Boolean)
    locationPermission = dataBase.Column(dataBase.Boolean)
    password = dataBase.Column(dataBase.String)

class Pin(dataBase.Model): #inital pin class
    __tablename__ = 'pins'
    id = dataBase.Column(dataBase.String, primary_key=True, unique=True, nullable=False) #different from event and profile id
    name = dataBase.Column(dataBase.String)
    isPublic = dataBase.Column(dataBase.Boolean)
    locationLat = dataBase.Column(dataBase.Float)
    locationLong = dataBase.Column(dataBase.Float)

class Event(dataBase.Model):
    __tablename__ = 'events'
    id = dataBase.Column(dataBase.String, primary_key=True, unique=True, nullable=False) #different from pin and profile id
    name = dataBase.Column(dataBase.String)
    pinId = dataBase.Column(dataBase.String) 

class Comment(dataBase.Model):
    __tablename__ = 'comments'
    pinId = dataBase.Column(dataBase.String, primary_key=True, nullable=False) #not unique because multiple comments can be on same pin
    text = dataBase.Column(dataBase.String)
    userId = dataBase.Column(dataBase.String)

with app.app_context():
    dataBase.drop_all() #can comment this out so the database isn't reset everytime, also database isn't in cloud rn, only on your system.
    dataBase.create_all()


#code run

#supplemental code will go here

#Queries

@app.route("/profile/<id>", methods = ['GET'])
def ProfilePage(id):
    if(request.method == 'GET'):
        curProfile = Profile.query.filter(Profile.id == id).first() # 'function' object has no attribute 'query'
        if curProfile is not None:
            return jsonify(
                {
                    "id": curProfile.id,
                    "name": curProfile.name,
                    "email": curProfile.email,
                    "notifOn": curProfile.notifOn,
                    "isClub": curProfile.isClub,
                    "locationPermission": curProfile.locationPermission,
                    "password": curProfile.password
                }
            )
    return

@app.route("/profile/<id>/notifOn", methods = ['GET', 'PUT'])
def ProfileNotifOn(id):
    curProfile = Profile.query.filter(Profile.id == id).first()
    if(request.method == 'GET'):
        if curProfile is not None:
            return jsonify(
                {
                    "notifOn": curProfile.notifOn,
                }
            )
    elif(request.method == 'PUT'):
        data = request.get_json()
        if data is None:
            return "No data",214
        if curProfile is not None:
            curProfile.notifOn = data['notifOn']
            dataBase.session.commit()
    return ('', 204)
        
@app.route("/profile/<id>/isClub", methods = ['GET', 'PUT'])
def ProfileisClub(id):
    curProfile = Profile.query.filter(Profile.id == id).first()
    if(request.method == 'GET'):
        if curProfile is not None:
            return jsonify(
                {
                    "isClub": curProfile.isClub,
                }
            )
    elif(request.method == 'PUT'):
        data = request.get_json()
        if data is None:
            return "No data",214
        if curProfile is not None:
            curProfile.isClub = data['isClub']
            dataBase.session.commit()
    return ('', 204)

@app.route("/profile/<id>/locationPermission", methods = ['GET', 'PUT'])
def ProfilelocationPermission(id):
    curProfile = Profile.query.filter(Profile.id == id).first()
    if(request.method == 'GET'):
        if curProfile is not None:
            return jsonify(
                {
                    "locationPermission": curProfile.locationPermission,
                }
            )
    elif(request.method == 'PUT'):
        data = request.get_json()
        if data is None:
            return "No data",214
        if curProfile is not None:
            curProfile.locationPermission = data['locationPermission']
            dataBase.session.commit()
    return ('', 204)


@app.route("/register", methods = ['POST'])
def register():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")
    name = data.get("name")

    existing_user = Profile.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({"error": "This user already exists"}), 400
    
    new_user = Profile(
        id=str(uuid.uuid4()),
        name=name,
        email=email,
        password=password,
        notifOn=True,
        isClub=False,
        locationPermission=False
    )
    dataBase.session.add(new_user)
    dataBase.session.commit()

    return jsonify({"id": new_user.id}), 200

@app.route("/login", methods = ['GET'])
def login():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    existing_user = Profile.query.filter_by(email=email).first()

    if existing_user and existing_user.password == password:
        return jsonify({
            "message": "Welcome back " + existing_user.name,
        }), 200

    return jsonify({"error": "Invalid email or password"}), 401


if __name__ == "__main__":

    print("REGISTERED ROUTES:") #print for debugging
    for rule in app.url_map.iter_rules():
        print(rule)

    
    app.run(host="0.0.0.0", port=5000)#very important on where you host on machine, this is localhost port 5000
