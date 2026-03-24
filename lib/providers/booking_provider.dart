import 'package:flutter/foundation.dart';
import '../models/flight.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  Flight? _selectedFlight;
  String? _selectedSeat;
  PassengerDetails _passenger = PassengerDetails();

  Flight? get selectedFlight => _selectedFlight;
  String? get selectedSeat => _selectedSeat;
  PassengerDetails get passenger => _passenger;

  void selectFlight(Flight flight) {
    _selectedFlight = flight;
    _selectedSeat = null; // Reset seat when the flight changes
    notifyListeners();
  }

  void selectSeat(String seat) {
    _selectedSeat = seat;
    notifyListeners();
  }

  void updatePassengerData({String? name, String? email, String? passport}) {
    if (name != null) _passenger.name = name;
    if (email != null) _passenger.email = email;
    if (passport != null) _passenger.passport = passport;
    notifyListeners();
  }

  void clearBooking() {
    _selectedFlight = null;
    _selectedSeat = null;
    _passenger = PassengerDetails();
    notifyListeners();
  }
}
