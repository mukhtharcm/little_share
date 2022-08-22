import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/models/share.dart';
import 'package:little_share/shared/repositories/profile_repository.dart';

import '../../shared/supabase.dart';

final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  return ShareRepository(ref: ref);
});

class ShareRepository {
  Ref ref;
  ShareRepository({required this.ref});

  Future<SharedCollection> addSharedCollection(
      SharedCollection sharedCollection) async {
    try {
      return await ref
          .read(supabaseProvider)
          .from("shared_collections")
          .insert(sharedCollection.toMap())
          .select()
          .single()
          .limit(1)
          .then((value) {
        return SharedCollection.fromMap(value);
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<SharedCollection> getSharedCollection(String id) async {
    try {
      return await ref
          .read(supabaseProvider)
          .from("shared_collections")
          .select()
          .filter("id", "eq", id)
          .limit(1)
          .single()
          .then((value) {
        return SharedCollection.fromMap(value);
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future removeSharedCollection(SharedCollection sharedCollection) async {
    try {
      await ref
          .read(supabaseProvider)
          .from("shared_collections")
          .delete()
          .match({"id": sharedCollection.id});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<SharedCollection>> allSharedCollection() async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    await profileRepository.getCurrentProfile();
    try {
      return await ref
          .read(supabaseProvider)
          .from("shared_collections")
          .select()
          .then((value) {
        List<SharedCollection> collectionList = [];
        value.forEach((e) {
          collectionList.add(SharedCollection.fromMap(e));
        });
        return collectionList;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
