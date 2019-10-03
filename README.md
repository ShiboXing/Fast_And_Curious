# Fast&Curious

A javascript-based mathematical game with iPhone as motion controller. It allows users to navigate a racecar with their iPhone across lanes to collect coins with corresponding answers to math problems.

## structure

The server files folder contains the web app and all the necessary resources. 
A python script that holds the REST API of this project is placed at the root level of the Server files folder. 

The mobile app folder contains the complete code for the mobile motion controller. 

## how to install

The server files folder is to be copied to a linux terminal with python installed and hosted with a web server (e.g. apache2). Make sure https (443) port is open then the game could be accessed with a browser visiting the corresponding address (:443).

Once the server files are deployed, run api.py to initiate the REST API (e.g.  python3 api.py) 

The mobile app could be deployed on an iPhone with Xcode. The app automatically sends API calls to Flask once opened.   
