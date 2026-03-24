# DevOps & Secret Management Guide

## Externalizing Configurations

This project follows the best practice of externalizing sensitive configurations from the source code.

### Local Development
1.  **Environment Variables**: 
    - Copy `.env.example` to `.env` in the root directory for the Flutter app.
    - Copy `backend/.env.example` to `backend/.env` for the Node.js server.
2.  **Firebase Keys**: 
    - Place your `serviceAccountKey.json` in the `backend/` directory.
    - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to their respective directories.

### GitHub Secrets for CI/CD
In your GitHub Repository, go to **Settings > Secrets and variables > Actions** and add the following secrets for your automated build/test pipelines:

- `API_BASE_URL`: The production API endpoint.
- `SSL_FINGERPRINT_1`: The SHA-256 fingerprint for SSL pinning.
- `FIREBASE_SERVICE_ACCOUNT`: The JSON content of your service account key.

## Production Builds (Code Hardening)

To protect the app logic from reverse engineering, always use the provided obfuscation script for release builds:

```bash
# For Android APK
./scripts/build_obfuscated.sh android

# For iOS IPA
./scripts/build_obfuscated.sh ios
```

The debug info (symbols) needed to de-obfuscate crash logs will be saved to `build/debug-info`.
