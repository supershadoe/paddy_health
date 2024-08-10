import 'dart:io';

import 'package:paddy_health/dependencies/tfl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' show XFile;

class ResultsSheet extends ConsumerStatefulWidget {
  final XFile file;
  const ResultsSheet({super.key, required this.file});

  @override
  ConsumerState<ResultsSheet> createState() => _ResultsSheetState();
}

class _ResultsSheetState extends ConsumerState<ResultsSheet>
    with TickerProviderStateMixin {
  var result = 'Processing...';
  var resultText = 'Currently processing the image.';
  late final Future<void> processingFuture;
  final classes = ['Healthy', 'Fungal(Leaf Blast)', 'Bacterial(Leaf Blight)'];

  @override
  void initState() {
    super.initState();
    processingFuture = classifyImage();
  }

  @override
  void dispose() {
    processingFuture.ignore();
    super.dispose();
  }

  Future<void> classifyImage() async {
    final index = await classify(
      filePath: widget.file.path,
      tfl: await ref.read(tflProvider.future),
    );
    if (index == null) {
      setState(() {
        result = 'Error';
        resultText = 'Failed to classify the image for some reason.';
      });
    } else {
      setState(() {
        result = classes[index];
        if (index > 0) {
          resultText = 'This crop is affected by a ${classes[index]} disease.';
        } else {
          resultText = 'This crop is healthy.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: BottomSheet.createAnimationController(this),
      enableDrag: false,
      showDragHandle: true,
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          result,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          resultText,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: Image.file(
                      File(widget.file.path),
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }
}
