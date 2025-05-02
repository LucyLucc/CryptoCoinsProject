# CryptoCoinsProject
An iOS application that fetches data from the CoinRanking API 

- Instructions for building and running the application

Step 0: Prerequisites:
macOS installed.
Xcode installed (download from the Mac App Store).
A valid Apple ID (for testing on a real device or distributing on App Store).

Step 1 :  Clone/Download the project
a. Clone or Download the project fro github via this link https://github.com/LucyLucc/CryptoCoinsProject
b. Add SnapKit a a project dependency on Xcode
    https://github.com/SnapKit/SnapKit
    
Step 2: Open the Project
Open Xcode.
Choose:
File → Open... (if you already have a project)
Or From the downloaded files, identify the .xcodeproj file and open it on Xcode

Step 3: Choose Run Destination
In the top toolbar, select a simulator or your connected device.

 Step 4: Build and Run the App
Click the Play button tobuild your app and launch on simulator or your connected device.

- Any assumptions or decisions made during the test
1. It’s assumed that the device or simulator has network connectivity
2. API endpoints are available and stable.
3. Dependencies have been correctly installed and integrated



- What are the challenges encountered and how did you address them?
1. UI tests fail intermittently due to loading times .

Solution:
Added wait expectations for UI elements.
Used accessibility identifiers to reliably find UI elements.
Ensured app state was reset before each test.


2.Simulator freezes or shows a black screen.

Solution:
Restarted the simulator or reset content and settings.
Quit and reopened Xcode if needed
