import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/views/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  
  Future<void> _handleLogin(LoginViewModel loginVm) async {
    try {
     
      final userData = await loginVm.login();

      
      if (!mounted) return;

      if (userData != null) {
        context.read<UserProvider>().setUser(userData);

        
        loginVm.clearFields();

        
        if (userData.role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin_tab_screen');
        } else if(userData.role == 'barber') {
          Navigator.pushReplacementNamed(context, '/barber_tab_screen');
        } else {
          Navigator.pushReplacementNamed(context, '/client_tab_screen');
        }
      }
    } catch (e) {
      
      if (!mounted) return;
      final cleanMessage = e.toString().replaceAll("Exception: ", "");
      ErrorDialog.showError(context, cleanMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Icon(
                Icons.content_cut, 
                size: 80,
                color: kPrimaryGold, 
              ), 
              const SizedBox(height: 20),
              const Text(
                "BookMyLook",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ), 
              
              const Text(
                "Premium Experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextGrey, 
                  fontSize: 14,
                ),
              ), 
              const SizedBox(height: 60),
              
              TextField(
                controller: viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              
              const SizedBox(height: 16),

              TextField(
                controller: viewModel.passwordController,
                obscureText: true, 
                decoration: const InputDecoration(
                  hintText: "Parolă",
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                   
                  },
                  child: const Text("Ai uitat parola?"),
                ),
              ),

              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: viewModel.isLoading 
                    ? null 
                    : () => _handleLogin(viewModel),
                child: viewModel.isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2, 
                          color: Colors.black,
                        ),
                      ) 
                    : const Text("Conectează-te"),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: RichText(
                    text: const TextSpan(
                      text: "Nu ai un cont? ",
                      style: TextStyle(color: kTextWhite, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Înregistrează-te!",
                          style: TextStyle(
                            color: kPrimaryGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}