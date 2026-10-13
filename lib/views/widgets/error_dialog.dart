import 'package:flutter/material.dart';

class ErrorDialog {
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5), 
        ),
        
        content: Padding(
          padding: const EdgeInsets.only(top: 10), 
          child: Text(
            message,
            textAlign: TextAlign.center, 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 16,
              height: 1.5, 
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center, 
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK", 
              style: TextStyle(
                color: Color(0xFFD4AF37), 
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
        ],
      ),
    );
  }
}