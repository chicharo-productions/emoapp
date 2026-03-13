import 'package:emoapp/model/journal_entry_extended.dart';
import 'package:emoapp/model/journal_type.dart';
import 'package:emoapp/model/topic.dart';
import 'package:emoapp/services/journal_entry_extended_service.dart';
import 'package:emoapp/services/service_locator.dart';
import 'package:emoapp/services/sqf_entity_service.dart';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class JournalEntryExtendedViewModel extends ChangeNotifier {
  JournalEntryExtendedViewModel(JournalEntryExtended model) {
    _unchangedModel = model;
    _model = JournalEntryExtended(
      id: _unchangedModel.id,
      text: _unchangedModel.text,
      timeStamp: _unchangedModel.timeStamp,
      emotionalLevel: _unchangedModel.emotionalLevel,
      type: model.type,
      discussionId: model.discussionId,
      title: _unchangedModel.title,
      tags: List.from(_unchangedModel.tags),
      topicId: _unchangedModel.topicId,
    );
  }
  final serviceLocator = ServiceLocatorRegistrar();
  late JournalEntryExtended _model;
  late JournalEntryExtended _unchangedModel;

  String get id => _model.id;

  String get type => JournalType.values
      .firstWhere((element) => element.value == _model.type)
      .stringRepresentation;
  // {
  // if (_model.type == JournalType.retrospective.index)
  //   return RetrospectiveString;
  // if (_model.type == JournalType.entry.index) return EntryString;
  // if (_model.type == JournalType.perspective.index) return PerspectiveString;
  //   return '';
  // }

  JournalType get rawType => JournalType.values.firstWhere(
        (jt) => jt.value == _model.type,
        orElse: () => JournalType.entry,
      );

  set type(String value) {
    _model.type = JournalType.values
        .firstWhere((element) => element.stringRepresentation == value)
        .value;
    // switch (value) {
    //   case RetrospectiveString:
    //     _model.type = JournalType.retrospective.value;
    //     break;
    //   case EntryString:
    //     _model.type = JournalType.entry.value;
    //     break;
    //   case PerspectiveString:
    //     _model.type = JournalType.perspective.value;
    //     break;
    // }

    notifyListeners();
  }

  String get text => _model.text;
  set text(String value) {
    _model.text = value;
    notifyListeners();
  }

  String get timeStamp =>
      DateFormat.yMd().add_jm().format(_model.timeStamp.toLocal());
  void setTimeStamp(DateTime value) {
    _model.timeStamp = value;
    notifyListeners();
  }

  DateTime timeStampAsDateTime() => _model.timeStamp;

  int get emotionalLevel => _model.emotionalLevel;
  set emotionalLevel(int level) {
    _model.emotionalLevel = level;
    notifyListeners();
  }

  String get emotionalLevelAsIcon {
    switch (emotionalLevel) {
      case 1:
        return '';
      case 2:
        return '';
      case 3:
        return '';
      case 4:
        return '';
      case 5:
        return '';
      default:
        return '?';
    }
  }

  String get topicId => _model.topicId;
  set topicId(String value) {
    _model.topicId = value;
    notifyListeners();
  }

  String get title => _model.title;
  set title(String value) {
    _model.title = value;
    notifyListeners();
  }

  List<String> get tags => _model.tags;
  set tags(List<String> value) {
    _model.tags = value;
    notifyListeners();
  }

  void addTag(String tag) {
    if (!_model.tags.contains(tag)) {
      _model.tags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _model.tags.remove(tag);
    notifyListeners();
  }

  Future<List<Topic>> getAvailableTopics() async {
    final service = GetIt.instance.get<FlatFileEntityService<Topic>>();
    return (await service.getAll()).toList();
  }

  Future<void> save() async {
    _unchangedModel
      ..text = _model.text
      ..emotionalLevel = _model.emotionalLevel
      // ..hashtags = _model.hashtags
      ..timeStamp = _model.timeStamp
      ..type = _model.type
      ..discussionId = _model.discussionId
      ..topicId = _model.topicId
      ..title = _model.title
      ..tags = _model.tags;

    await GetIt.instance
        .get<JournalEntryExtendedService>()
        .save(_model)
        .then((value) => notifyListeners());
  }

  Future<void> refresh() async {
    _model = (await GetIt.instance
        .get<JournalEntryExtendedService>()
        .getById(_model.id))!;
    _unchangedModel
      ..emotionalLevel = _model.emotionalLevel
      // ..hashtags = _model.hashtags
      ..text = _model.text
      ..timeStamp = _model.timeStamp
      ..type = _model.type
      ..discussionId = _model.discussionId
      ..topicId = _model.topicId
      ..title = _model.title
      ..tags = _model.tags;
    notifyListeners();
  }

  Future<void> delete() async {
    await GetIt.instance.get<JournalEntryExtendedService>().destroy(id);
  }
}
