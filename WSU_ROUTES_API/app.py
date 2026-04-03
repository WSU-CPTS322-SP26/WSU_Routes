import os
from flask import Flask, request, jsonify, render_template, url_for, redirect, Response, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import uuid #for generating unique ids for profiles, pins, and events
from flask_mail import Mail, Message
import random
from datetime import datetime, timedelta
#setup for database

app = Flask(__name__)
app.debug = True
CORS(app)

#setup for email auth + password reset features 
from flask_mail import Mail, Message
import random
from datetime import datetime, timedelta

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME', 'your_gmail@gmail.com')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD', 'your_app_password')
app.config['MAIL_DEFAULT_SENDER'] = app.config['MAIL_USERNAME']
mail = Mail(app)


database = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///my_database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # Disable tracking to save memory

dataBase = SQLAlchemy(app)

class Profile(dataBase.Model): #inital profile class
    __tablename__ = 'profiles'
    id = dataBase.Column(dataBase.String, primary_key=True, nullable=False) #different from event and pin id
    name = dataBase.Column(dataBase.String, unique=True)
    email = dataBase.Column(dataBase.String)
    notifOn = dataBase.Column(dataBase.Boolean)
    isClub = dataBase.Column(dataBase.Boolean)
    locationPermission = dataBase.Column(dataBase.Boolean)
    password = dataBase.Column(dataBase.String)

    #new components added for email auth and password reset features 
    otp = dataBase.Column(dataBase.String) #one time password 
    is_verified = dataBase.Column(dataBase.Boolean, default=False) 

class Pin(dataBase.Model): #inital pin class
    __tablename__ = 'pins'
    id = dataBase.Column(dataBase.String, nullable=False) #different from event and profile id
    name = dataBase.Column(dataBase.String)
    isPublic = dataBase.Column(dataBase.Boolean)
    locationLat = dataBase.Column(dataBase.Float)
    locationLong = dataBase.Column(dataBase.Float)
    description = dataBase.Column(dataBase.String, primary_key=True)

class Event(dataBase.Model):
    __tablename__ = 'events'
    id = dataBase.Column(dataBase.String, nullable=False) #different from pin and profile id
    name = dataBase.Column(dataBase.String)
    pinId = dataBase.Column(dataBase.String) 
    isPublic = dataBase.Column(dataBase.Boolean)
    date = dataBase.Column(dataBase.String) #Maybe just in format MM/DD/YYYY
    description = dataBase.Column(dataBase.String, primary_key=True)

class Comment(dataBase.Model):
    __tablename__ = 'comments'
    pinId = dataBase.Column(dataBase.String, primary_key=True, nullable=False) #not unique because multiple comments can be on same pin
    text = dataBase.Column(dataBase.String)
    userId = dataBase.Column(dataBase.String)

with app.app_context(): #determines if db resets
    dataBase.drop_all()
    dataBase.create_all()


#write this
def GenerateID():#will update
    return '1'

#write this
def CreateEvent(name, isPublic, date, description):
    tempEvent = Event.query.filter(Event.id == name).first() # 'function' object has no attribute 'query'
    if not tempEvent:
        newEvent = Event(id= name, name=name, pinId = GenerateID(), isPublic=True, date=date, description=description)#need to change id to actually be some generated ID
        dataBase.session.add(newEvent)
        dataBase.session.commit()
    else:
        print('ALREADY HAVE EVENT WITH ID')


def generate_otp(): #generate random 6 dig code
    return str(random.randint(100000, 999999))


def send_verification_email(email, otp): #send email with verif code for email verif or password reset
    msg = Message("Your verification code", recipients=[email])
    msg.body = f"Your verification code is: {otp}"
    mail.send(msg)


def is_mail_configured(): #setup outgoing email for codes
    username = app.config.get('MAIL_USERNAME')
    password = app.config.get('MAIL_PASSWORD')
    placeholder_user = username == 'your_gmail@gmail.com'
    placeholder_pass = password == 'your_app_password'
    return bool(username and password) and not (placeholder_user or placeholder_pass)

def CreatePrivateEvent(name, email, date, description):
    newEvent = Event(id= email, name=name, pinId = GenerateID(), isPublic=False, date=date, description=description)#need to change id to actually be some generated ID
    dataBase.session.add(newEvent)
    dataBase.session.commit()
    
def CreatePin(name, isPublic, locationLat, locationLong, description):
    newPin = Pin(id= name, name=name, isPublic=isPublic, locationLat=locationLat, locationLong=locationLong, description=description)
    dataBase.session.add(newPin)
    dataBase.session.commit()

