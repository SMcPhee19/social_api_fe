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

This repository contains the Flutter frontend developed as a proof of concept for the social media messaging application backend created by Mountain Lark Software for Drum Corps International. While not intended for production use, this frontend serves as a functional interface to demonstrate and test the backend’s capabilities.

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

---

### Why This Version Exists

This frontend is not designed for end-user deployment but instead acts as a lightweight client for testing backend functionality and showcasing the application's potential.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To get started with the **Flutter frontend**, follow the steps below to set up the project on your local machine. This frontend is designed to integrate with the backend REST API, so ensure the backend is running before proceeding.

### Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK**: [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: (included with Flutter)
- **Xcode** (for iOS development) and/or **Adroid Studio** (for Android development)
- A code editor, such as **VS Code** or **IntelliJ IDEA**
- Backend API URL and credentials for integration

Verify you Flutter installation with:
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

##### Key Features
1. **Input Fields**:
  - **Email Field**
    - Accepts email input with an appropriate keyboard layout (`TextInputType.emailAddress`).
    - Placeholder label text: "Email"
  - **Password Field**:
    - Accepts password input with obscured text for security (`obscureText: true`).
    - Placeholder label text: "Password".
    - Ensures proper field validation and user feedback.
2. **Action Button**:
  - **Login Button**:
    - Dynamically enabled or disabled based on the loading state.
    - Initiates the login process when pressed, validating user input and sending a login request to the backend.
  - Displays a loading spinner (`CircularProgressIndicator`) during the authentication process.
3. **Error Handling**:
  - Displays a user-friendly error messages in red text below the form when:
    - Input field are left empty.
    - Email or password is invalid.
    - A network or server error occurs.
  - Examples:
    - "Please fill out all fields."
    - "Invalid email or password."
    - "An error occured. Please try again." 
4. **Platform-Aware API Handling**:
  - Dynamically determines the backend API URL based on the platform.
    - For Android Emulators: `http://10.0.2.2:3000/api/v0/login`.
    - For iOS or Web: `http://localhost:3000/api/v0/login`.
5. **Secure Data Storage**:
    - Uses `FlutterSecureStorage` to securely store authentication tokens and user IDs after a successful login.

---

#### Layout Overview
1. **Header**:
   - Title: "Login" displayed in the app bar.
2. **Form Elements**:
   - Email input field.
   - Password input field.
   - Login button or loading spinner.
3. **Feedback**:
   - Error messages displayed below the button if applicable.
4. **Navigation**:
   - Redirects users to the Conversations Index Screen (`/conversations`) upon successful login.

---

#### User Flow:
1. **Input Validation**:
   - The login button remains active only when both fields are filled.
   - Error appear inline with the input is invalid.
2. **Authentication Request**:
   - Sends a `POST` request to the backend API with the provided email and password in JSON format.
3. **Successful Login**:
   - Stores the token and user ID securely.
   - Navigates the user to the next screen.
4. **Failed Login**:
   - Displays an approriate error message.

---

#### Flutter Widgets Used
1. **Input Fields**: `TextField`
2. **Buttons**: `ElevatedButton`
3. **Loading Indicator**: `CircularProgressIndicator`
4. **Error Messages**: `Text`
5. **Secure Storage**: `FlutterSecureStorage`

---

#### Mockup:

<img src="https://private-user-images.githubusercontent.com/120869196/407537687-524316a2-34b7-45ec-92c3-f6262d6c1a68.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDY5MzEsIm5iZiI6MTczODEwNjYzMSwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM3Njg3LTUyNDMxNmEyLTM0YjctNDVlYy05MmMzLWY2MjYyZDZjMWE2OC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzIzNTFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YzdkZmMyMTQxMTcxYzRiYjQ1M2FmYTUyZDdmMGI1ZTc1ZDI4NTEyYTRkYmY5YTQ1ZTZlZjM2NGUzNWJmNzE0JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.u727SiZEflFCth6WJr_YnzNGrq8EKOD0jGBBWmUUPvM" alt="Login Screen Mockup" width="300">



---

### Conversation Screens

