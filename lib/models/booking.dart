import 'package:cloud_firestore/cloud_firestore.dart';

class PassengerDetails {
  String name = '';
  String email = '';
  String passport = '';
}

class Booking {
  final String? id;
  final String userId;
  final String flightId;
  final PassengerDetails passenger;
  final String seatNumber;
  final DateTime bookingDate;
  final double totalPaid;
  final String status;

  Booking({
    this.id,
    required this.userId,
    required this.flightId,
    required this.passenger,
    required this.seatNumber,
    required this.bookingDate,
    required this.totalPaid,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'flightId': flightId,
      'passengerName': passenger.name,
      'passengerEmail': passenger.email,
      'passengerPassport': passenger.passport,
      'seatNumber': seatNumber,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'totalPaid': totalPaid,
      'status': status,
    };
  }
}
