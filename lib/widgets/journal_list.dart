import 'package:emoapp/model/journal_entry_extended.dart';
import 'package:emoapp/services/journal_entry_extended_service.dart';
import 'package:emoapp/view_model/journal_entry_extended_list_view_model.dart';
import 'package:emoapp/widgets/journal_card.dart';
import 'package:emoapp/widgets/journal_edit_card.dart';
import 'package:emoapp/widgets/emotion_check_in_view.dart';
import 'package:emoapp/widgets/simple_journal_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class JournalList extends StatefulWidget {
  const JournalList(Key key, {this.year = 0, this.month = 0, this.day = 0})
      : super(key: key);
  final int year;
  final int month;
  final int day;

  @override
  State<StatefulWidget> createState() => _JournalList();
}

class _JournalList extends State<JournalList> {
  final key = GlobalKey();
  int year = 0;

  @override
  void initState() {
    if (widget.year == 0) {
      year = DateTime.now().year;
    } else {
      year = widget.year;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<JournalEntryExtendedListViewModel>(
        create: (_) => JournalEntryExtendedListViewModel(),
        child: Consumer<JournalEntryExtendedListViewModel>(
          builder: (context, viewModel, child) =>
              FutureBuilder<Iterable<JournalEntryExtended>>(
            future: widget.month == 0
                ? viewModel.entries(null)
                : viewModel.entries(
                    (j) {
                      if (widget.day > 0) {
                        return j.timeStamp.day == widget.day &&
                            j.timeStamp.month == widget.month &&
                            j.timeStamp.year == year;
                      } else {
                        return j.timeStamp.month == widget.month &&
                            j.timeStamp.year == year;
                      }
                    },
                  ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) return Container();
              final leList = (snapshot.data ?? []).toList();

              DateTime selectedDate = DateTime(year, widget.month, widget.day);
              if (widget.month == 0) {
                selectedDate = DateTime.now();
              }

              return Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: leList.length,
                        itemBuilder: (context, index) => Dismissible(
                          key: GlobalKey(),
                          child: JournalCard(
                            key: GlobalKey(),
                            journalEntry: leList.elementAt(index),
                          ),
                          onDismissed: (direction) async {
                            await GetIt.instance
                                .get<JournalEntryExtendedService>()
                                .destroy(leList.elementAt(index).id)
                                .then(
                                  (value) => leList.removeAt(index),
                                )
                                .then((value) => viewModel.refresh());
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Show a dialog to choose between simple and complex entry
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Create Entry'),
                            content: const Text(
                              'How would you like to create your entry?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('simple'),
                                child: const Text('Quick Entry'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('complex'),
                                child: const Text('Full Editor'),
                              ),
                            ],
                          ),
                        );

                        if (result == null) return;

                        if (result == 'simple') {
                          // Simple entry mode
                          if (!context.mounted) return;
                          final simpleResult =
                              await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (context) => SimpleJournalEntryView(
                                selectedDate: selectedDate,
                              ),
                            ),
                          );

                          if (simpleResult == true && context.mounted) {
                            viewModel.refresh();
                            Navigator.of(context).pop();
                          }
                        } else if (result == 'complex') {
                          // Complex entry mode - show emotion check-in first
                          if (!context.mounted) return;

                          final emotionResult =
                              await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (context) => const Dialog(
                              child: EmotionCheckInView(),
                            ),
                          );

                          if (emotionResult == null) {
                            return;
                          }

                          final emotionIds =
                              emotionResult['emotionIds'] as List<String>? ??
                                  [];
                          final topicId =
                              emotionResult['topicId'] as String? ?? '';

                          if (!context.mounted) return;

                          // Create new entry with selected emotions and topic
                          final newEntry = JournalEntryExtended(
                            id: const Uuid().v4(),
                            text: '',
                            timeStamp: selectedDate,
                            emotionalLevel: 3,
                            type: 0,
                            discussionId: '',
                            title: '',
                            emotionIds: emotionIds,
                            topicId: topicId,
                          );

                          if (context.mounted) {
                            await Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => JournalEditCard(
                                  journalEntry: newEntry,
                                ),
                              ),
                            )
                                .then((value) {
                              viewModel.refresh();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Entry'),
                    ),
                  ),
                ],
              );
              // return ListView.builder(itemBuilder: (context, index) =>
              //   JournalCard(journalEntry: index > (snapshot.data?.length ?? 0) ? snapshot.data?.elementAt(index) : null));
            },
          ),
        ),
      );
}
