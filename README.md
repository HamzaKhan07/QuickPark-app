
# QuickPark 🅿️ ⚡

Finding a vacant spot in a parking lot is a tough ask. So in order to solve this 
problem "QuickPark" is created.

QuickPark is a mobile app which helps users identify the vacant parking slots
in a particular area easily.

The function is divided into two stages:

**1 :- Capturing the Parking Lot and Figuring out the Vacant and Occupied Slots.**

The CCTV camera on one side will capture the whole parking slot area.
It will continously capture the frames of the parking slot and will send it on Cloud.
Over Cloud and special Algorithm is implemented which identifies the
vacant and occupied parking slots and send the data to receivers.
For demonstration, we have created and Python script and given it a parking lot footage.
The program figures out the vacant and occupied parking slots in real time.
The program continously sends the results about the occupacy of parking slots to Cloud, more specifically to Cloud Firestore of Firebase over frequent intervals. The data from the 
cloud is fetched by the Front-end app and the parking status of specified slots
will be updated in Real-time.
  
**2 :- Displaying results in Front-end app**

The Front-end app will continously listen to the changes in the Cloud using StremBuilder in Flutter. 
Once the status of a particular parking slot is updated, it will be marked in UI so that
user get a clear picture of which slots are occupied and which slots are free.



![Logo](https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/logo.png?raw=true)


## 💡 Features

- Beautiful and Elegant UI.
- User Authentication.
- Real-time Parking Slot Updates.
- Fully-Scalable



## 📷 Screenshots
 
<p align="center">
  <img src="https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/cover.png?raw=true">
  <br>
  <br>
  <br>
  <img src="https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/Screen1.png?raw=true">
  <br>
  <br>
  <br>
  <img src="https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/Screen2.png?raw=true">
  <br>
  <br>
  <br>
  <img src="https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/Screen3.png?raw=true">
  <br>
  <br>
  <br>
  <img src="https://github.com/HamzaKhan07/QuickPark-app/blob/main/outputs/Screen4.png?raw=true">
  <br>
  <br>
  <br>
</p>







## 💻 Tech Stack

**Front-End:** Flutter and Dart

**Server:** Firebase


## ✍️ Authors

- [@Hamza Khan](https://www.github.com/HamzaKhan07)
- [@Misba Shaikh](https://www.github.com/HamzaKhan07)
- [@Shubham Wamanacharya](https://www.github.com/ShubhamPW2911)
- [@Namrata Mali](https://www.github.com/Namrata-28)

