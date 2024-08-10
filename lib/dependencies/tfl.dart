import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' show copyResize, decodeImageFile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

final tflProvider = FutureProvider((ref) async {
  final interpreter = await Interpreter.fromAsset('assets/leaf_model.tflite');
  final isolateInterpreter =
      await IsolateInterpreter.create(address: interpreter.address);
  return isolateInterpreter;
});

Future<Uint8List?> _processImage(String filePath) async {
  final decoded = await decodeImageFile(filePath);
  if (decoded == null) return null;
  return copyResize(
    decoded,
    width: 256,
    height: 256,
    maintainAspect: false,
  ).getBytes();
}

Future<int?> classify({
  required String filePath,
  required IsolateInterpreter tfl,
}) async {
  final data =
      await compute(_processImage, filePath, debugLabel: 'image_process');
  if (data == null) return null;
  final input = data.reshape([1, 256, 256, 3]);
  var output = List.filled(3, 0.0).reshape([1, 3]);
  await tfl.run(input, output);
  output = output.reshape([3]);
  final (index, _) =
      output.indexed.reduce((max, next) => max.$2 > next.$2 ? max : next);
  return index;
}

class EagerInitTFL extends ConsumerWidget {
  final Widget child;
  const EagerInitTFL({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(tflProvider)) {
      case AsyncData _:
        return child;
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
}
