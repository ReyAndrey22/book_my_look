import 'package:book_my_look/views/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:book_my_look/view_models/user_view_model.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:provider/provider.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserViewModel>();

    return StreamBuilder<List<UserModel>>(
      stream: viewModel.usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryGold),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Eroare la încărcarea utilizatorilor",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final users = snapshot.data ?? [];

        if (users.isEmpty) {
          return const Center(
            child: Text(
              "Nu există utilizatori înregistrați.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTextGrey, width: 2.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: user.role == 'admin'
                        ? Colors.redAccent
                        : Colors.orange,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: kTextGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Membru din ${user.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}",
                          style: const TextStyle(
                            color: kTextGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              color: kTextGrey,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.phone,
                              style: const TextStyle(
                                color: kTextGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 2,
                              ), 
                              child: Icon(
                                Icons.email_outlined,
                                color: kTextGrey,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user.email,
                                style: const TextStyle(
                                  color: kTextGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap:
                                    true, 
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  user.role == 'admin'
                                      ? Icons.security
                                      : Icons.person_outline,
                                  color: kTextGrey,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user.role,
                                  style: TextStyle(
                                    color: user.role == 'admin'
                                        ? Colors.redAccent
                                        : kPrimaryGold,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            if (user.role != 'admin')
                              GestureDetector(
                                onTap: viewModel.isLoading
                                    ? null
                                    : () async {
                                        final error = await viewModel
                                            .changeUserRole(
                                              user.uid,
                                              user.role,
                                            );
                                        if (error != null && context.mounted) {
                                          ErrorDialog.showError(
                                            context,
                                            error,
                                          );
                                        }
                                      },
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: kPrimaryGold,
                                        ),
                                      )
                                    : Icon(
                                        user.role == 'client'
                                            ? Icons.arrow_circle_up
                                            : Icons.arrow_circle_down,
                                        color: kPrimaryGold,
                                        size: 25,
                                      ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
