import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_app/pages/home.dart';
import 'package:supabase_app/pages/login.dart';
import 'package:supabase_app/pages/register_user.dart';
import 'package:supabase_app/pages/splash.dart';
import 'package:supabase_app/utils/app_preference.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://*************.supabase.co',
    anonKey:
        '****************',
  );

  await AppPreference().initialAppPreference();

  final supabase = Supabase.instance.client;
  runApp(ProviderScope(child: App(supabase: supabase)));
}

class App extends StatelessWidget {
  const App({Key? key, required this.supabase}) : super(key: key);
  final SupabaseClient supabase;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        initialRoute: '/', routes: <String, WidgetBuilder>{
      '/': (_) => SplashPage(supabase: supabase),
      '/login': (_) => LoginPage(supabase: supabase),
      '/register': (_) => RegisterUser(supabase: supabase),
      '/home': (_) => HomeScreen(),
        // home: Home(supabase: supabase),
    });
  }
}
