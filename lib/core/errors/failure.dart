class Failure implements Exception {
  final String message;
  final dynamic originalError;
  
  Failure(this.message, [this.originalError]);
  
  @override
  String toString() => message;
}