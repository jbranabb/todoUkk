# TodoUkk
**TodoUkk** is a cross-platform mobile todo management app built with **Flutter**, using **Firebase** for backend services and **BLoC** for state management. It’s designed to help users manage their daily tasks, keep track of their note history, and stay productive — all in a sleek dark/light themed interface.

---
## 🚀 Overview

This document provides a high-level overview of TodoUkk, a modern todo-list app that helps users:
- Add, update, and delete tasks
- View past task history
- Search through todos efficiently
- Switch between light and dark modes

> 📌 For setup instructions, see [Getting Started](#-how-to-run).  
> 📌 For system design, see [Architecture](#-architecture).  
> 📌 For feature list, see [Core Features](#-features).

---

## 📱 Features

- 📝 **Todo CRUD**  
  Add new tasks, edit existing ones, or delete them with ease.

- 🕓 **History Tracking**  
  View a history of previously entered notes — perfect for reflection or tracking progress.

- 🔍 **Smart Search**  
  Find any note quickly using the built-in search functionality.

- 🌙 **Dark/Light Mode Toggle**  
  Personalize the app appearance with a switchable dark/light theme.

- 🔐 **Firebase Authentication**  
  Secure login and user session management using Firebase.

---

## 🧩 Architecture

TodoUkk follows best practices in Flutter development:

| Layer           | Description                              |
|----------------|------------------------------------------|
| **UI**         | Built with Flutter widgets and layouts   |
| **State Mgmt** | BLoC Pattern (flutter_bloc)              |
| **Backend**    | Firebase (Auth + RealTimeDatabase)       |
| **Local**      | SharedPreferences for theme preferences  |
| **Structure**  | Feature-based modular file organization  |

---

## ⚙️ Tech Stack

| Tech           | Role                                      |
|----------------|-------------------------------------------|
| Flutter        | Frontend framework                        |
| Dart           | Programming language                      |
| Firebase       | Backend (Auth & RealTimeDatabase)         |
| flutter_bloc   | State management                          |
| SharedPreferences | Local theme persistence                |

---

## 🧑‍💻 Core Features

| Feature         | Description                                               |
|-----------------|-----------------------------------------------------------|
| Todo Page       | Add, edit, delete daily notes                             |
| History Page    | View previous task entries                                |
| Search Bar      | Find tasks by keywords instantly                          |
| Dark Mode       | Toggle between light and dark UI                          |
| Login Page      | Firebase-authenticated user login                         |

---

## 🗺️ User Journey

1. User logs in through Firebase Auth.
2. Lands on the main Todo page.
3. Adds a new task or edits an existing one.
4. Navigates to History to view past notes.
5. Uses the Search bar to filter through tasks.
6. Switches theme between dark and light via settings.

---

## 🛠️ How to Run

```bash
# Clone the repository
git clone https://github.com/your-username/TodoUkk.git

# Navigate to the project folder
cd TodoUkk

# Get the Flutter packages
flutter pub get

# Run the app
flutter run
