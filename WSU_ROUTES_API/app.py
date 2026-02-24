import os
from flask import Flask, request, jsonify, render_template, url_for, redirect, Response, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

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
    isPublic = dataBase.Column(dataBase.Boolean)
    date = pinId = dataBase.Column(dataBase.String) #Maybe just in format MM/DD/YYYY

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

@app.route("/events/public", methods = ['GET'])
def GetPubEvents():
    events = Event.query.filter(Event.isPublic == True).all()
    response = {}
    num = 0
    if(request.method == 'GET' and events): #checks if is a get request and if events isn't empty
        for i in events:#could break here, not correct syntax maybe
            response += {
                "id" + str(i): events[i].id,
                "name" + str(i): events[i].name,
                "pinId" + str(i): events[i].pinId,
                "date" + str(i): events[i].date,

            }
            num += 1
        response += {"count": num}    
        print(response) # to check
        return jsonify(response)
    else:
        return ('', 204)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)#very important on where you host on machine, this is localhost port 5000
