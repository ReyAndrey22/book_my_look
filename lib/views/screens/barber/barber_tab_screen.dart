import 'package:book_my_look/views/screens/barber/barber_agenda_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/services/auth_service.dart';
import 'package:book_my_look/views/screens/barber/barber_home_screen.dart';

class BarberTabScreen extends StatefulWidget {
  const BarberTabScreen({super.key});

  @override
  State<BarberTabScreen> createState() => _BarberTabScreenState();
}

class _BarberTabScreenState extends State<BarberTabScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<String> _titles = [
    "Home",
    "Agenda",
    "Profil Profesional",
  ];

  
  final List<Widget> _screens = [
    const BarberHomeScreen(),
    const BarberAgendaScreen(),
    const Center(child: Text("Setări Bio & Experiență", style: TextStyle(color: Colors.white))),
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
              await _authService.logOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
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
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            activeIcon: Icon(Icons.design_services),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            activeIcon: Icon(Icons.badge),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}