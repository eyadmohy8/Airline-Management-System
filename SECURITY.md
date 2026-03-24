# Security Policy - Airline Management System

## 1. Security by Design
Our project follows the "Security by Design" principle. Security is not an afterthought; it is integrated into every stage of the development lifecycle through our CI/CD pipeline.

## 2. Tools & Technologies (DevSecOps Stack)
We use a multi-layered security approach:
- **TruffleHog:** Scans every commit to prevent accidental leaking of credentials or secrets (API Keys, Firebase tokens).
- **GitHub Actions (CI/CD):** Automates security checks on every push and pull request.
- **Flutter Analyze:** Static Application Security Testing (SAST) to detect code vulnerabilities.
- **NPM Audit:** Scans backend dependencies for known vulnerabilities (CVEs).
- **Docker:** Provides a consistent and isolated build environment to prevent "environmental configuration" attacks.

## 3. Branching & Deployment Strategy
To ensure the integrity of the main codebase:
- **Branch Protection:** No code is pushed directly to `main` or `develop`.
- **Pull Request Policy:** All changes must go through a Pull Request (PR).
- **Status Checks:** The CI/CD pipeline must pass (Green Build) before any code can be merged.

## 4. Secret Management
All sensitive keys (like Firebase API Keys) are stored in **GitHub Secrets**. They are never hardcoded in the source code to prevent unauthorized access.
