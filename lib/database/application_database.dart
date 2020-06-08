import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ApplicationDatabase {
  static ApplicationDatabase _singleton = ApplicationDatabase._();
  static ApplicationDatabase get instance => _singleton;

  Completer<Database> _dbOpenCompleter;

  ApplicationDatabase._();

  Future<Database> get database {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDir.path, 'favoritephotos');
    print('DBPATH => $dbPath');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter.complete(database);
  }
}
