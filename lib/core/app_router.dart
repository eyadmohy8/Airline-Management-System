import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/booking/search_flight_screen.dart';
import '../screens/booking/flight_results_screen.dart';
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
      path: '/search',
      builder: (context, state) => const SearchFlightScreen(),
    ),
    GoRoute(
      path: '/search/results',
      builder: (context, state) => const FlightResultsScreen(),
    ),
    GoRoute(
      path: '/seats',
      builder: (context, state) => const SeatSelectionScreen(),
    ),
    GoRoute(
      path: '/passenger_details',
      builder: (context, state) {
        final seat = state.extra as String?;
        return PassengerDetailsScreen(selectedSeat: seat ?? 'Unknown');
      },
    ),
    GoRoute(
      path: '/manifest',
      builder: (context, state) => const ManifestDashboardScreen(),
    ),
  ],
);
