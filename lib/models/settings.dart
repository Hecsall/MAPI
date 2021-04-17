import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings {

  @HiveField(0)
  DateTime mangaListLastUpdated;

  Settings({
    this.mangaListLastUpdated
  });
}



