import 'package:sqflite/sqflite.dart';
import 'app_exception.dart';

class DatabaseErrorHandler {
  static AppException handle(Object error) {
    if (error is DatabaseException) {
      if (error.isUniqueConstraintError()) {
        return const AppException('This item already exists.');
      }

      if (error.toString().contains('FOREIGN KEY')) {
        return const AppException('Invalid reference.');
      }

      if (error.toString().contains('CHECK constraint failed')) {
        return const AppException('Invalid value.');
      }

      return const AppException('Database error.');
    }

    return const AppException('Unexpected error.');
  }
}
