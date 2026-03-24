import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'providers/booking_provider.dart';
import 'core/theme.dart';
import 'core/app_router.dart';

Future<void> seedDatabase() async {
  try {
    final db = FirebaseFirestore.instance;
    final flights = await db.collection('flights').get();
    if (flights.docs.isNotEmpty) return; // Already seeded

    final batch = db.batch();
    
    final routes = [
      {'dep': 'New York', 'arr': 'London'},
      {'dep': 'Paris', 'arr': 'Tokyo'},
      {'dep': 'Tokyo', 'arr': 'Sydney'},
      {'dep': 'London', 'arr': 'Paris'},
      {'dep': 'Dubai', 'arr': 'New York'},
      {'dep': 'Los Angeles', 'arr': 'Tokyo'},
      {'dep': 'Berlin', 'arr': 'Rome'},
    ];

    for (int i = 0; i < routes.length; i++) {
      final docRef = db.collection('flights').doc();
      final dep = routes[i]['dep']!;
      final arr = routes[i]['arr']!;
      
      batch.set(docRef, {
        'flightNumber': 'AL-${100 + i}',
        'departureCity': dep,
        'destinationCity': arr,
        'departureTime': Timestamp.fromDate(DateTime.now().add(Duration(days: i + 1))),
        'arrivalTime': Timestamp.fromDate(DateTime.now().add(Duration(days: i + 1, hours: 6 + (i % 4)))),
        'price': 400.0 + (i * 50),
        'totalSeats': 60,
        'availableSeats': 60,
        'bookedSeats': [],
      });
    }
    await batch.commit();
    debugPrint("DATABASE SEEDED SUCCESSFULLY!");
  } catch (e) {
    debugPrint("FAILED TO SEED: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  
  seedDatabase(); // Temporary auto-seeder

  GoogleSignIn.instance.initialize(
    serverClientId: '612324582325-mvsjv3k2f7cftbuneim6oe9j2e9ee1hj.apps.googleusercontent.com',
  );

  runApp(const AeroLineApp());
}


class AeroLineApp extends StatelessWidget {
  const AeroLineApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp.router(
        title: 'AeroLine Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
