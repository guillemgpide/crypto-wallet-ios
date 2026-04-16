# iOS Crypto Wallet & Tracker

[![Language](https://img.shields.io/badge/Language-Swift_5-orange.svg)](#)
[![Platform](https://img.shields.io/badge/Platform-iOS_15+-lightgrey.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A native iOS application built with Swift and UIKit that allows users to track cryptocurrency assets, authenticate securely, and manage their portfolio. 

## 🚀 Key Features

* **Secure Authentication:** User onboarding, login, and session management integrated with Firebase Authentication.
* **Live Market Data:** Fetches and parses real-time cryptocurrency data from a public REST API.
* **Native Device Integrations:** Utilizes iOS native SDKs for enhanced user experience.
* **Custom UI/UX:** Programmatic and Storyboard-based UI with custom cells and responsive layouts tailored for modern iPhones.

## 🛠️ Tech Stack

* **Language:** Swift
* **Framework:** UIKit
* **Architecture:** MVC (Model-View-Controller)
* **Backend/BaaS:** Firebase (Auth)
* **Networking:** `URLSession` for API calls

## ⚙️ Quick Start

To run this project locally, follow these steps:

**1. Clone the repository**

    git clone https://github.com/yourusername/crypto-wallet-ios.git
    cd crypto-wallet-ios/src

**2. Open the project**
Open the `eric.faya<_guillem.gil<_jofre.tura.xcodeproj` file in Xcode (located inside the `src/` directory).

**3. Configure Firebase**
*Important:* Add your own `GoogleService-Info.plist` file to the root of the Xcode project to enable Firebase services.

**4. Build and Run**
Select a simulator (iPhone 14 or newer recommended) and hit `Cmd + R` to build and run the application.

## 📖 Background & Documentation

This application was developed to demonstrate proficiency in iOS development, specifically focusing on third-party API consumption, BaaS integration, and native SDK utilization. Initial UI mockups, architecture reports, and project specifications can be found in the [`docs/`](./docs) directory.