import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.client,
    required this.onLogged,
  });

  final RestClient client;
  final Function(bool) onLogged;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController(text: 'john.smith@polito.it');
    passwordController = TextEditingController(text: 'johnpolito');
    // emailController = TextEditingController();
    // passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_rounded,
              size: 150.0,
            ),
            const SizedBox(height: 50.0),
            const Text(
              'Login To Your Account',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 100.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Email', border: InputBorder.none),
                      ),
                    ))),
            const SizedBox(height: 30.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            hintText: 'Password', border: InputBorder.none),
                      ),
                    ))),
            const SizedBox(height: 40.0),
            TextButton(
              style: (TextButton.styleFrom(
                backgroundColor: Colors.cyan,
              )),
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                final res = await widget.client.post(
                  api: 'sessions',
                  body: {
                    'username': email,
                    'password': password,
                  },
                );

                if (res.body == "\"Incorrect username or password.\"") {
                  widget.onLogged(false);
                } else {
                  widget.onLogged(true);
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
