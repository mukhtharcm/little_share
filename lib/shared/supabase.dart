import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider =
    riverpod.Provider<SupabaseClient>((ref) => Supabase.instance.client);

final currentUserProvider = riverpod.Provider<User?>((ref) {
  return ref.watch(supabaseProvider).auth.currentUser;
});

class UserStateNotifier extends riverpod.StateNotifier<User?> {
  riverpod.Ref ref;
  UserStateNotifier(this.ref) : super(null) {
    state = ref.read(currentUserProvider);
  }

  Future login({required String email, required String password}) async {
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
      debugPrint("Login success: $value");
      state = value.user;
    });
  }

  Future signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    debugPrint(username);
    await ref.read(supabaseProvider).auth.signUp(
      email,
      password,
      userMetadata: {"username": username},
    ).then((value) {
      debugPrint("Signup success: $value");
      state = value.user;
    });
  }

  Future signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
    state = null;
  }
}

final userProvider =
    riverpod.StateNotifierProvider<UserStateNotifier, User?>((ref) {
  return UserStateNotifier(ref);
});
