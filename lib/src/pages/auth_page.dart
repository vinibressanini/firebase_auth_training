import 'package:firebase_auth_training/src/exceptions/auth_exception.dart';
import 'package:firebase_auth_training/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLogin = true;

  late String title;
  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    setFormAction(true);
    super.initState();
  }

  setFormAction(bool action) async {
    isLogin = action;
    setState(() {
      if (isLogin) {
        title = "Welcome";
        actionButton = "Sign In";
        toggleButton = "Doesn't have an account? Sign up now!";
      } else {
        title = "Create your account";
        actionButton = "Sign up";
        toggleButton = "Return to login";
      }
    });
  }

  login(String email, String password) async {
    try {
      await context.read<AuthService>().login(email, password);
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          icon: Icon(
            Icons.error,
            size: 50,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      );
    }
  }

  register(String email, String password) async {
    try {
      await context.read<AuthService>().register(email, password);
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          icon: Icon(
            Icons.error,
            size: 50,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "youremail@example.com",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The email can't be empty";
                    } else if (value.length < 10) {
                      return "The email is too small";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "flutterisawesome",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The password can't be empty";
                    } else if (value.length < 8) {
                      return "The password is too small";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isLogin) {
                        login(_emailController.text, _passwordController.text);
                      } else {
                        register(
                            _emailController.text, _passwordController.text);
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      context.read<AuthService>().isLoading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          actionButton,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setFormAction(!isLogin),
                child: Text(toggleButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
