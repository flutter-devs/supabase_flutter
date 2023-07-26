import 'package:flutter/material.dart';
import 'package:supabase_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_preference.dart';
import 'home.dart';

class RegisterUser extends StatefulWidget {
  final SupabaseClient supabase;

  const RegisterUser({Key? key, required this.supabase}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  SupabaseClient client = Supabase.instance.client;

  late String userId;

  final _usernameController = TextEditingController();

  final _fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> insertProfileData(String username, String fullName) async {
    final client = Supabase.instance.client;

    // Create a JSON body containing the data you want to insert
    final body = {
      'username': username,
      'full_name': fullName,
    };

    try {
      final response = await client.from('profiles').update(body).eq('id', userId).execute();
      print(response.data);

    } catch(e) {
      context.showSnackBar(message: e.toString());
    }
  }
  // addData(String username, String fullName) async {
  //   await client
  //       .from('profiles')
  //       .update({
  //         'username': username,
  //         'full_name': fullName,
  //       })
  //       .eq('id', userId)
  //       .execute();
  // }

  @override
  void initState() {
    userId = Supabase.instance.client.auth.currentUser?.id ?? AppPreference().getString('userId');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 200),
                const Text("**Please enter your data**",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Username',
                        hintText: 'Enter a username'),
                    validator: (String? value) {
                      // if (value!.isEmpty || !value.contains('@')) {
                      //   return 'Email is not valid';
                      // }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Full name',
                        hintText: 'Enter your name'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        await insertProfileData(
                            _usernameController.text, _fullNameController.text);
                        if(!mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Saved")));
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
