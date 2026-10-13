import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/services/user_service.dart';
import 'package:book_my_look/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

Future<void> _checkAuthAndNavigate() async {
   
    final stopwatch = Future.delayed(const Duration(seconds: 3));

   
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        final userService = UserService();
        final userData = await userService.getUserData(firebaseUser.uid);

        if (userData != null && mounted) {
          
          context.read<UserProvider>().setUser(userData);
        }
      } catch (e) {
        debugPrint("Eroare la încărcarea datelor în Splash: $e");
      }
    }

    
    await stopwatch;

    if (!mounted) return;

    
    if (firebaseUser != null) {
      
      final user = context.read<UserProvider>().user;

      if (user?.role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin_tab_screen');
      } else if(user?.role == 'barber') {     
        Navigator.pushReplacementNamed(context, '/barber_tab_screen');
      } else if(user?.role == 'client') {
        Navigator.pushReplacementNamed(context, '/client_tab_screen');
      }
       } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundBlack, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.content_cut, 
              size: 80, 
              color: kPrimaryGold
            ),
            const SizedBox(height: 20),
            Text(
              "BookMyLook",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kTextWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Premium Experience",
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryGold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}