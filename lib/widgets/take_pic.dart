import 'dart:async';

import 'package:paddy_health/widgets/results.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _IconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final FutureOr<void> Function() onPressed;
  const _IconButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class TakePicScreen extends StatelessWidget {
  const TakePicScreen({super.key});

  Future<void> _onPress(
    BuildContext context,
    ImagePicker picker,
    ImageSource source,
  ) async {
    final image = await picker.pickImage(source: source);
    if (image == null || !context.mounted) return;
    await showModalBottomSheet(
      context: context,
      builder: (context) => ResultsSheet(file: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paddy health'),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find if your crops are healthy or affected by a disease.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Builder(
              builder: (context) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _IconButton(
                        text: 'Take picture',
                        icon: Icons.camera_outlined,
                        onPressed: () =>
                            _onPress(context, picker, ImageSource.camera),
                      ),
                      const SizedBox(height: 8),
                      _IconButton(
                        text: 'Select image',
                        icon: Icons.photo_album_outlined,
                        onPressed: () =>
                            _onPress(context, picker, ImageSource.gallery),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