def CreatePrivatePin(name, locationLat, locationLong, description, email):
    newPin = Pin(id= email, name=name, isPublic=False, locationLat=locationLat, locationLong=locationLong, description=description)
    dataBase.session.add(newPin)
    dataBase.session.commit()

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

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    existing_user = Profile.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({"error": "This user already exists"}), 400

    if not is_mail_configured():
        return jsonify({
            "error": "Email server is not configured. Set MAIL_USERNAME and MAIL_PASSWORD in your environment."
        }), 500
    
    otp = generate_otp() #generate random 6 digit otp

    new_user = Profile(
        id=str(uuid.uuid4()),
        name=name,
        email=email,
        password=password,
        notifOn=True,
        isClub=False,
        locationPermission=False,

        otp = otp,
        is_verified = False #initially unverified  
    )
    dataBase.session.add(new_user)
    dataBase.session.commit()

    #send otp email
    try:
        send_verification_email(email, otp)
    except Exception as e:
        # avoid creating accounts if OTP delivery fails.
        dataBase.session.delete(new_user)
        dataBase.session.commit()
        app.logger.exception("Failed to send OTP email during /register")
        if app.debug:
            return jsonify({"error": f"Failed to send OTP email: {str(e)}"}), 500
        return jsonify({"error": "Failed to send OTP email"}), 500


    return jsonify({"message": "OTP sent to email"}), 200

@app.route("/verify", methods = ['POST'])
def verify():
    data = request.get_json()
    email = data.get("email")
    otp_input = data.get("otp")

    user = Profile.query.filter_by(email=email).first()
    if not user:
        return jsonify({"error": "User not found"}), 404
    if user.is_verified:
        return jsonify({"message": "Email already verified"}), 200
    if user.otp != otp_input:
        return jsonify({"error": "incorrect otp"}), 400

    user.is_verified = True
    user.otp = None #clear otp after used
    dataBase.session.commit()
    return jsonify({"message": "Email verified",
    "id": user.id 
    }), 200


@app.route("/resend-otp", methods=['POST'])
def resend_otp():
    data = request.get_json()
    email = data.get("email")

    if not email:
        return jsonify({"error": "Email is required"}), 400

    user = Profile.query.filter_by(email=email).first()
    if not user:
        return jsonify({"error": "User not found"}), 404
    if user.is_verified:
        return jsonify({"message": "Email already verified"}), 200

    if not is_mail_configured():
        return jsonify({
            "error": "Email server is not configured. Set MAIL_USERNAME and MAIL_PASSWORD before starting backend server."
        }), 500

    user.otp = generate_otp()
    dataBase.session.commit()

    try:
        send_verification_email(email, user.otp)
    except Exception as e:
        app.logger.exception("Failed to resend OTP email during /resend-otp")
        if app.debug:
            return jsonify({"error": f"Failed to resend OTP email: {str(e)}"}), 500
        return jsonify({"error": "Failed to resend OTP email"}), 500

    return jsonify({"message": "A new OTP code was sent"}), 200

