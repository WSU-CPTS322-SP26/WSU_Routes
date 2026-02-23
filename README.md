# WSU_Routes

How to test with api:
First, depending on whether you're doing android or chrome testing for api service layer - 
  use http://localhost/ for chrome
  use http://10.0.2.2:5000/ for android
Second, to run the api on your computer locally
  with a terminal (powershell, cmd) you need to cd into the WSU_ROUTES_API directory, or what has the app.py file
  run 'python app.py'
  this will run the api on your machine so flutter can interface with it through http calls
Third, now run your flutter app
  can either run it through android studio for android
  or use flutter run when cd'd into the flutter app directory in another terminal for chrome
