import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/helpers/date_format.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: user == null
          ? const Center(child: CircularProgressIndicator(color: kPrimaryGold))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: kPrimaryGold,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                        style: const TextStyle(
                          fontSize: 45,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Membru din ${DateHelper.formatDate(user.createdAt)}",
                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: kPrimaryGold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${user.loyaltyPoints} puncte de loialitate",
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "INFORMAȚII CONT",
                        style: TextStyle(
                          color: kPrimaryGold,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ListTile(
                    leading: const Icon(Icons.email_outlined, color: Colors.white70),
                    title: const Text("Email", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.phone_android_outlined, color: Colors.white70),
                    title: const Text("Telefon", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    subtitle: Text(
                      user.phone.isNotEmpty ? user.phone : "Nespecificat",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}