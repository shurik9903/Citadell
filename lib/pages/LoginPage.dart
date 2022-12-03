import 'package:flutter/material.dart';
import '../modules/LoginFetch.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String login = "";
  String password = "";
  String msg = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 300),
            child: Column(
              children: [
                Wrap(
                  runSpacing: 10,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          login = value;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Логин'),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Пароль'),
                    ),
                    Text(msg)
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        loginFetch(login, password).then((value) {
                          Navigator.pushNamed(context, '/work');
                        }).catchError((error) {
                          setState(() {
                            msg = error.toString();
                          });
                        });

                        // Navigator.pushNamed(context, '/work');
                      },
                      child: const Text("Вход"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
