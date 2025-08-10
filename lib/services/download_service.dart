// Conditional export to provide platform-specific implementations
export 'download_service_io.dart'
  if (dart.library.html) 'download_service_web.dart';