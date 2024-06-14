/// Enum for specifying the type of dependencies.
enum DependencyKey { dev, dependencies }

/// Enum for specifying the type of dependencies.
enum DependencyType { hosted, git, path, sdk }

/// Extension on [DependencyKey] to get the string value of the key.
extension DependencyKeyExtension on DependencyKey {
  /// Returns the string value of the key.
  String get value {
    switch (this) {
      case DependencyKey.dev:
        return 'dev_dependencies';
      case DependencyKey.dependencies:
        return 'dependencies';
    }
  }
}

/// Class representing a dependency in the `pubspec.yaml` file.
class Dependency {
  final String name;
  final String version;
  // final DependencyType type;
  // final String? path;
  // final String? git;
  // final String? hosted;
  // final String? sdk;
  // final String? gitRef;
  final bool isDev;

  /// Constructs a new instance of [Dependency].
  Dependency({
    required this.name,
    required this.version,
    // required this.type,
    required this.isDev,
    // this.path,
    // this.git,
    // this.hosted,
    // this.sdk,
    // this.gitRef,
  });

  /// Convert the [Dependency] object to a map.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'version': version,
      'isDev': isDev,
      'name': name,
    };

    // switch (type) {
    //   case DependencyType.hosted:
    //     map['hosted'] = hosted;
    //     break;
    //   case DependencyType.git:
    //     map['git'] = {'uri': git};
    //     if (gitRef != null) {
    //       map['git']['ref'] = gitRef;
    //     }
    //     break;
    //   case DependencyType.path:
    //     map['path'] = path;
    //     break;
    //   case DependencyType.sdk:
    //     map['sdk'] = sdk;
    //     break;
    // }

    return map;
  }
}
