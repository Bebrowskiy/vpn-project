import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveService {
  static late Box box;

  static Future<void> init() async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    box = await Hive.openBox('app_data');
  }

  static Future<void> saveData(String key, dynamic value) async {
    await box.put(key, value);
  }

  static dynamic getData(String key) {
    return box.get(key);
  }

  static Future<void> deleteData(String key) async {
    await box.delete(key);
  }
}