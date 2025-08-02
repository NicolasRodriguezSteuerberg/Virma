// login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            ElevatedButton(
              onPressed: () async {
                final ok = await auth.login(_email.text, _pass.text);
                if (!ok) {
                  setState(() => _error = "Credenciales incorrectas");
                }
              },
              child: Text("Iniciar sesión"),
            ),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    );
  }
}
