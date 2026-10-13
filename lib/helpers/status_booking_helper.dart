import 'package:flutter/material.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class StatusBookingHelper {
  static Color getColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed: return Colors.green;
      case BookingStatus.inProgress: return kPrimaryGold;
      case BookingStatus.completed: return Colors.blue;
      case BookingStatus.cancelled: return Colors.red;
      case BookingStatus.noShow: return Colors.grey;
    }
  }

  static String getLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed: return "PROGRAMATĂ";
      case BookingStatus.inProgress: return "ÎN CURS";
      case BookingStatus.completed: return "FINALIZATĂ";
      case BookingStatus.cancelled: return "ANULATĂ";
      case BookingStatus.noShow: return "LIPSĂ";
    }
  }
}