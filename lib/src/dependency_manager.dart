part of 'pubspec_runtime_base.dart';

/// A class to manage dependencies and assets in the `pubspec.yaml` file.
class DependencyManager {
  final Map<String, dynamic> _yamlMap;
  final List<Dependency> dependencies = [];
  final bool isDev;

  DependencyManager(this._yamlMap, this.isDev) {
    Map<String, dynamic> deps = isDev
        ? _yamlMap['dev_dependencies'] as Map<String, dynamic>? ?? {}
        : _yamlMap['dependencies'] as Map<String, dynamic>? ?? {};

    if (deps.isNotEmpty) {
      if (deps.containsKey("list")) {
        deps['list'].forEach((element) {
          dependencies.add(Dependency(
            name: element["name"],
            version: element["version"],
            isDev: isDev,
          ));
        });
      }
    }
  }

  List<dynamic> get list => dependencies.map((e) => e.toMap()).toList();

  /// Get a dependency from the `pubspec.yaml` file.
  ///
  /// The [name] parameter is the name of the dependency to get.
  ///
  /// Returns the dependency if it exists, `null` otherwise.
  dynamic get(String name) => {
        if (dependencies.any((element) => element.name == name))
          {dependencies.firstWhere((element) => element.name == name)}
        else
          {null}
      };

  /// Check if a dependency exists in the `pubspec.yaml` file.
  ///
  /// The [name] parameter is the name of the dependency to check.
  ///
  /// Returns `true` if the dependency exists, `false` otherwise.
  bool exists(String name) {
    return dependencies.any((element) => element.name == name);
  }

  /// Add or update a dependency in the `pubspec.yaml` file.
  ///
  /// The [dependency] parameter is a [Dependency] object.
  /// The [key] parameter is a [DependencyKey] object.

  void add(Dependency dependency) {
    final keys = dependency.isDev ? 'dev_dependencies' : 'dependencies';

    print(_yamlMap[keys]);

    if (dependencies.any((element) => element.name == dependency.name)) {
      update(dependency);
    } else {
      dependencies.add(dependency);
      if (_yamlMap[keys] == null) {
        _yamlMap[keys] = {};
      }
      _yamlMap[keys]["list"] = dependencies.map((e) => e.toMap()).toList();
    }
  }

  /// Remove a dependency from the `pubspec.yaml` file.
  ///
  /// The [name] parameter is the name of the dependency to remove.
  /// The [key] parameter is a [DependencyKey] object.
  ///
  /// Returns `true` if the dependency was removed, `false` otherwise.

  bool remove(String name) {
    final keys = isDev ? 'dev_dependencies' : 'dependencies';

    if (dependencies.any((element) => element.name == name)) {
      dependencies.removeWhere((element) => element.name == name);
      if (_yamlMap[keys] == null) {
        _yamlMap[keys] = {};
      }
      _yamlMap[keys]["list"] = dependencies.map((e) => e.toMap()).toList();
      return true;
    }

    return false;
  }

  /// update a dependency in the `pubspec.yaml` file.
  ///
  /// The [dependency] parameter is a [Dependency] object.
  ///
  /// The [key] parameter is a [DependencyKey] object.
  ///
  /// Returns `true` if the dependency was updated, `false` otherwise.

  bool update(Dependency dependency) {
    final keys = dependency.isDev ? 'dev_dependencies' : 'dependencies';

    if (dependencies.any((element) => element.name == dependency.name)) {
      dependencies.removeWhere((element) => element.name == dependency.name);
      dependencies.add(dependency);
      if (_yamlMap[keys] == null) {
        _yamlMap[keys] = {};
      }
      _yamlMap[keys]["list"] = dependencies.map((e) => e.toMap()).toList();
      return true;
    }

    return false;
  }

  /// Returns the string representation of the [DependencyManager] object.
  ///
  /// The string representation is the list of dependencies.
  ///
  /// Returns the string representation of the [DependencyManager] object.
  @override
  String toString() => dependencies.toString();

  /// Convert the [dependencies] to yaml string.
  ///
  /// Returns the yaml string of the [dependencies].
  String toYamlString() {
    final buffer = StringBuffer();
    for (var element in dependencies) {
      buffer.writeln('${element.name}: ${element.version}');
    }
    return buffer.toString();
  }

  /// Convert the [DependencyManager] object to a map.
  ///
  /// Returns the map representation of the [DependencyManager] object.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    for (var element in dependencies) {
      map[element.name] = element.version;
    }
    return map;
  }
}
