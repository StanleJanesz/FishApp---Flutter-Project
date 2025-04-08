# 🎣 Fishing Tracker App

**Final project documentation for the course:** _Programowanie aplikacji mobilnych w technologii Flutter_

A mobile app (iOS & Android) designed to help users log their fishing activity and analyze fishing methods or locations. The core functionality allows users to save catches, explore statistics, and associate each catch with weather data and custom metadata such as bait type or location.

---

## 📱 Features

- 📍 Save catch history with bait and weather details
- 📊 View statistics for different fishing spots or methods
- ➕ Add custom fish types, bait, and fishing locations
- 🧭 Use current geolocation or select locations manually
- 🗂 Filter and group catch statistics dynamically

---

## 📌 Optional Requirements Implemented

- ✅ Multi-step forms with validation  
- ✅ Animations  
- ✅ Usage of Flutter packages for native platform features  
- ✅ Offline data storage (local persistence)

---

## 🚦 How to Use

To explore the app and see statistics, you must first:

1. Add new **locations**, **bait types**, or **fish types** via the **More Page**
2. Add a new fish entry through the **Add Fish** button

---

## 🧭 Pages Overview

### 📍 Locations Page

- Displays a list of saved fishing spots
- Tapping a location shows a scrollable history of catches from that spot
- Uses geolocation for location-based features — ensure permissions are enabled

### 👤 User Page

- Displays an in-progress user profile (profile picture + stats cards)
- Tapping on a stat card reveals detailed information

### 📈 Statistics Page

- Choose between different views (e.g. **MAX size**, **Count**)
- Add filters using the **filter selection list**
- Group data by custom parameters with a **grouping dropdown**

### ➕ More Page

Used to add:
- New fish types
- New bait types
- New fishing spots (via current location or manual input)

### 🐟 Add Fish Page

- Accessed via the **plus (+)** button
- Form to add a new catch with:
  - Fish type
  - Bait
  - Size (manually entered or selected via scrollable widget)
- Unselected fields are saved as "Unknown"

---

## 🗃️ Database Schema
![image](https://github.com/user-attachments/assets/2a6291e8-0c99-4c38-9fa3-fae05580ee53)


---
