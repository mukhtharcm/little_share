import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider =
    riverpod.Provider<SupabaseClient>((ref) => Supabase.instance.client);

final authStateChangeProvider = riverpod.StreamProvider<AuthChangeEvent>((ref) {
  return SupabaseAuth.instance.onAuthChange;
});

final currentUserProvider = riverpod.Provider<User?>((ref) {
  return ref.read(supabaseProvider).auth.currentUser;
});

class UserState extends riverpod.StateNotifier<User?> {
  riverpod.Ref ref;
  UserState(this.ref) : super(null) {
    state = ref.read(currentUserProvider);
  }

  Future login({required String email, required String password}) async {
    print("Loggin In blahba....");
    await ref
        .read(supabaseProvider)
        .auth
        .signIn(
            email: email,
            password: password,
            options: const AuthOptions(
              redirectTo: kIsWeb
                  ? null
                  : 'io.supabase.flutterquickstart://login-callback/',
            ))
        .then((value) {
      print("Logged In");
      state = value.user;
    });
  }

  Future signUp(String email, String password) async {
    final response = await ref
        .read(supabaseProvider)
        .auth
        .signUp(email, password)
        .then((value) {
      print("Logged In");
      state = value.user;
    });
  }

  Future signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
    state = null;
  }
}

final userProvider = riverpod.StateNotifierProvider<UserState, User?>((ref) {
  return UserState(ref);
});
