# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Smart Gate is a Flutter mobile app for managing vehicle barrier gates and toll collection. It tracks vehicle entries, classifies them by type, and calculates tolls using a tariff table. The deployment location is identified by gate prefix `BOK-`.

The database schema and raw SQL queries are in `../database.sql`.

## Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/features/dashboard/bloc/dashboard_bloc_test.dart

# Lint
flutter analyze

# Format
dart format lib/
```

## Database Schema

PostgreSQL database with three key tables:

**`barrier_events`** — raw events from barrier hardware
- `vehicle_type` (varchar) — AI-classified vehicle type (e.g. `SUV`, `LargeTruck`, `Microbus`)
- `event_type` (varchar) — `vehicle_entry` or `vehicle_exit`
- `status` (varchar) — `RECEIVED` for processed events
- `created_at` (timestamp)

**`tariffs`** — toll pricing table
- `name` (varchar) — tariff code, e.g. `BOK-CR01`
- `vehicle_type` (varchar) — Lao-language description of vehicle category
- `kip_rate` (numeric) — price in Lao Kip

**`barrier_transactions`** — payment records
- `gate_id` (varchar) — gate identifier, e.g. `BOK-entry`
- `vehicle_type` (varchar) — Lao-language vehicle category
- `amount` (numeric) — amount charged
- `status` (varchar) — `success` for completed payments
- `created_at` (timestamp)

## Vehicle Type → Tariff Mapping

The `get_identify(vehicle_type)` PostgreSQL function maps AI vehicle classifications to tariff codes:

| Vehicle Type | Tariff Code | Price (KIP) |
|---|---|---|
| SUV, SaloonCar, Sedan, Pickup, (null/empty) | BOK-CR01 | 34,000 |
| MPV, Microbus | BOK-CR03 | 68,000 |
| MicroTruck | BOK-CR06 | 170,000 |
| LargeTruck, MidTruck | BOK-CR08 | 340,000 |
| Motorcycle, PassengerCar | 0 (free) | — |

## Flutter Architecture

Clean Architecture with three layers per feature:

```
lib/
├── core/
│   ├── di/injection.dart          # GetIt service locator setup
│   ├── router/app_router.dart     # GoRouter route definitions
│   └── theme/app_theme.dart       # Material 3 theme
├── features/
│   └── dashboard/
│       ├── data/
│       │   ├── datasources/       # Remote/local API calls (Dio)
│       │   ├── models/            # JSON-serializable models (extend entities)
│       │   └── repositories/      # Repository implementations
│       ├── domain/
│       │   ├── entities/          # Pure Dart data classes (Equatable)
│       │   ├── repositories/      # Abstract repository contracts
│       │   └── usecases/          # Single-responsibility use case classes
│       └── presentation/
│           ├── bloc/              # BLoC: event/state/bloc (part files)
│           ├── pages/             # Full-screen page widgets
│           └── widgets/           # Reusable UI components
└── main.dart
```

**State management**: `flutter_bloc` — each page gets its own BLoC instance via `BlocProvider` + `sl<>()`.

**DI**: `get_it` singleton `sl`. Data sources → repositories → use cases → BLoCs registered in `core/di/injection.dart`. BLoCs are registered as `factory` so each page gets a fresh instance.

**Navigation**: `go_router`. Routes defined centrally in `AppRouter.router`.

**Key BLoC pattern**: Events are `DashboardLoaded` (initial fetch) and `DashboardRefreshed` (retry/pull-to-refresh). The bloc stores `_lastEvent` to support refresh without re-passing parameters.

## Key Business Logic

- Revenue calculation: `calculate_price(vehicle_type)` looks up `kip_rate` from `tariffs` via `get_identify()`
- Reconciliation: `barrier_events` (raw sensor data) vs `barrier_transactions` (actual payments) are joined for reporting
- Date filtering is typically by `created_at` range with `event_type = 'vehicle_entry'` and `status = 'RECEIVED'`
