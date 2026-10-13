import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: kPrimaryGold,
      scaffoldBackgroundColor: kBackgroundBlack,

      colorScheme: const ColorScheme.dark().copyWith(
        primary: kPrimaryGold,
        onPrimary: Colors.black,
        surface: kSurfaceGrey,
        onSurface: kTextWhite,
        error: Colors.redAccent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kSurfaceGrey,
        hintStyle: const TextStyle(color: kTextGrey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryGold, width: 1.5),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGold,
          foregroundColor: Colors.black, 
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}