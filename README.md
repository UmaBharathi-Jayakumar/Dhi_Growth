# DhiGrowth - Flutter E-Commerce App

A complete, production-quality frontend-only e-commerce application built with Flutter. This project demonstrates modern UI/UX design, clean architecture, and efficient state management.

## Flutter Version
- Developed using Flutter 3.x (Latest Stable)
- Dart SDK with Null Safety enabled.

## Packages Used
- **provider**: ^6.0.0 (Chosen for State Management. It is lightweight, built into the Flutter ecosystem, and perfect for managing application-level state like Cart, Products, and Orders without adding unnecessary boilerplate or complexity).
- **cached_network_image**: ^3.2.0 (For performant image loading and caching, with placeholder support).
- **google_fonts**: ^6.0.0 (For consistent, high-quality typography using Poppins/Inter).
- **shimmer**: ^3.0.0 (To display sleek loading skeleton screens while images load).
- **intl**: ^0.18.0 (For proper currency and date formatting).
- **uuid**: ^4.0.0 (For generating unique mock Order IDs and Cart Item IDs).

## Project Structure (Clean Architecture)
- `lib/models/`: Contains the data structures (`Product`, `CartItem`, `OrderModel`).
- `lib/controllers/`: Holds the Provider classes for state management (`ProductProvider`, `CartProvider`, `OrderProvider`).
- `lib/views/`: Contains the UI screens grouped by feature (`home`, `search`, `product`, `cart`, `orders`).
- `lib/widgets/`: Reusable components (e.g., `ProductCard`).
- `lib/utils/`: Constants, dummy data, and `AppTheme`.

## Assumptions Made
- The app operates entirely on local mock data (no backend APIs).
- The payment gateway and checkout process are simulated flows.
- Search and filtering are implemented client-side on the mock dataset.
- Delivery tracking status is mocked and manually mapped.

## Known Limitations
- Data does not persist across app restarts (in-memory state only).
- The Profile and Categories sections in the bottom navigation are placeholders as per the core flow requirements.

## How to Run
```bash
flutter run
```
