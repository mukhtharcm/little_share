import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/repositories/share_repository.dart';

import '../models/share.dart';

final sharedCollectionsProvider = FutureProvider.autoDispose(
  ((ref) {
    final shareRepository = ref.watch(shareRepositoryProvider);

    return shareRepository.allSharedCollection();
  }),
);

class SharedCollectionsListPageController {
  final Ref ref;
  final ShareRepository shareRepository;

  SharedCollectionsListPageController(
      {required this.ref, required this.shareRepository});

  addSharedCollection(SharedCollection sharedCollection) async {
    await shareRepository.addSharedCollection(sharedCollection);
    ref.refresh(sharedCollectionsProvider);
  }

  removeSharedCollection(SharedCollection sharedCollection) async {
    await shareRepository.removeSharedCollection(sharedCollection);
    ref.refresh(sharedCollectionsProvider);
  }
}

final sharedCollectionListPageControllerProvider = Provider((ref) {
  final shareRepository = ref.watch(shareRepositoryProvider);
  return SharedCollectionsListPageController(
      ref: ref, shareRepository: shareRepository);
});
