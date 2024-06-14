import "asset.dart";

/// A class to manage assets in the `pubspec.yaml` file.
class AssetManager {
  final Map<String, dynamic> _yamlMap;

  /// Constructs a new instance of [AssetManager].
  AssetManager(this._yamlMap);

  /// Get the assets from the `pubspec.yaml` file.
  ///
  /// Returns a [List] of [Asset] objects.
  ///
  /// If there are no assets, an empty [List] is returned.
  List<String> get() {
    final assets = _yamlMap['flutter']?['assets'] as List<dynamic>? ?? [];
    return assets.map((e) => e.toString()).toList();
  }

  /// Add an asset to the `pubspec.yaml` file.
  ///
  /// The [asset] parameter is an [Asset] object.
  ///
  /// Returns `true` if the asset was added, `false` otherwise.
  bool add(Asset asset) {
    final section = _yamlMap['flutter'] as Map<String, dynamic>? ?? {};
    final assets = section['assets'] as List<dynamic>? ?? [];

    if (assets.contains(asset.path)) {
      return true;
    }

    assets.add(asset.path);
    section['assets'] = assets;
    _yamlMap['flutter'] = section;

    return true;
  }

  /// Remove an asset from the `pubspec.yaml` file.
  ///
  /// The [asset] parameter is an [Asset] object.
  ///
  /// Returns `true` if the asset was removed, `false` otherwise.
  ///
  /// If the asset is not found, `false` is returned.
  bool remove(Asset asset) {
    final section = _yamlMap['flutter'] as Map<String, dynamic>? ?? {};
    final assets = section['assets'] as List<dynamic>? ?? [];

    if (!assets.contains(asset.path)) {
      return true;
    }

    assets.remove(asset.path);
    section['assets'] = assets;
    _yamlMap['flutter'] = section;

    return true;
  }

  /// Update an asset in the `pubspec.yaml` file.
  ///
  /// The [oldAsset] parameter is an [Asset] object.
  ///
  /// The [newAsset] parameter is an [Asset] object.
  ///
  /// Returns `true` if the asset was updated, `false` otherwise.

  bool update(Asset oldAsset, Asset newAsset) {
    final section = _yamlMap['flutter'] as Map<String, dynamic>? ?? {};
    final assets = section['assets'] as List<dynamic>? ?? [];

    if (!assets.contains(oldAsset.path)) {
      return false;
    }

    final index = assets.indexOf(oldAsset.path);
    assets[index] = newAsset.path;
    section['assets'] = assets;
    _yamlMap['flutter'] = section;

    return true;
  }
}