The conversation screens are designed to serve as a **proof of concept** and facilitate **internal testing** for the backend's messaging capabilities. These screens provide a simple and functional interface to validate features such as participant display, message retrieval and real-time updates.

---

### Conversation Index Screen

The **Conversation Index Screen** lists all conversations associated witht he test user. Its primary purpose is to test the backend's conversation indexing and navigation.

#### Key Features:
  1. **Conversation list**:
     - Displays a list of conversations fetched from the backend.
     - Shows:
       - Names of participants (excluding the test user).
       - Conversation titles.
         - This will become a preview of the most recently sent message(see roadmap section)
     - Conversations are presented as clickable cards for testing navigation.
  2. **Backend Validation**:
     - Confirms the backend returns accurate participant and title data for each conversation.
     - Tests API integration with authenticatd requests.
  3. **Navigation**:
     - Clicking on a conversation card navigates to the **Conversation Detail Screen**, passing key data such as the conversation ID , title, and participants.
  4. **Secure Access**:
     - Fetches the test user's authentication token and ID securely from `FlutterSecureStorage`.
    
#### UI Design:
  - **Card Layout**:
    - Simplistic design to emphasize functionality over asthetics
    - `CircleAvatar` displays the frist letter of the participant's name for quick identification
  - **Loading State**:
    - Displays a `CircularProgressIndicator` to confirm API request timing and backend readiness.

---
### Conversation Detail Screen

The **Conversation Detail Screen** tests backend message retrieval, WebSocket functionality, and real-time messaging features.

#### Key Features:

1. **Message Display**:
   - Retrieves and displays messages for the selected conversation.
   - Differentiates between messages sent by the test user and other participants:
     - User messages are aligned to the rigth (blue background).
     - Other messages are aligned to the left (gray background).
   - Displays timestamps to verify backend message metadata.
2. **Real-Time Updates**:
   - Uses **ActionCable** to test WebSocket communication for real-time message updates.
3. **Message Sending**:
   - Includes a simple input feild and send button for testing `POST` requests to the backend.
   - Utilizes `client_message_id` (UUID) to verify message deduplication and confirmation.
4. **Backend Validation**:
   - Confirms accurate retrieval of participant data and secure handling of authentication tokens.
   - Validates backend logic for message storage, ordering, and metadata.
5. **Scroll Management**:
   - Tests automatic scrolling to new messages when sent or recieved.

#### UI Design:
- **Message Bubbles**:
  - Minimalist design with distinct colors for user and participant messages.
  - Focuses on clear readability for testing purposes.
- **Input Field**:
  - Simplified input field with placeholder text ("Type a message...") for testing message entry and submission.

---

#### Interaction Flow for Testing:

1. **Load Conversations**:
   - Open **Conversation Index Screen** to test the `/conversations` endpoint.
2. **Select a Conversation**:
   - Click a conversation card to navigate to the **Conversation Detail Screen** and test `/conversations/{id}`.
3. **Send and Receive Messages**:
   - Test the message input to send POST requests.
   - Validate real-time updates via WebSocket.

--- 

#### Purpose of These Screens
- **Proof of Concept**:
  - Demonstrates basic messaging functionality and backend integration.
- **Internal Testing**:
  - Allows developers to validate backend endpoints, WebSocket communication, and data accuracy.
- **Not for Production**:
  - These screens are not intended for end-user interaction or deployment

---

#### Technical Stack:
- **API Integration**: `http` package for RESTful calls.
- **Real-Time Communication**: `ActionCable` for WebSocket functionality.
- **Secure Data Storage**: `FlutterSecureStorage` for tokens and user IDs.

---

#### Mockups:

