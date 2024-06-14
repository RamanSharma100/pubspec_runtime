/// class for file not found exception
class FileNotFoundException implements Exception {
  /// message for file not found exception
  final String message;

  /// Constructs a new instance of [FileNotFoundException].
  FileNotFoundException(this.message);

  @override
  String toString() => 'FileNotFoundException: $message';
}
