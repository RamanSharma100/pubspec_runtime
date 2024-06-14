import 'dart:io';
import 'package:pubspec_runtime/pubspec_runtime.dart';
import 'package:pubspec_runtime/src/dependency.dart';

void main() async {
  final pubspecEditor = PubspecEditor();

  print("Dependencies:");
  print(pubspecEditor.dependencies.list);

  print("Dev Dependencies:");
  print(pubspecEditor.devDependencies.list);

  print("Adding a dependency...");
  pubspecEditor.dependencies
      .add(Dependency(name: 'http', version: '^0.13.3', isDev: false));

  print("Updated Dependencies:");
  print(pubspecEditor.dependencies.list);

  print("Saving changes...");
  pubspecEditor.save();
}
