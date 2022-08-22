import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/shared/supabase.dart';

class ProfileRepository {
  Ref ref;
  ProfileRepository({required this.ref});

  Future getCurrentProfile() async {
    final currentUser = ref.read(currentUserProvider);
    debugPrint(currentUser?.id);
    try {
      await ref
          .read(supabaseProvider)
          .from("profiles")
          .select()
          .filter("id", "eq", currentUser?.id)
          .limit(1)
          .single()
          .then((value) => debugPrint(value.toString()));
    } catch (e) {
      debugPrint("Error while getting current user Profile");
      debugPrint(e.toString());
      rethrow;
    }
  }
}

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepository(ref: ref));
