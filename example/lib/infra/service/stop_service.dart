import 'package:example/infra/entity/stop_entity.dart';
import 'package:example/infra/repository/assets_stop_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:osip_route_finder_dart/src/models/node/stop_node.dart';

class StopService {
  final AssetsStopRepository stopRepository = AssetsStopRepository();
  
  Future<List<StopNode>> getAll() async {
    List<StopEntity> stopEntityList = await stopRepository.getAll();
    return stopEntityList.map((StopEntity stopEntity) => StopNode(
      id: stopEntity.id.toString(),
      latLng: LatLng(stopEntity.lat, stopEntity.lng),
      name: stopEntity.name,
    )).toList();
  }
  
  Future<StopNode> getRandomStopVertex() async {
    List<StopNode> stopVertexList = await getAll();
    stopVertexList.shuffle();
    return stopVertexList.first;
  }
}