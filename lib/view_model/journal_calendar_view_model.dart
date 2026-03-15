import 'package:emoapp/model/journal_entry_extended.dart';
import 'package:emoapp/model/journal_type.dart';
import 'package:emoapp/model/topic.dart';
import 'package:emoapp/services/journal_entry_extended_service.dart';
import 'package:emoapp/services/flat_file_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class JournalCalendarViewModel extends ChangeNotifier {
  JournalCalendarViewModel(int month) {
    _currentMonth = month;
    _selectedTopicIds = {};
  }
  late int _currentMonth;
  late Set<String> _selectedTopicIds;

  int get currentMonth => _currentMonth;
  Set<String> get selectedTopicIds => _selectedTopicIds;

  void nextMonth() {
    if (_currentMonth == 12) {
      _currentMonth = 1;
    } else {
      _currentMonth++;
    }
    notifyListeners();
  }

  void previousMonth() {
    if (_currentMonth == 1) {
      _currentMonth = 12;
    } else {
      _currentMonth--;
    }
    notifyListeners();
  }

  set currentMonth(int value) {
    _currentMonth = value;
    notifyListeners();
  }

  void toggleTopic(String topicId) {
    if (_selectedTopicIds.contains(topicId)) {
      _selectedTopicIds.remove(topicId);
    } else {
      _selectedTopicIds.add(topicId);
    }
    notifyListeners();
  }

  void clearTopicFilter() {
    _selectedTopicIds.clear();
    notifyListeners();
  }

  Future<List<Topic>> getAvailableTopics() async {
    try {
      final topicService = GetIt.instance.get<FlatFileEntityService<Topic>>();
      final allTopics = await topicService.getAll();
      return allTopics.toList();
    } catch (_) {
      return [];
    }
  }

  Future<Iterable<JournalEntryExtended>> entries() async {
    final allEntries =
        (await GetIt.instance.get<JournalEntryExtendedService>().getAll())
            .where((je) => je.timeStamp.month == _currentMonth);

    // If no topics are selected, show all entries
    if (_selectedTopicIds.isEmpty) {
      return allEntries;
    }

    // Filter by selected topics
    return allEntries.where(
      (je) => _selectedTopicIds.contains(je.topicId),
    );
  }

  Future<Iterable<JournalEntryExtended>> dayPerspectives(DateTime date) async =>
      (await GetIt.instance.get<JournalEntryExtendedService>().getAll()).where(
        (j) =>
            j.type == JournalType.perspective.index &&
            j.timeStamp.day == date.day &&
            j.timeStamp.month == date.month &&
            j.timeStamp.year == date.year &&
            (_selectedTopicIds.isEmpty ||
                _selectedTopicIds.contains(j.topicId)),
      );

  Future<Iterable<JournalEntryExtended>> dayRetrospectives(
    DateTime date,
  ) async =>
      (await GetIt.instance.get<JournalEntryExtendedService>().getAll()).where(
        (j) =>
            j.type == JournalType.retrospective.index &&
            j.timeStamp.day == date.day &&
            j.timeStamp.month == date.month &&
            j.timeStamp.year == date.year &&
            (_selectedTopicIds.isEmpty ||
                _selectedTopicIds.contains(j.topicId)),
      );

  Future<Iterable<JournalEntryExtended>> dayJournalEntries(
    DateTime date,
  ) async =>
      (await GetIt.instance.get<JournalEntryExtendedService>().getAll()).where(
        (j) =>
            j.type == JournalType.entry.index &&
            j.timeStamp.day == date.day &&
            j.timeStamp.month == date.month &&
            j.timeStamp.year == date.year &&
            (_selectedTopicIds.isEmpty ||
                _selectedTopicIds.contains(j.topicId)),
      );
}
