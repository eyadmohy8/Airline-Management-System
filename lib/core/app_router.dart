import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/booking/search_flight_screen.dart';
import '../screens/booking/flight_results_screen.dart';
import '../screens/booking/booking_confirmation_screen.dart';
import '../screens/seats/seat_selection_screen.dart';
import '../screens/manifest/passenger_details_screen.dart';
import '../screens/manifest/manifest_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchFlightScreen(),
    ),
    GoRoute(
      path: '/search/results',
      builder: (context, state) {
        final origin = state.uri.queryParameters['origin'] ?? 'New York';
        final destination = state.uri.queryParameters['destination'] ?? 'London';
        return FlightResultsScreen(origin: origin, destination: destination);
      },
    ),
    GoRoute(
      path: '/seats',
      builder: (context, state) => const SeatSelectionScreen(),
    ),
    GoRoute(
      path: '/passenger_details',
      builder: (context, state) => const PassengerDetailsScreen(),
    ),
    GoRoute(
      path: '/manifest',
      builder: (context, state) => const ManifestDashboardScreen(),
    ),
    GoRoute(
      path: '/booking_confirmation',
      builder: (context, state) => const BookingConfirmationScreen(),
    ),
  ],
);
