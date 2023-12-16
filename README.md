<h1 align="center">Tasks App</h1>

# Overview

This is The Tasks App Assessment Repository.  
<br>

# Tasks Done  

- <span style="color:green;">[✔]</span> Load Tasks
- <span style="color:green;">[✔]</span> Load Tasks with pagination
- <span style="color:green;">[✔]</span> Refresh List   
- <span style="color:green;">[✔]</span> Cache Tasks locally for offline access.   
- <span style="color:green;">[✔]</span> option to mark the task as completed.
- <span style="color:green;">[✔]</span> Add Task
- <span style="color:green;">[✔]</span> Delete Task
- <span style="color:green;">[✔]</span> Update Task <br>
   *Note: Attempting to update a task that doesn't exist in the JSON_PLACEHOLDER database will result in a failure.*
<br>

## Additional Features

- <span style="color:red;">[x]</span> Add animation when add new note
- <span style="color:red;">[x]</span> Add animation when update a note
- <span style="color:red;">[x]</span> Add animation when delete a note
- <span style="color:red;">[x]</span> Add animation when paginate  
<br>

<br>

![Alt Text](https://raw.githubusercontent.com/a3bd2lra7man/sadad_flutter_sdk/main/ezgif.com-optimize.gif)

<br>

# Code Organization

The codebase is structured using the ["Design by Feature"](https://codeopinion.com/organizing-code-by-feature-using-vertical-slices/) approach.  
Each Feature is broken down into smaller features within that feature such add,update,delete, list.  

Each feature may have all or some of the following folders:

- **constants:** Such as API URLs.
- **services:** Manages API calls.
- **repositories:** Handles cache storage.
- **ui:** Designs and implements the user interface.
- **view_models:** state management (using the provider package).
  
there is no circular dependencies between modules and modules interacts with each other using callbacks.  
<br>

# Run the App Locally

First ensure that you have flutter installed with dart 3.0.0 or above by running this command  

   ```bash
   flutter --version
   ```
if not please consider upgrade to the latest flutter version by running

   ```bash
   flutter upgrade
   ```
then follow these steps:

1. **Clone the Repository:**

   ```bash
   git clone TODO
   ```  

2. **Navigate to the Project Directory:**

   ```bash
   cd TODD
   ```  


3. **Install Dependencies:**

   ```bash
   flutter pub get
   ```  

4. **Ensure there is android or ios device connected by running**

   ```bash
   flutter devices
   ```  

5. **Run the app**

   ```bash
   flutter run -d "device name"
   ```  
   ***Replace "device name" with the actual device identifier***

6. **Or else Build an APK**

   ```bash
   flutter build apk --release
   cd build/app/outputs/flutter-apk/
   ```

Inside the flutter-apk folder, you will find the app-release.apk file.  
This file is the executable APK that can be installed on Android devices.  
Transfer the app-release.apk file to your Android device, then open the file to install the application.

<br>

# Tests 

unit tests are also included   
there are no integration tests.   

to run the tests do the following 

1. **Ensure that you are in the Project Directory:**

2. **Run this command**

   ```bash
   flutter test
   ```  