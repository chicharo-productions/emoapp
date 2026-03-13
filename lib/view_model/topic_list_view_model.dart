import 'dart:async';
import 'package:emoapp/model/topic.dart';
import 'package:emoapp/services/sqf_entity_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class TopicListViewModel extends ChangeNotifier {
  Future<List<Topic>> topics(
    bool Function(Topic)? predicate,
  ) async =>
      _updateTopics(predicate);

  List<Topic> _cachedTopics = [];

  Future<List<Topic>> _updateTopics(
    bool Function(Topic)? predicate,
  ) async {
    final service = GetIt.instance.get<FlatFileEntityService<Topic>>();
    if (predicate == null) {
      _cachedTopics = (await service.getAll()).toList();
    } else {
      _cachedTopics =
          (await service.getAll()).where((element) => predicate(element)).toList();
    }
    // Sort by updatedAt descending (newest first)
    _cachedTopics.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return _cachedTopics;
  }

  Future<List<Topic>> topicsCached(
    bool Function(Topic)? predicate,
  ) async {
    if (_cachedTopics.isEmpty) _cachedTopics = await topics(predicate);
    return _cachedTopics;
  }

  Future<List<Topic>> searchTopics(String query) async {
    return await topics((topic) =>
        topic.title.toLowerCase().contains(query.toLowerCase()) ||
        topic.description.toLowerCase().contains(query.toLowerCase()));
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
