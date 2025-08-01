# eCommerce Flutter App (Clean Architecture)

This Flutter project implements an eCommerce app following **Clean Architecture** principles and **TDD** practices.

## 📦 Folder Structure

```plaintext
lib/
├── core/                # Shared error handling, constants, etc.
├── features/         # All product-related layers
│       ├── domain/      # Entities, repositories, use cases
│       ├── data/        # Models, data source, repository implementation
│       └── presentation/# UI (pages, widgets)
test/                    # Unit and widget tests

Features
View all products

View a specific product

Add a new product

Update an existing product

Delete a product

🧱 Clean Architecture Layers
Domain Layer: Business logic (Product, use cases like InsertProduct, etc.)

Data Layer: ProductModel, JSON conversion, repository implementation

Presentation Layer: UI and state management (coming soon)

Core Layer: Shared utilities and error handling

🧪 Testing
Unit tests are included for:

ProductModel JSON serialization

Use cases (Insert, Update, Delete, Get)

Run tests with:

bash
Copy code
flutter test
📚 Tech Stack
Flutter

Dart

Clean Architecture

TDD
