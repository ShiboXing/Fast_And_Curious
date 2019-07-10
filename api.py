from flask import Flask, render_template, request, redirect, Response,jsonify
import random, json
from flask_restful import Api, Resource, reqparse

app=Flask(__name__,static_url_path="/static", static_folder="static")

api=Api(app)

data={
	#angle
	"a":0,
	#hasStarted
	"hs":False
}

class Angle(Resource):

	def put(self):
		parser=reqparse.RequestParser()
		parser.add_argument("a")
		parser.add_argument("hs")
		args=parser.parse_args()
		
		data["a"]=int(float(args["a"][9:-1]))

		data["hs"]=bool(args["hs"])
		print(data["hs"])
	
		#ok
		return data

	@app.route('/receiver')
	def get():		
		parser=reqparse.RequestParser()
		parser.add_argument("hs")
		args=parser.parse_args()
		
		data["hs"]=bool(args["hs"])
		
	#	print("post!!!!!")		
		#ok
		print("get :"+str(data))
		return jsonify(data)




@app.route('/')
def output():
	return render_template('index.html')

@app.route('/steelhacks')
def output22():
	return render_template('/steelhacks/index.html')


api.add_resource(Angle,"/")
app.run(debug=True,host="0.0.0.0",port=443)
