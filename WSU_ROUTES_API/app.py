import os
import random
import queue
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

class Pin(dataBase.Model): #inital pin class
    __tablename__ = 'pins'
    id = dataBase.Column(dataBase.String, primary_key=True, unique=True, nullable=False) #different from event and profile id
    name = dataBase.Column(dataBase.String)
    isPublic = dataBase.Column(dataBase.Boolean)
    locationLat = dataBase.Column(dataBase.Float)
    locationLong = dataBase.Column(dataBase.Float)

class Event(dataBase.Model):
    id = dataBase.Column(dataBase.String, primary_key=True, unique=True, nullable=False) #different from pin and profile id
    name = dataBase.Column(dataBase.String)
    pinId = dataBase.Column(dataBase.String) 

class Comment(dataBase.Model):
    pinId = dataBase.Column(dataBase.String, primary_key=True, nullable=False) #not unique because multiple comments can be on same pin
    text = dataBase.Column(dataBase.String)
    userId = dataBase.Column(dataBase.String)

with app.app_context():
    dataBase.drop_all() #can comment this out so the database isn't reset everytime, also database isn't in cloud rn, only on your system.
    dataBase.create_all()


#code run

#supplemental code will go here

#Queries

@app.route("/something", methods = ["GET"])
def run():
    return jsonify({"variable: some value"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)#very important on where you host on machine, this is localhost port 5000
