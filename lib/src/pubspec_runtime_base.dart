import "dart:io";
import "package:pubspec_runtime/src/exceptions/index.dart";

import "parser.dart";
import "dependency.dart";
import "exceptions/file_not_found_exception.dart";

part 'dependency_manager.dart';
part 'dependency_download_watcher.dart';

/// A Dart library for managing the `pubspec.yaml` file at runtime.
///
/// This library provides classes to manage dependencies and assets in the `pubspec.yaml` file.
/// This updates the dependencies and assets dyanmically in the `pubspec.yaml` file at runtime.
class PubspecEditor {
  late final DependencyManager dependencies;
  late final DependencyManager devDependencies;
  late final Parser parser = Parser();
  // late final AssetManager assets;

  late final String _filePath;
  late final Map<String, dynamic> _yamlMap;

  /// Constructs a new instance of [PubspecEditor] with the specified file path.
  ///
  /// Throws a [FileNotFoundException] if the specified file does not exist.
  PubspecEditor() {
    final platformScript = Platform.script;
    final scriptPath = platformScript.toFilePath();
    Directory scriptDir = Directory(scriptPath).parent;
    while (scriptDir.path.isNotEmpty &&
        !scriptDir
            .listSync()
            .any((entity) => entity.path.endsWith('pubspec.yaml'))) {
      scriptDir = scriptDir.parent;
    }
    final filePath = '${scriptDir.path}/pubspec.yaml';
    _filePath = filePath;
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileNotFoundException('File not found: $filePath');
    }

    final content = file.readAsStringSync();
    Map<String, dynamic> parsedYaml = parser.parse(content);
    _yamlMap = parsedYaml;
    dependencies = DependencyManager(_yamlMap, false);
    devDependencies = DependencyManager(_yamlMap, true);
    // assets = AssetManager(_yamlMap);
  }

  /// Save the changes to the `pubspec.yaml` file.
  ///
  /// Throws a [FileNotFoundException] if the specified file does not exist.
  String save() {
    final file = File(_filePath);
    if (!file.existsSync()) {
      throw FileNotFoundException('File not found: $_filePath');
    }

    final yamlString = parser.mapToYamlString(_yamlMap);

    file.writeAsStringSync(yamlString);

    return _filePath;
  }

  /// Get the content of the `pubspec.yaml` file.
  ///
  /// Throws a [FileNotFoundException] if the specified file does not exist.
  ///
  /// Returns the content of the `pubspec.yaml` file.
  Map<String, dynamic> get content {
    final file = File(_filePath);
    if (!file.existsSync()) {
      throw FileNotFoundException('File not found: $_filePath');
    }

    return _yamlMap;
  }

  /// Add key value pair to the `pubspec.yaml` file.
  ///
  /// The [key] parameter is the key to add.
  ///
  /// The [value] parameter is the value to add.
  dynamic add(String key, dynamic value) {
    if (key == 'dependencies' || key == 'dev_dependencies') {
      throw Exception(
          'Use dependencies.add() or devDependencies.add() to add dependencies');
    }

    _yamlMap[key] = value;

    return _yamlMap;
  }

  /// Remove key value pair from the `pubspec.yaml` file.
  ///
  /// The [key] parameter is the key to remove.
  ///
  /// Returns the updated content of the `pubspec.yaml` file.
  dynamic remove(String key) {
    if (!_yamlMap.containsKey(key)) {
      throw Exception('Key not found: $key');
    }
    if (key == 'dependencies' || key == 'dev_dependencies') {
      throw Exception(
          'Use dependencies.remove() or devDependencies.remove() to remove dependencies');
    }
    _yamlMap.remove(key);
    return _yamlMap;
  }

  /// Get the value of a key from the `pubspec.yaml` file.
  ///
  /// The [key] parameter is the key to get.
  ///
  /// Returns the value of the key if it exists, `null` otherwise.
  dynamic get(String key) {
    if (key == 'dependencies') {
      return dependencies.list;
    }
    if (key == 'dev_dependencies') {
      return devDependencies.list;
    }
    return _yamlMap[key];
  }

  /// Check if a key exists in the `pubspec.yaml` file.
  ///
  /// The [key] parameter is the key to check.
  ///
  /// Returns `true` if the key exists, `false` otherwise.
  bool exists(String key) {
    return _yamlMap.containsKey(key);
  }
}
