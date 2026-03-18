import 'package:emoapp/model/idea.dart';
import 'package:emoapp/services/flat_file_service.dart';

/// Service for managing ideas in the mindmap
/// Extends FlatFileEntityService to provide CRUD operations
class IdeaService extends FlatFileEntityService<Idea> {
  IdeaService(super.entityValidation, super.sdb);

  /// Get all ideas for a specific owner
  Future<Iterable<Idea>> getByOwner(String ownerUuid) async {
    final allIdeas = await getAll();
    return allIdeas.where((idea) => idea.ownerUuid == ownerUuid);
  }

  /// Get all ideas in a specific visibility group
  Future<Iterable<Idea>> getByGroup(String groupUuid) async {
    final allIdeas = await getAll();
    return allIdeas.where((idea) => idea.groupUuid == groupUuid);
  }

  /// Get all ideas that reference a specific idea
  Future<Iterable<Idea>> getReferences(String ideaUuid) async {
    final allIdeas = await getAll();
    return allIdeas.where((idea) =>
        idea.references.any((ref) => ref.ideaUuid == ideaUuid));
  }

  /// Get ideas within a specific area (bounding box) on the canvas
  /// Useful for spatial queries in the mindmap visualization
  Future<Iterable<Idea>> getIdeasInArea({
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
  }) async {
    final allIdeas = await getAll();
    return allIdeas.where((idea) =>
        idea.positionX >= minX &&
        idea.positionX <= maxX &&
        idea.positionY >= minY &&
        idea.positionY <= maxY);
  }
}
