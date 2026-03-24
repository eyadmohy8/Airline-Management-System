import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String id;
  final String flightNumber;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int totalSeats;
  final int availableSeats;
  final List<String> bookedSeats;

  Flight({
    required this.id,
    required this.flightNumber,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.bookedSeats,
  });

  factory Flight.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Flight(
      id: doc.id,
      flightNumber: data['flightNumber'] ?? '',
      departureCity: data['departureCity'] ?? '',
      destinationCity: data['destinationCity'] ?? '',
      departureTime: (data['departureTime'] as Timestamp).toDate(),
      arrivalTime: (data['arrivalTime'] as Timestamp).toDate(),
      price: (data['price'] ?? 0.0).toDouble(),
      totalSeats: data['totalSeats'] ?? 0,
      availableSeats: data['availableSeats'] ?? 0,
      bookedSeats: List<String>.from(data['bookedSeats'] ?? []),
    );
  }
}
