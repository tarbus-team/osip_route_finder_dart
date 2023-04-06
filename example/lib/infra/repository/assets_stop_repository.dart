import 'dart:convert';

import 'package:example/infra/entity/stop_entity.dart';
import 'package:example/utils/file_utils.dart';

class AssetsStopRepository {
  
  Future<StopEntity> getById(int id) async {
    List<StopEntity> stops = await getAll();
    return stops.firstWhere((StopEntity e) => e.id == id);
  }
  
  Future<List<StopEntity>> getAll() async {
    String assetsEdges = await FileUtils.readAssetFile('stops.json');
    List<dynamic> stopsMap = jsonDecode(assetsEdges) as List<dynamic>;

    List<StopEntity> stopEntities = stopsMap.map((dynamic e) {
      Map<String, dynamic> stopMap = e as Map<String, dynamic>;
      return StopEntity.fromJson(stopMap);
    }).toList();

    return stopEntities;
  }
}
