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

#code run

#some stuff will go here

#Queries

@app.route("/something", methods = ["GET"])
def run():
    return jsonify({"variable: some value"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)#very important on where you host on machine, this is localhost port 5000