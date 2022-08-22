import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/repositories/file_repository.dart';

import '../models/file_model.dart';
import '../models/share.dart';
import '../repositories/share_repository.dart';

class ManageCollectionPageController {
  ManageCollectionPageController({required this.ref});

  Ref ref;

  Future<SharedCollection> getSharedCollection(String id) async {
    final shareRepository = ref.watch(shareRepositoryProvider);

    return await shareRepository.getSharedCollection(id);
  }

  Future<List<FileModel>> getFileList(String collectionId) async {
    final fileRepository = ref.watch(fileRepositoryProvider);

    return await fileRepository.getFileList(collectionId);
  }
}

final manageCollectionPageControllerProvider = Provider((ref) {
  return ManageCollectionPageController(ref: ref);
});

final sharedCollectoinProvider =
    FutureProvider.family<SharedCollection, String>((ref, id) async {
  return ref
      .watch(manageCollectionPageControllerProvider)
      .getSharedCollection(id);
});

final fileListProvider =
    FutureProvider.family<List<FileModel>, String>((ref, id) async {
  return ref.watch(manageCollectionPageControllerProvider).getFileList(id);
});
