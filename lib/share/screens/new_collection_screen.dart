import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/models/share.dart';
import 'package:little_share/share/repositories/share_repository.dart';
import 'package:routemaster/routemaster.dart';

class NewCollectionScreen extends ConsumerStatefulWidget {
  const NewCollectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCollectionScreenState();
}

class _NewCollectionScreenState extends ConsumerState<NewCollectionScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<SharedCollection> _createCollection() async {
    setState(() {
      _isLoading = true;
    });
    var collection = SharedCollection(
      title: _titleController.text,
      description: _descriptionController.text,
    );
    try {
      var createdCollecton = await ref
          .read(shareRepositoryProvider)
          .addSharedCollection(collection);
      setState(() {
        _isLoading = false;
      });
      return createdCollecton;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Collection",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: !_isLoading
            ? () async {
                var result = await _createCollection();
                if (result.id != null) {
                  if (!mounted) return;
                  Routemaster.of(context)
                      .replace('/managecollection/${result.id}');
                }
              }
            : null,
        icon: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.arrow_forward),
        label: _isLoading ? const Text("Creating...") : const Text("Next"),
      ),
    );
  }
}
