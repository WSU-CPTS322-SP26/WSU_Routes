# Sprint 3 Report  

## What's New (User Facing) 

 * Improved UI (App color theme) 

 * Integrated GPS Redirect for pins 

 * Foundation for in-building navigation 

 

## Work Summary (Developer Facing) 

Profile and interactivity features were improved during this sprint. Preferences sync properly with the database and allow settings/profile consistency in subsequent app launches. UI improvements including app logo and widgets implemented to match WSU’s graphic design conventions. To improve the app’s viability as an all-in-one campus app, we added implementation for GPS tracking through a Google Maps redirect. In addition to GPS tracking, a foundation has been made to create in-building navigation through custom maps to help navigation. 

 

## Unfinished Work 

Currently most buildings are missing SVGs and have no pathfinding to guide users to a room. We also are missing in-app navigation in general as well as more social features like pin sharing. We ran out of time to implement these. Another feature we would like to have is WSU email integration and verification. This was not implemented for technical reasons. Finally, we want to expand this to other campuses and maybe include more QoL features like an in-app calendar. The were omitted because they exceeded the desired scope. 

 

## Completed Issues/User Stories 

Here are links to the issues that we completed in this sprint: 

 * https://github.com/WSU-CPTS322-SP26/WSU_Routes/issues/30 

 * https://github.com/WSU-CPTS322-SP26/WSU_Routes/issues/21 

* https://github.com/WSU-CPTS322-SP26/WSU_Routes/issues/29  

  

 ## Incomplete Issues/User Stories 

 Here are links to issues we worked on but did not complete in this sprint: N/A 

  

*All existing issues opened prior to the sprint were completed 

*Stretch goal features like building intractability, and individual profile schedules were dismissed before the sprint began to focus on core features (UI, building data, and navigation)  

*In-app navigation and individual profiles were too technically demanding to take on during the sprint period, visual aspects and design choices were prioritized for demo purposes 

  

## Code Files for Review 

Please review the following code files, which were actively developed during this sprint, for quality: 

 * [Android Launch and Display Files](https://github.com/WSU-CPTS322-SP26/WSU_Routes/pull/31/changes) 

 * [Main backend (app.py](https://github.com/WSU-CPTS322-SP26/WSU_Routes/blob/main/WSU_ROUTES_API/app.py) 

 * [Map and Pin Logic Files](https://github.com/WSU-CPTS322-SP26/WSU_Routes/pull/34/changes) 

  

## Retrospective Summary 

Here's what went well: 

  * Reducing bugs on previous features (profile preferences, database connections) 

  * More professional and customized UI 

 * Dynamic GPS implementation with Google Maps 

 * Base for continual application of in-building navigation  

  

Here's what we'd like to improve: 

   * Make app available for more operating systems (iOS) 

   * More details on building mapping (images, notices, directions) 

   * Social features (shared pins, building comments, group posts, etc.) 

   

Here are changes we plan to implement in the next sprint (hypothetically ?): 

   * Add social features (pin sharing, group posts, etc.) 

   * Cloud deployment, support more operating systems 

   * In app navigation as opposed to Google Maps routing 

   * Integrate WSU emails for login (Canvas and other student data implemented automatically to profile) 