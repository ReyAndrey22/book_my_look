import 'package:book_my_look/providers/booking_provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/view_models/login_view_model.dart';
import 'package:book_my_look/view_models/register_view_model.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/view_models/user_view_model.dart';
import 'package:book_my_look/view_models/barber_view_model.dart';
import 'package:book_my_look/view_models/booking_view_model.dart';
import 'package:book_my_look/view_models/chair_view_model.dart';
import 'package:book_my_look/view_models/reward_view_model.dart';
import 'package:book_my_look/view_models/nfc_view_model.dart';
import 'package:book_my_look/views/screens/admin/admin_tab_screen.dart';
import 'package:book_my_look/views/screens/barber/barber_tab_screen.dart';
import 'package:book_my_look/views/screens/client/client_tab_screen.dart';
import 'package:book_my_look/views/screens/client/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/screens/auth/splash_screen.dart';
import 'package:book_my_look/views/screens/auth/login_screen.dart';
import 'package:book_my_look/views/screens/auth/register_screen.dart';
import 'services/notification_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create:  (_) => BookingProvider()),
        ChangeNotifierProvider(create:  (_) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BarberViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceViewModel()),
        ChangeNotifierProvider(create: (_) => ChairViewModel()),
        ChangeNotifierProvider(create: (_) => RewardViewModel()),
        ChangeNotifierProvider(create: (_) => NfcViewModel()),
      ],
      child: const MyApp()),
    ); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book My Look',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      
      routes: {
        '/client_tab_screen': (context) => const ClientTabScreen(),
        '/admin_tab_screen': (context) => AdminTabScreen(), 
        '/barber_tab_screen': (context) => BarberTabScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen() ,
        '/select_date_time': (context) => const CalendarScreen(),
      },
    );
  }
}