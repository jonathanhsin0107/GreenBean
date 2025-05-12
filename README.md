**GreenBean:** Rewards that grow with your sustainable habits
**Authors:** Baibhav Nepal, Bita Jalal, Jonathan Hsin, and Joseph Tran

GreenBean is an app that aims to inspire users to shop sustainably by awarding them virtual reward points for the purchase of sustainable items.

- This repository has all the classes required to build and run the project or the app on your device. This is a mobile (iOS) application.
- There are a couple of folders/directories in this repo:
    - The location folder hosts the locationManager that is responsible for the location awareness feature (only shows products at your nearby grocery chain).
    - GreenBeanApp.swift takes care of the pop-ups and nudges regarding fun facts.
    - ContentView is responsible for the overall front-end view of the app (also integrating rewardPointsAlgorithm to the view).
    - The Supporting Files directory consists of files that work with VerifyAPI and attach HTTP headers for the API.
    - The API Data Model directory converts JSON format to API so that we can handle the receipt analysis part.
    - Assets contains all the image sets we've used within the platform.
    - The Database directory consists of files that create the database listing, add items to the listing, etc.
    - The Tab views are where most of our core code lies. Each feature or tab in the platform has a separate class/file. For instance, Settings.swift takes care of the settings tab in the app (ranging from the view of the app to that of the functionality).
    - The Medicine Tracker directory has a number of classes/files that work together to get the Medicine Tracker functionality to work. It enables medicine logs, expiration date logs, picture updates, reminders and notifications, etc.


**Features:**
1. Product Listing - You can search for and view sustainable products and their details by location (of grocery stores)
2. Favorites Tab - Save your favorite weekly groceries to the favorites tab
3. Receipt Scan - Scan your grocery receipts and earn reward points for sustainable purchases
4. Rewards Page - Track and redeem your lifetime reward points with virtual badges
5. Location Awareness - Find products only at your nearest grocery store
6. Medicine Tracker - Log medicines and their expiration dates (also get reminders before they expire)
7. Notifications & Nudges - Get reminders and notifications about medicine expiration, fun facts, etc.


**Credits:** 
* Our app has been built using SwiftUI. We've made use of Swift and Apple frameworks.
* For OCR (Optical Character Recognition), we've used Veryfi API to analyze text and numbers from a receipt.
* We've also taken help from OpenAI's ChatGPT for certain purposes such as data generation (manually copying the item entries on the supermarket websites and passing it to ChatGPT to convert the data into JSON format), code debugging etc.
* Most importantly, we've used Prof. Osman Balci's Swift structure for classes such as our tab views. We received permission from the Professor before beginning work and have also credited him on top of the files that he owned.


**Running the application:**
* You will need Xcode and a Mac with SwiftData and SwiftUI support.
* Clone our repository using git clone https://github.com/jonathanhsin0107/GreenBean.git
* Then, open GreenBean.xcodeproj in your Xcode.
* Compile (i.e. build) the code and run the app on either a simulator or an iOS device.
