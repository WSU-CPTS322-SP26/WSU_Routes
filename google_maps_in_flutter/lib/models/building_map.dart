// modifed attribute names
import 'package:flutter/material.dart';

class RoomNode {
  final String id;             // e.g. "entrance", "hallway_A", "101"
  final String label;          // display name shown in UI, e.g. "Room 101"
  final Offset position;            // pixel coords matching the SVG viewBox
  final List<String> neighborIDs; // IDs of directly connected nodes

  const RoomNode({
    required this.id,
    required this.label,
    required this.position,
    required this.neighborIDs,
  });
}

class BuildingGraph {
  final Map<String, RoomNode> nodes;

  const BuildingGraph(this.nodes);

  /// Returns an ordered list of node IDs from [startId] to [endId],
  /// or an empty list if no path exists.
  /// TODO: replace stub with Dijkstra / A* implementation
  List<String> findPath(String startId, String endId) {
    return [];
  }

  /// Converts a path (list of node IDs) to canvas Offsets for the PathPainter.
  List<Offset> pathToOffsets(List<String> path) {
    return path
        .where((id) => nodes.containsKey(id))
        .map((id) => nodes[id]!.position)
        .toList();
  }
}