<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="https://private-user-images.githubusercontent.com/120869196/407537407-734e3f7b-11e3-41c3-9a6c-3a9fe705e190.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDY4MzYsIm5iZiI6MTczODEwNjUzNiwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM3NDA3LTczNGUzZjdiLTExZTMtNDFjMy05YTZjLTNhOWZlNzA1ZTE5MC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzIyMTZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mMjA1YTJkOTQ5ZjBjZTc4MmU2MmE2NTZjMmUwMDZjMGJjZWFiYWIwNTdlZGM0MWExNjM5ZGFhMzAzZjlmMzI5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.xSYaSFRivrySaetuXh_pMlYGdcSBIjLYN-0PiowJQYo" alt="Image 1" width="300">
  <img src="https://private-user-images.githubusercontent.com/120869196/407538494-0024919b-bd4d-4d35-b38e-6c704ab7311a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzgxMDcyMDAsIm5iZiI6MTczODEwNjkwMCwicGF0aCI6Ii8xMjA4NjkxOTYvNDA3NTM4NDk0LTAwMjQ5MTliLWJkNGQtNGQzNS1iMzhlLTZjNzA0YWI3MzExYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMTI4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDEyOFQyMzI4MjBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jMmY1MjBjOGM1OWQ2YzA0MjMxMTJjMGFlMjM1YWExNTg3NmYyMzRhZDQ0ZjgxZWYwODcwYzUxNGFlY2RhOTRhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.yG0tNYw1_HDypaZDv5PLf-j0NhkE8QtgsWZ7YTCMNJw" alt="Image 2" width="300">
</div>


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- State Management -->
## State Management

This application uses **Flutter's** `StatefulWidget` for local state management, tailored to the requirements of the proof-of-concept frontend. The state is maintained and updated within the individual screens to simplify logic and ensure clear separation of concerns.

### Key Features of State Management

1. **Login Screen**:
   - Tracks:
     - Email and password input `TextEditingController`.
     - Loading status (`_isLoading`) to toggle between the login button and progress indicator.
     - Error messages(`_errorMessage`) for input validation or API errors.
   - Updates state dynamically as the user interacts with the login form or receives a response from the backend.
2. **Conversation Index Screen**:
   - Tracks:
     - List of conversations (`_conversations`) is fetched from the backend.
     - Loading status (`_isLoading`) to display a loading spinner while fetching the data.
     - Current user ID (`_currentUserId`),securely retrieved from `FlutterSecureStorage`.
   - Dynamically updates the conversation list when data is fetched successfully.
3. **Conversation Detail Screen**:
   - Tracks:
     - List of messages (`_messages`) in the conversation.
     - Participants (`_participants`) and thier associated metadata.
     - Connection status (`_isConnected`) for WebSocket integration.
     - Message input field state using `TextEditingController`.
   - Updates state in response to:
     - Real-time messages received via WebSocket.
     - New messages sent by the user.
     - API responses for message retrieval.

---

#### Integration with Backend and WebSocket

- **ActionCable for Real-Time Messaging**:
  - State is updated instantly when new messages are received via WebSocket.
  - The `_messages` list is appended dynamically, and the UI reflects changes automatically through `_setState`.
- **Secure Data Retreval**:
  - The app uses `FlutterSecureStorage` to retrieve and store authentication tokens and user IDs securely.
  - These tokens are required for API calls, and ther absence leads to controlled state transitions (e.g., disabling UI elements).

---

#### Benefits of Current State Management:

- **Simplicity**: The use of `StatefulWidget` keeps state management straightforward for this proof-of-concept application.
- **Efficiency**: Local state updates ensure that only relevant parts of the UI are rebuilt, maintaining performance.
- **Flexibility**: Each screen independently manages its state making debuing and testing easier.

--- 

#### Considerations for Scaling

If this frontend were to evolve into a production-ready application:
- **State Management Solutions**: Libraries like `Provider`, `Riverpod`, or `Bloc` could be adopted for scalable and reactive state management.
- **Global State Handling**: Shared state (e.g., authentication data, user profiles) could be managed centrally for better coordiation across screens.
- **Asynchronous Data Handling**: Tools like `StreamBuilder` or `FutureBuilder` could be integrated for smoother real-time and asynchronous updates.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- API Integration -->
## API Integration

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Technical Solutions -->
## Technical Solutions

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

Additional features, functionality, and potential refactors:
* Preview the most recent message in each conversation on the conversations index screen
* Push & Lock screen notifications
* Adaptive keyboard appearance and device orientation
* Typing indicator
* Conversations are sorted by the most recent activity
* Toggle to show/hide the password

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
