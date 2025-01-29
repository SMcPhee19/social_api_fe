<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url] -->

<!-- PROJECT LOGO -->
<br />

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#getting-started">Getting Started</a></li>
    <!--<li><a href="#testing">Testing</a></li>-->
    <li><a href="#ui-design">UI Design</a></li>
    <li><a href="#state-management">State Management</a></li>
    <li><a href="#api-integration">API Integration</a></li>
    <li><a href="#technical-solutions">Technical Solutions</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This Flutter frontend serves as a proof of concept for validating the backend functionality of a social media messaging application developed by Mountain Lark Software for Drum Corps International. It enables secure API testing, real-time messaging validation, and backend performance monitoring.

### Key Features:
- **Testing Backend Functionality:** Provides an interface for validating the backend API's real-time messaging, authentication, and other features.
- **Proof of Concept:** Demonstrates the integration of a Flutter frontend with the backend REST API.
- **Cross-Platform Compatibility:** Ensures basic compatibility across iOS and Android devices using Flutter.
- **Developer-Friendly UI:** Focused on providing a simple, clear interface for testing and debugging backend functionality.

---

### Built With
[![Dart][Dart]][Dart-url] [![Flutter][Flutter]][Flutter-url]

#### Core Dependencies
- **[web_socket_channel](https://pub.dev/packages/web_socket_channel):** Enables real-time messaging through WebSocket connections.
- **[http](https://pub.dev/packages/http):** Simplifies making HTTP requests to the backend API.
- **[provider](https://pub.dev/packages/provider):** A lightweight and efficient solution for state management.
- **[socket_io_client](https://pub.dev/packages/socket_io_client):** Provides support for Socket.IO-based communication.
- **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage):** Ensures secure storage of sensitive data like authentication tokens.
- **[uuid](https://pub.dev/packages/uuid):** Generates unique identifiers for various application needs.
- **[action_cable](https://pub.dev/packages/action_cable):** Integrates seamlessly with Rails' ActionCable for real-time WebSocket updates.

### Development Tools
- **[flutter_test](https://pub.dev/packages/flutter_test):** Provides a robust framework for testing Flutter applications.
- **[flutter_lints](https://pub.dev/packages/flutter_lints):** Offers recommended linting rules to enforce clean and consistent coding practices.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To get started with the **Flutter frontend**, follow the steps below to set up the project on your local machine. This frontend is designed to integrate with the backend REST API, so ensure the backend is running before proceeding.

### Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK**: [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: (included with Flutter)
- **Xcode** (for iOS development) and/or **Android Studio** (for Android development)
- A code editor, such as **VS Code** or **IntelliJ IDEA**
- Backend API URL and credentials for integration

Verify your Flutter installation with:
```bash
flutter doctor
```

#### Installation
1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-folder>
2. **Install Dependencies**: Run the following command to fetch any necessary Flutter packages:
   ```bash
   flutter pub get
   ```
3. **Run the Application**:
   - For **iOS**:
   ```bash
   flutter run -d ios
   ```
   - For **Android**:
   ```bash
   flutter run -d android
   ```
   - For **Web** (if applicable):
   ```bash
   flutter run -d web
   ```
---
**Troubleshooting**
If you encounter issues:
  - Ensure the backend is running and accessible
  - Verify the Flutter SDK and dependencies are up to date
    ```bash
    flutter upgrade
    ```
  - Check the logs for detailed error messages:
    ```bash
    flutter logs
    ```



<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Testing -->
<!--## Testing

<p align="right">(<a href="#readme-top">back to top</a>)</p>-->

<!-- UI Design -->
## UI Design

### Login Screen
The login screen is the first interaction users will have with the application. It is designed to be simple, intuitive, and aligned with the asthetic of the app to make testing functionality easy.

#### Key Features:
- **Email & Password Input:**
  - `TextField` for user input.
  - Email field has appropriate keyboard type (`TextInputType.emailAddress`).
  - Password field is obscured (`obscureText: true`).

- **Login Button:**
  - Enabled only when fields are filled.
  - Displays a loading spinner (`CircularProgressIndicator`) while processing.

- **Error Handling:**
  - Displays errors such as:
    - `"Please fill out all fields."`
    - `"Invalid email or password."`
    - `"An error occurred. Please try again."`

- **Secure Data Storage:**
  - Uses `FlutterSecureStorage` to store authentication tokens.

#### User Flow:
1. User enters email & password → Sends `POST /login` request.
2. If successful → Token stored → Redirects to **Conversations Index**.
3. If failed → Displays error message.


---

#### Mockup:

<img src="https://private-user-images.githubusercontent.com/120869196/407537687-524316a2-34b7-45ec-92c3-f6262d6c1a68.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDY5MzEsIm5iZiI6MTczODEwNjYzMSwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM3Njg3LTUyNDMxNmEyLTM0YjctNDVlYy05MmMzLWY2MjYyZDZjMWE2OC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzIzNTFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YzdkZmMyMTQxMTcxYzRiYjQ1M2FmYTUyZDdmMGI1ZTc1ZDI4NTEyYTRkYmY5YTQ1ZTZlZjM2NGUzNWJmNzE0JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.u727SiZEflFCth6WJr_YnzNGrq8EKOD0jGBBWmUUPvM" alt="Login Screen Mockup" width="300">



---

### Conversation Screens

The conversation screens are designed to serve as a **proof of concept** and facilitate **internal testing** for the backend's messaging capabilities. These screens provide a simple and functional interface to validate features such as participant display, message retrieval and real-time updates.

---

### Conversation Index Screen

The **Conversation Index Screen** lists all conversations associated witht he test user. Its primary purpose is to test the backend's conversation indexing and navigation.

#### Features:
- **Displays List of Conversations:**
  - Names of participants (excluding the logged-in user).
  - Titles of conversations.
- **Navigates to Conversation Details:**
  - Clicking a conversation loads messages from the backend.
- **Validates API Responses:**
  - Confirms `/conversations` endpoint returns accurate data.
    
#### UI Design:
  - **Card Layout**:
    - Simplistic design to emphasize functionality over asthetics
    - `CircleAvatar` displays the frist letter of the participant's name for quick identification
  - **Loading State**:
    - Displays a `CircularProgressIndicator` to confirm API request timing and backend readiness.

---
### Conversation Detail Screen

The **Conversation Detail Screen** tests backend message retrieval, WebSocket functionality, and real-time messaging features.

#### Features:
- **Real-Time Messaging:**
  - Uses **ActionCable WebSocket** for instant message updates.
- **Sends Messages:**
  - Messages sent via `POST /conversations/{id}/messages`.
  - Uses **UUID** (`client_message_id`) for deduplication.
- **Scrolls to Latest Message:**
  - Automatically scrolls when a new message is received.

#### UI Design:
- **Message Bubbles**:
  - Minimalist design with distinct colors for user and participant messages.
  - Focuses on clear readability for testing purposes.
- **Input Field**:
  - Simplified input field with placeholder text ("Type a message...") for testing message entry and submission.

---

#### Mockups:

<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="https://private-user-images.githubusercontent.com/120869196/407537407-734e3f7b-11e3-41c3-9a6c-3a9fe705e190.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDY4MzYsIm5iZiI6MTczODEwNjUzNiwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM3NDA3LTczNGUzZjdiLTExZTMtNDFjMy05YTZjLTNhOWZlNzA1ZTE5MC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzIyMTZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mMjA1YTJkOTQ5ZjBjZTc4MmU2MmE2NTZjMmUwMDZjMGJjZWFiYWIwNTdlZGM0MWExNjM5ZGFhMzAzZjlmMzI5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.xSYaSFRivrySaetuXh_pMlYGdcSBIjLYN-0PiowJQYo" alt="Image 1" width="300">
  <img src="https://private-user-images.githubusercontent.com/120869196/407538494-0024919b-bd4d-4d35-b38e-6c704ab7311a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDcyMDAsIm5iZiI6MTczODEwNjkwMCwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM4NDk0LTAwMjQ5MTliLWJkNGQtNGQzNS1iMzhlLTZjNzA0YWI3MzExYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzI4MjBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jMmY1MjBjOGM1OWQ2YzA0MjMxMTJjMGFlMjM1YWExNTg3NmYyMzRhZDQ0ZjgxZWYwODcwYzUxNGFlY2RhOTRhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.yG0tNYw1_HDypaZDv5PLf-j0NhkE8QtgsWZ7YTCMNJw" alt="Image 2" width="300">
</div>


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- State Management -->
## State Management

The app uses `StatefulWidgets` for localized state management.

### Key State Variables:

- **Authentication:**
  - Securely retrieved and stored using `FlutterSecureStorage`.

- **Conversations:**
  - `_conversations`: Stores fetched conversations.
  - `_participants`: Stores user details.

- **Messages:**
  - `_messages`: Stores conversation messages.
  - `_isConnected`: Tracks WebSocket status.

### Future Considerations:
For scalability, **Provider** or **Riverpod** could be integrated.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- API Integration -->
## API Integration

This Flutter frontend interacts with the backend API for authentication, conversation management, and real-time messaging.

### Key Features:

- **Platform-Aware API Requests:**
  - **Android** → `http://10.0.2.2:3000`
  - **iOS/Web** → `http://localhost:3000`

- **Endpoints Used:**
  - `POST /login` → Authenticates users.
  - `GET /conversations` → Fetches conversations.
  - `GET /conversations/{id}` → Retrieves messages.
  - `POST /conversations/{id}/messages` → Sends messages.

- **WebSocket Messaging:**
  - Uses **ActionCable** for real-time updates.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Technical Solutions -->
## Technical Solutions

The frontend incorporates key technical solutions to optimize testing and performance.

### Key Implementations:

- **Token-Based Authentication:**
  - `FlutterSecureStorage` securely stores tokens for API requests.

- **Real-Time Messaging:**
  - WebSocket integration via **ActionCable** for instant updates.
  - `client_message_id` (**UUID**) prevents duplicate messages.

- **Scroll Management:**
  - Automatically scrolls to new messages.

- **Error Handling:**
  - Displays meaningful errors for invalid credentials or connection failures.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

### Additional features, functionality, and potential refactors:
* Preview the most recent message in each conversation on the conversations index screen
* Push & Lock screen notifications
* Adaptive keyboard appearance and device orientation handling
* Typing indicator
* Conversations should be sorted by the most recent activity
* Toggle to show/hide the password
* Stock message for when a user has no active conversations and a prompt to start one
* Be able to start a conversation with any active user
* Caching for frequently accessed data such as conversations or user information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!--[contributors-shield]: https://img.shields.io/github/contributors/<repo>/frontend.svg?style=for-the-badge
[contributors-url]: https://github.com/<repo>/frontend/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/<repo>/frontend.svg?style=for-the-badge
[forks-url]: https://github.com/<repo>/frontend/network/members
[stars-shield]: https://img.shields.io/github/stars/<repo>/frontend.svg?style=for-the-badge
[stars-url]: https://github.com/<repo>/frontend/stargazers
[issues-shield]: https://img.shields.io/github/issues/<repo>/frontend.svg?style=for-the-badge
[issues-url]: https://github.com/<repo>/frontend/issues -->
[license-shield]: https://img.shields.io/github/license/<repo>/frontend.svg?style=for-the-badge
[license-url]: https://github.com/<repo>/frontend/blob/main/LICENSE.txt
[flutter]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white
[flutter-url]: https://flutter.dev/
[dart]: https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white
[dart-url]: https://dart.dev/
[github-actions]: https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white
[gha-url]: https://github.com/features/actions
