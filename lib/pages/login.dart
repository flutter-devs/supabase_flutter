import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_app/constants.dart';
import 'package:supabase_app/pages/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.supabase});
  final SupabaseClient? supabase;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _redirecting = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.supabase?.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  Future<void> _signIn() async {
    try {
      debugPrint("EMAILLL: ${_emailController.text}, PASSS: ${_passwordController.text}");
      await widget.supabase?.auth.signInWithPassword(email: _emailController.text, password: _passwordController.text).then((value) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();

        _redirecting = true;

      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Login')), backgroundColor: Colors.teal,),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), labelText: 'Email', hintText: 'Enter a valid email'),
                    validator: (String? value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Email is not valid';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), labelText: 'Password', hintText: 'Enter your password',),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      // style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.teal), ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _signIn();
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          // RegisterUser(supabase: widget.supabase ?? Supabase.instance.client)
                          SignUpPage(supabase: widget.supabase ?? Supabase.instance.client)
                      ));
                    },
                    child: const Text('Don\'t have an account?', style: TextStyle(color: Colors.teal),)),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
