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
    <li><a href="#testing">Testing</a></li>
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
## Testing

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- UI Design -->
## UI Design

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- State Management -->
## State Management

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