@app.route("/reset-password", methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get("email")

    if not email:
        return jsonify({"error": "Email is required"}), 400

    user = Profile.query.filter_by(email=email).first()
    if not user:
        return jsonify({"error": "User not found"}), 404

    if not is_mail_configured():
        return jsonify({
            "error": "Email server is not configured. Set MAIL_USERNAME and MAIL_PASSWORD before starting backend server."
        }), 500

    #if user is valid, generate otp code
    new_otp = generate_otp()
    user.otp = new_otp
    dataBase.session.commit()

    try:
        send_verification_email(email, new_otp)
    except Exception as e:
        app.logger.exception("Failed to send reset password OTP email")
        if app.debug:
            return jsonify({"error": f"Failed to send reset password OTP email: {str(e)}"}), 500
        return jsonify({"error": "Failed to send reset password OTP email"}), 500

    return jsonify({"message": "A new OTP code was sent for password reset"}), 200


@app.route("/reset-password/confirm", methods=['POST'])
def confirm_password_reset():
    data = request.get_json()
    email = data.get("email")
    otp_input = data.get("otp")
    new_password = data.get("newPassword")

    if not email or not otp_input or not new_password:
        return jsonify({"error": "Email, otp, and newPassword are required"}), 400

    user = Profile.query.filter_by(email=email).first()
    if not user:
        return jsonify({"error": "User not found"}), 404

    if user.otp != otp_input:
        return jsonify({"error": "incorrect otp"}), 400

    user.password = new_password #set new password if otp correct
    user.otp = None #clear otp after use 
    dataBase.session.commit() 

    return jsonify({"message": "Password reset successful"}), 200



@app.route("/login", methods = ['POST'])
def login():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    existing_user = Profile.query.filter_by(email=email).first()

    if existing_user and existing_user.password == password: #might add hashing for security
        
        if not existing_user.is_verified:
            return jsonify({"message": "Your email not verified"}), 403
        return jsonify({
            "message": "Welcome back " + existing_user.name,
            "id": existing_user.id #to be used in front end requests
        }), 200

    return jsonify({"error": "Invalid email or password"}), 401

@app.route("/events/public", methods = ['GET', 'POST'])
def GetPubEvents():
    events = Event.query.filter(Event.isPublic == True).order_by(Event.date).all()
    response = {}
    num = 0
    if(request.method == 'GET' and events): #checks if is a get request and if events isn't empty
        for event in events:#could break here, not correct syntax maybe
            response.update({
                "id" + str(num): event.id,
                "name" + str(num): event.name,
                "pinId" + str(num): event.pinId,
                "date" + str(num): event.date,
                "description" + str(num): event.description

            })
            num += 1
        response.update({"count": num}) 
        print(response) # to check
        return jsonify(response)
    elif(request.method == 'POST'):
        data = request.get_json()
        if data is None:
            return "No data",214
        else:
            CreateEvent(data['name'], data['isPublic'], data['date'], data['description'])
            return ('', 200)
    else:
        return ('', 204)
    
@app.route("/events/private/<email>", methods = ['GET', 'POST'])
def GetPrivateEvents(email):
    events = Event.query.filter(Event.id == email).order_by(Event.date).all()
    response = {}
    num = 0
    if(request.method == 'GET' and events): #checks if is a get request and if events isn't empty
        for event in events:#could break here, not correct syntax maybe
            response.update({
                "id" + str(num): event.id,
                "name" + str(num): event.name,
                "pinId" + str(num): event.pinId,
                "date" + str(num): event.date,
                "description" + str(num): event.description
            })
            num += 1
        response.update({"count": num})
        print(response) # to check
        return jsonify(response)
    elif(request.method == 'POST'):
        data = request.get_json()
        if data is None:
            return "No data",214
        else:
            CreatePrivateEvent(data['name'], data['email'], data['date'], data['description'])
            return ('', 200)
    else:
        return ('', 204)


@app.route("/pins/public", methods = ['GET', 'POST'])
def Pins():
    pins = Pin.query.filter(Pin.isPublic == True).all()
    response = {}
    num = 0
    if(request.method == 'GET'): 
        for pin in pins:
            response.update({
                "id" + str(num): pin.id,
                "name" + str(num): pin.name,
                "locationLat" + str(num): pin.locationLat,
                "locationLong" + str(num): pin.locationLong, 
                "description" + str(num): pin.description
            })
            num += 1
        response.update({"count": num}) 
        print(response) # to check
        return jsonify(response)
    elif(request.method == 'POST'):
        data = request.get_json()
        if data is None:
            return "No data",214
        else:
            CreatePin(data['name'], data['isPublic'], data['locationLat'], data['locationLong'], data['description'])
            return ('', 200)
    else:
        return ('', 204)


@app.route("/pins/private/<name>", methods = ['GET', 'POST'])
def PrivatePins(name):
    pins = Pin.query.filter(Pin.id == name).all()
    response = {}
    num = 0
    if(request.method == 'GET'): 
        for pin in pins:
            response.update({
                "id" + str(num): pin.id,
                "name" + str(num): pin.name,
                "locationLat" + str(num): pin.locationLat,
                "locationLong" + str(num): pin.locationLong, 
                "description" + str(num): pin.description
            })
            num += 1
        response.update({"count": num}) 
        print(response) # to check
        return jsonify(response)
    elif(request.method == 'POST'):
        data = request.get_json()
        if data is None:
            return "No data",214
        else:
            CreatePrivatePin(data['name'], data['locationLat'], data['locationLong'], data['description'], data['email'])
            return ('', 200)
    else:
        return ('', 204)




if __name__ == "__main__":

    #print("REGISTERED ROUTES:") #print for debugging #can be uncommented anytime
    #for rule in app.url_map.iter_rules():
        #print(rule)

    
    app.run(host="0.0.0.0", port=5000)#localhost port 5000
