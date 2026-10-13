import 'package:book_my_look/views/screens/client/client_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/services/auth_service.dart';
import 'package:book_my_look/view_models/register_view_model.dart';
import 'package:book_my_look/view_models/login_view_model.dart';
import 'package:book_my_look/views/screens/client/client_profile_screen.dart';
import 'package:book_my_look/views/screens/client/client_home_screen.dart';
import 'package:book_my_look/views/screens/client/reward_screen.dart';


class ClientTabScreen extends StatefulWidget {
  const ClientTabScreen({super.key});

  @override
  State<ClientTabScreen> createState() => _ClientTabScreenState();
}

class _ClientTabScreenState extends State<ClientTabScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  
  final List<String> _titles = [
    "Descoperă Servicii",
    "Programările Mele",
    "Punctele Mele",
    "Profilul Meu",
  ];

  final List<Widget> _screens = [
    const ClientHomeScreen(),
    const ClientBookingScreen(),
    const RewardScreen(),
    const ClientProfileScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundBlack,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kSurfaceGrey,
        centerTitle: true,
        elevation: 0,
        actions: [
  IconButton(
    icon: const Icon(Icons.logout, color: Color(0xFFC70404)),
    onPressed: () async {
      context.read<UserProvider>().clearUser();
      try {
        context.read<LoginViewModel>().clearFields();
        context.read<RegisterViewModel>().clearFields();
      } catch (e) {

        debugPrint("Notă: Unul dintre ViewModels nu a putut fi curățat: $e");
      }

      await _authService.logOut();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/login', 
          (route) => false,
        );
      }
    },
  ),
],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: kSurfaceGrey,
        selectedItemColor: kPrimaryGold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_cut_outlined),
            activeIcon: Icon(Icons.content_cut),
            label: 'Rezervă',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Programări',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Icon(Icons.card_giftcard),
            label: 'Puncte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}