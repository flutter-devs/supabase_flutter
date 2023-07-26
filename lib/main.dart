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
    url: 'https://rwznhsvtqcfwmhdzuhey.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3em5oc3Z0cWNmd21oZHp1aGV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODk5NDQ0OTMsImV4cCI6MjAwNTUyMDQ5M30.pxAGDbACLf6raTWBpgs-gq8BKR5fX-SLXu-O20gdtjU',
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

// /// Bottom menu widget
// class Menu extends HookConsumerWidget {
//   const Menu({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final filter = ref.watch(todoListFilter);
//
//     int currentIndex() {
//       switch (filter) {
//         case TodoListFilter.completed:
//           return 2;
//         case TodoListFilter.active:
//           return 1;
//         case TodoListFilter.all:
//           return 0;
//       }
//     }
//
//     return BottomNavigationBar(
//       key: bottomNavigationBarKey,
//       elevation: 0.0,
//       onTap: (value) {
//         if (value == 0) ref.read(todoListFilter.notifier).state = TodoListFilter.all;
//         if (value == 1) ref.read(todoListFilter.notifier).state = TodoListFilter.active;
//         if (value == 2) ref.read(todoListFilter.notifier).state = TodoListFilter.completed;
//       },
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All', tooltip: 'All'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.circle),
//           label: 'Active',
//           tooltip: 'Active',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.done),
//           label: 'Completed',
//           tooltip: 'Completed',
//         ),
//       ],
//       currentIndex: currentIndex(),
//       selectedItemColor: Colors.amber[800],
//     );
//   }
// }
//
// class TodoItem extends HookConsumerWidget {
//   const TodoItem({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todo = ref.watch(currentTodo);
//     final itemFocusNode = useFocusNode();
//     final itemIsFocused = useIsFocused(itemFocusNode);
//
//     final textEditingController = useTextEditingController();
//     final textFieldFocusNode = useFocusNode();
//
//     return Material(
//       color: Colors.white,
//       elevation: 6,
//       child: Focus(
//         focusNode: itemFocusNode,
//         onFocusChange: (focused) {
//           if (focused) {
//             textEditingController.text = todo.description;
//           } else {
//             // Commit changes only when the textfield is unfocused, for performance
//             ref.read(todoListProvider.notifier).edit(id: todo.id, description: textEditingController.text);
//           }
//         },
//         child: ListTile(
//           onTap: () {
//             itemFocusNode.requestFocus();
//             textFieldFocusNode.requestFocus();
//           },
//           leading: Checkbox(
//             value: todo.completed,
//             onChanged: (value) => ref.read(todoListProvider.notifier).toggle(todo.id),
//           ),
//           title: itemIsFocused
//               ? TextField(
//                   autofocus: true,
//                   focusNode: textFieldFocusNode,
//                   controller: textEditingController,
//                 )
//               : Text(todo.description),
//         ),
//       ),
//     );
//   }
// }
//
// bool useIsFocused(FocusNode node) {
//   final isFocused = useState(node.hasFocus);
//
//   useEffect(
//     () {
//       void listener() {
//         isFocused.value = node.hasFocus;
//       }
//
//       node.addListener(listener);
//       return () => node.removeListener(listener);
//     },
//     [node],
//   );
//
//   return isFocused.value;
// }
