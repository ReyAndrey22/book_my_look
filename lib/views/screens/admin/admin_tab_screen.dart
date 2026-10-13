import 'package:book_my_look/views/screens/admin/users_list_screen.dart';
import 'package:book_my_look/views/screens/admin/service_screen.dart';
import 'package:book_my_look/views/screens/admin/chair_screen.dart';
import 'package:book_my_look/views/screens/admin/admin_reward_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/services/auth_service.dart';

class AdminTabScreen extends StatefulWidget {
  const AdminTabScreen({super.key});

  @override
  State<AdminTabScreen> createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<String> _titles = [
    "Utilizatori",
    "Servicii",
    "Scaune",
    "Recompense",
  ];

  final List<Widget> _screens = [
    const UsersListScreen(),
    const ServiceScreen(),
    const ChairScreen(),
    const AdminRewardScreen(),
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
            icon: const Icon(Icons.logout, color:Color(0xFFC70404)),
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
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Utilizatori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Servicii',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chair_outlined),
            activeIcon: Icon(Icons.chair),
            label: 'Scaune',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Icon(Icons.card_giftcard),
            label: 'Recompense',
          ),
        ],
      ),
    );
  }
}