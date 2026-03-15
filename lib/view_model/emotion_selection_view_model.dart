import 'package:emoapp/model/emotion.dart';
import 'package:emoapp/model/default_emotions.dart';
import 'package:emoapp/services/flat_file_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class EmotionSelectionViewModel extends ChangeNotifier {
  final List<String> _selectedEmotionIds = [];
  final Map<String, Emotion> _emotionCache = {};
  List<Emotion>? _allEmotions;
  List<String>? _clusterGroups;

  List<String> get selectedEmotionIds => _selectedEmotionIds;

  /// Get all cluster groups
  Future<List<String>> getClusters() async {
    if (_clusterGroups != null) {
      return _clusterGroups!;
    }
    _clusterGroups = DefaultEmotions.getClusters();
    return _clusterGroups!;
  }

  /// Get all emotions grouped by cluster
  Future<Map<String, List<Emotion>>> getEmotionsByCluster() async {
    final clusters = await getClusters();
    final grouped = <String, List<Emotion>>{};

    for (final cluster in clusters) {
      grouped[cluster] = DefaultEmotions.getEmotionsByCluster(cluster);
    }

    return grouped;
  }

  /// Get all available emotions
  Future<List<Emotion>> getAllEmotions() async {
    if (_allEmotions != null) {
      return _allEmotions!;
    }
    _allEmotions = DefaultEmotions.getAllEmotions();
    return _allEmotions!;
  }

  /// Get emotion by ID, returns empty emotion if not found
  Future<Emotion> getEmotionById(String id) async {
    if (_emotionCache.containsKey(id)) {
      return _emotionCache[id]!;
    }

    final emotion = DefaultEmotions.findEmotionById(id);
    if (emotion != null) {
      _emotionCache[id] = emotion;
      return emotion;
    }

    // Try to fetch from service
    try {
      final service = GetIt.instance.get<FlatFileEntityService<Emotion>>();
      final emotions = await service.where((e) => e.id == id);
      if (emotions.isNotEmpty) {
        final emotion = emotions.first;
        _emotionCache[id] = emotion;
        return emotion;
      }
    } catch (_) {}

    // Return empty emotion if not found
    return Emotion.empty();
  }

  /// Toggle emotion selection
  void toggleEmotion(String emotionId) {
    if (_selectedEmotionIds.contains(emotionId)) {
      _selectedEmotionIds.remove(emotionId);
    } else {
      _selectedEmotionIds.add(emotionId);
    }
    notifyListeners();
  }

  /// Check if emotion is selected
  bool isEmotionSelected(String emotionId) {
    return _selectedEmotionIds.contains(emotionId);
  }

  /// Clear all selected emotions
  void clearSelections() {
    _selectedEmotionIds.clear();
    notifyListeners();
  }

  /// Set emotions from a list of IDs
  void setSelectedEmotions(List<String> emotionIds) {
    _selectedEmotionIds.clear();
    _selectedEmotionIds.addAll(emotionIds);
    notifyListeners();
  }

  /// Get selected emotions
  Future<List<Emotion>> getSelectedEmotions() async {
    final emotions = <Emotion>[];
    for (final id in _selectedEmotionIds) {
      emotions.add(await getEmotionById(id));
    }
    return emotions;
  }
}
