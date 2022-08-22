import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';
import 'package:little_share/shared/route_maps.dart';
import 'package:little_share/shared/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supab;
import 'package:little_share/shared/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Routemaster.setPathUrlStrategy();

  await dotenv.load();

  await supab.Supabase.initialize(
      url: Environment.supabaseUrl, anonKey: Environment.supabaseAnonKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);
    final currentUser = ref.watch(userProvider);
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.comfortaa().fontFamily,
      ),
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) => currentUser != null
            ? routes.loggedInRoutes
            : routes.loggedOutRoutes,
      ),
    );
  }
}
