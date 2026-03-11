# SureWork Mobile App

> Flutter mobile application for the SureWork decentralized freelancing platform

## Overview

Cross-platform mobile app (iOS & Android) with Web3 wallet integration, real-time messaging, and seamless blockchain interactions. Built with Flutter for native performance and beautiful Material Design UI.

## Features

- **🔐 Account Management**: Email/password with auto wallet generation
- **💼 Gig Marketplace**: Browse, create, and manage freelance gigs
- **💬 Real-Time Chat**: Socket.IO-powered messaging
- **💰 Web3 Wallet**: Direct blockchain integration (no bridge needed)
- **📊 Dashboard**: Track earnings, active gigs, and ratings
- **🔔 Notifications**: Real-time updates on gig status
- **🎨 Material Design 3**: Modern, responsive UI
- **🌓 Dark Mode**: Full light/dark theme support

## Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: go_router
- **Web3**: web3dart
- **HTTP Client**: dio
- **Real-time**: socket_io_client
- **Local Storage**: hive
- **UI**: Material 3

## Screenshots

_Coming soon_

## Installation

### Prerequisites

- Flutter SDK 3.0+
- Android Studio / Xcode
- Dart SDK

### Setup

```bash
# Clone repository
git clone https://github.com/aetechlabs/surework-mobile.git
cd surework-mobile

# Install dependencies
flutter pub get

# Run on emulator/device
flutter run
```

### Configuration

Update `lib/config/app_config.dart` with your backend URL and contract address:

```dart
class AppConfig {
  static const apiBaseUrl = 'http://your-api-url:3000';
  static const escrowContractAddress = '0x...';
  static const rpcUrl = 'https://your-rpc-url';
}
```

## Project Structure

```
lib/
├── config/              # App configuration
│   ├── app_config.dart
│   └── theme.dart
├── models/              # Data models
│   ├── user.dart
│   └── gig.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   ├── gig_provider.dart
│   ├── chat_provider.dart
│   └── wallet_provider.dart
├── screens/             # UI screens
│   ├── auth/
│   ├── home/
│   ├── gigs/
│   ├── profile/
│   └── wallet/
├── services/            # External services
│   └── api_service.dart
└── main.dart            # App entry point
```

## Screens

### ✅ Implemented

- **Splash Screen**: Loading and initialization
- **Login Screen**: Email/password authentication
- **Register Screen**: Full registration with validation
- **Home Screen**: Dashboard with gig feed and statistics
- **Gig List**: Browse and filter gigs

### 🔄 In Progress

- **Gig Detail**: Full gig information and actions
- **Create Gig**: Form to create new gigs
- **Profile**: User profile management
- **Wallet**: Web3 wallet integration

## State Management

Using Provider pattern for:

### AuthProvider

```dart
- login()
- register()
- logout()
- User state
- Authentication status
```

### GigProvider

```dart
- fetchGigs()
- createGig()
- updateGig()
- List of gigs
- Loading states
```

### ChatProvider

```dart
- Socket connection
- sendMessage()
- Real-time updates
```

### WalletProvider

```dart
- Connect wallet
- Sign transactions
- Check balance
- Send transactions
```

## Navigation

Using go_router with authentication-aware redirects:

```dart
Routes:
/ → Splash
/login → Login Screen
/register → Register Screen
/home → Home Dashboard
/gigs → Gig List
/gigs/:id → Gig Detail
/gigs/create → Create Gig
/profile → User Profile
/wallet → Wallet Screen
```

## API Integration

### HTTP Requests

```dart
// Login
POST /api/auth/login
{
  "email": "user@example.com",
  "password": "password"
}

// Create Gig
POST /api/gigs
Authorization: Bearer <token>
{
  "title": "Build a website",
  "description": "...",
  "amount": 1000
}
```

### WebSocket Events

```dart
// Join gig chat
socket.emit('join:gig', {'gigId': '123'});

// Send message
socket.emit('message:send', {
  'gigId': '123',
  'content': 'Hello'
});

// Receive messages
socket.on('message:new', (data) {
  // Handle new message
});
```

## Web3 Integration

### Wallet Connection

```dart
// Generate wallet from private key
final credentials = EthPrivateKey.fromHex(privateKey);

// Get wallet address
final address = await credentials.extractAddress();

// Sign transaction
final signed = await client.signTransaction(
  credentials,
  transaction,
);
```

### Smart Contract Interaction

```dart
// Call contract function
final result = await contract.call(
  'createGig',
  [
    client,
    freelancer,
    amount,
    token
  ],
);

// Listen to events
contract.events('GigCreated').listen((event) {
  // Handle event
});
```

## Theming

Material 3 with custom color schemes:

```dart
// Light Theme
primaryColor: #6200EE
secondaryColor: #03DAC6

// Dark Theme
primaryColor: #BB86FC
secondaryColor: #03DAC6
```

## Build & Release

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS

```bash
# Build IPA
flutter build ipa --release
```

### Web

```bash
# Build for web
flutter build web --release
```

## Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --driver=test_driver/integration_test.dart \
              --target=integration_test/app_test.dart
```

## Features Roadmap

- [x] Authentication
- [x] Home Dashboard
- [x] Gig Browsing
- [ ] Gig Detail View
- [ ] Create Gig Flow
- [ ] Wallet Integration
- [ ] WalletConnect Support
- [ ] Push Notifications
- [ ] File Upload
- [ ] In-App Chat
- [ ] Review System
- [ ] Dispute Resolution UI
- [ ] Transaction History
- [ ] Multi-language Support

## Performance

- Fast startup time: <2s
- Smooth animations: 60fps
- Small app size: <15MB
- Low memory footprint

## Dependencies

Key packages:

```yaml
provider: ^6.1.1          # State management
go_router: ^13.0.0        # Navigation
web3dart: ^2.7.1          # Blockchain
dio: ^5.4.0               # HTTP client
socket_io_client: ^2.0.3  # Real-time
hive: ^2.2.3              # Local storage
```

## Known Issues

- None currently

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## License

MIT

## Related Repositories

- **Smart Contracts**: [surework-contracts](https://github.com/aetechlabs/surework-contracts)
- **Backend API**: [surework-backend](https://github.com/aetechlabs/surework-backend)

## Support

For issues and questions:
- Open an issue in this repository
- Contact: dev@aetechlabs.com

---

Built with ❤️ by [AeTechLabs](https://github.com/aetechlabs)
