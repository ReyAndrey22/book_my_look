import 'package:book_my_look/views/widgets/error_dialog.dart'; 
import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/view_models/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  
  Future<void> _onRegisterPressed(RegisterViewModel viewModel) async {
    final String? error = await viewModel.register();

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cont creat cu succes! Te poți conecta.")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ErrorDialog.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
   
    final viewModel = context.watch<RegisterViewModel>();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Cont Nou",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryGold,
                ),
              ),
              const Text(
                "Alătură-te comunității noastre premium.",
                style: TextStyle(color: kTextGrey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: viewModel.nameController,
                decoration: const InputDecoration(
                  hintText: "Nume Complet",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Număr telefon",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Parolă",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirmă parolă",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: viewModel.isLoading 
                    ? null 
                    : () => _onRegisterPressed(viewModel), 
                child: viewModel.isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2, 
                          color: Colors.black,
                        ),
                      ) 
                    : const Text("Crează cont"),
              ),
              
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: "Ai deja cont? ",
                      style: TextStyle(color: kTextWhite, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Conectează-te!",
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

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Prin înregistrare, accepți Termenii și Condițiile noastre.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextGrey, 
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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