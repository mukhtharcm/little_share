import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/models/file_model.dart';

import '../../shared/supabase.dart';

class FileRepository {
  Ref ref;

  FileRepository({required this.ref});

  Future<List<FileModel>> getFileList(String collectionId) async {
    // await Future.delayed(const Duration(seconds: 1000));
    try {
      return await ref
          .read(supabaseProvider)
          .from("files")
          .select()
          .filter("collection_id", "eq", collectionId)
          .then((value) {
        List<FileModel> fileList = [];
        value.forEach((file) {
          fileList.add(FileModel.fromMap(file));
        });
        return fileList;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  return FileRepository(ref: ref);
});
