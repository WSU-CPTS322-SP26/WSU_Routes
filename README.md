# WSU_Routes

## Project summary: 
Elevator Pitch/Brief Summary: Mobile app built to streamline campus navigation, event planning, and social event organization for WSU students and alumni.
### Additional information
WSU Routes is a navigation app that integrates student locations and events with an
interactive map. Students can view pins to connect with these clubs, while also being able to
place their own public or private pins to communicate with each other or to add
notes. Students’ pins and classes can be integrated into their own public calendar to manage
time efficiently. We aim to develop a comprehensive application that is both customized for WSU students and is flexible
to accommodate different organizational styles and user needs.
## Installation

### Prerequisites
Flutter SDK
Dart SDK (included with Flutter)
Python 3.9+
Git
Android Studio
Android SDK

### Add-ons
Flutter: Software development kit, using Dart programming language. Modify and stack widgets for appealing UI with multiplatform functionality.
Dart: Programming language used by flutter.
Google Maps SDK: Integrates accurate Google Maps into app interface.
Python: Used for backend, virtual environment used for database server.
Flask: Handles database interactions and API calls. 
Git: Version control.
GitHub: Project management and repository hosting. 

### Installation Steps
With prerequisites installed, the following commands will setup up the app.

Setup backend server:
`cd WSU_ROUTES_API` 
`python -m venv venv`
`venv\Scripts\activate` //windows command

Install dependencies:
`pip install -r requirements.txt`

Run python backend server:
`python app.py`

Navigate to Flutter app folder:
`cd google_maps_in_flutter`

Install Flutter dependencies:
`flutter pub get`

Run Flutter app:
`flutter run`

Android Emulation:
-Launch emulator of android (tested with Pixel 6 API 33)

## Functionality
Front-End/Main UI:
Boots to login page. Click "Register" to be added to the app database. Enter the desired email
and password. Map/main page interface is then loaded. Scroll around to navigate map. 
Click top left icon to modify profile preferences. Use widgets to modify preferences.
From main map, top right icon can be used to log out.

Back-End/How to Test APIL
First, depending on whether you're doing android or chrome testing for api service layer - 
  use http://localhost/ for chrome
  use http://10.0.2.2:5000/ for android
Second, to run the api on your computer locally
  with a terminal (powershell, cmd) you need to cd into the WSU_ROUTES_API directory, or what has the app.py file
  run 'python app.py'
  this will run the api on your machine so flutter can interface with it through http calls

## Known Problems
The following are some of the known major issues with our program. The errors will be addressed during our next sprint. 

-Preference page can be navigated to via the button in the top left of the map interface, however the button to return back to 
the map has not yet been implemented. The app has to be restarted to return to main page. (preferences_page.dart)

-Event page can only be navigated to by commenting out existing runApp call and uncommenting the above runApp call (that contains the event page widget) (main.dart)

-Invalid emails and insecure passwords can be used. The user will still be stored in the database. Security measures to be added. (login_page.dart)

-No text indication to user when login or register fails, can only determine via the program logs. Plan to implement popups to guide user. (login_page.dart)

## Additional Documentation
* [Sprint 1 User Stories](UserStories.txt) 
* [Sprint 1 Report](Sprint1Report.md) 
* Demo Video Link: (TBA)
