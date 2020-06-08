import 'package:flickr_demo/database/application_database.dart';
import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:sembast/sembast.dart';

class FavoritePhotosDao {
  static const String STORE_NAME = 'favorites';

  final _store = stringMapStoreFactory.store(STORE_NAME);

  Future<Database> get _db async => await ApplicationDatabase.instance.database;

  Future insert(FlickrPhoto photo) async {
    await _store.record(photo.uuid).put(await _db, photo.toMap());
  }

  Future update(FlickrPhoto photo) async {
    final finder = Finder(filter: Filter.byKey(photo.uuid));
    final updateCount =
        await _store.update(await _db, photo.toMap(), finder: finder);
    print('update count: $updateCount  UUID=${photo.uuid}');
  }

  Future delete(FlickrPhoto photo) async {
    final finder = Finder(filter: Filter.byKey(photo.uuid));
    final deleteCount = await _store.delete(await _db, finder: finder);

    print('delete count: $deleteCount  UUID=${photo.uuid}');

    // final something = await _store.record(photo.uuid).delete(await _db);
    // print('$something');
  }

  Future<List<FlickrPhoto>> getFavoritePhotos() async {
    final finder = Finder(sortOrders: [SortOrder('id')]);
    final snapshots = await _store.find(await _db, finder: finder);
    return snapshots
        .map((snapshot) => FlickrPhoto.fromJson(snapshot.value))
        .toList();
  }

  Future<bool> contains(FlickrPhoto photo) async {
    final values = await _store.record(photo.uuid).get(await _db);
    if (values == null) {
      print('${photo.uuid} NOT Found');
      return false;
    } else {
      return true;
    }
  }
}
