import 'package:emoapp/model/journal_colors.dart';
import 'package:emoapp/model/journal_entry_extended.dart';
import 'package:emoapp/model/journal_type.dart';
import 'package:emoapp/model/topic.dart';
import 'package:emoapp/services/calendar/day_creator_service.dart';
import 'package:emoapp/view_model/journal_entry_extended_view_model.dart';
// import 'package:emojis_null_safe/emojis.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JournalEditCard extends StatefulWidget {
  const JournalEditCard({required this.journalEntry, Key? key})
      : super(key: key);
  final JournalEntryExtended journalEntry;

  @override
  State<StatefulWidget> createState() => _JournalEditCard();
}

class _JournalEditCard extends State<JournalEditCard> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.journalEntry.text;
    _titleController.text = widget.journalEntry.title;
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<JournalEntryExtendedViewModel>(
        create: (_) => JournalEntryExtendedViewModel(widget.journalEntry),
        child: Consumer<JournalEntryExtendedViewModel>(
          builder: (context, viewModel, nullableWidget) => Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text(''), //widget.journalEntry.id),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    await viewModel.save().then(
                          (value) => Navigator.of(context).pop(),
                        );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text('Type'),
                    DropdownButton(
                      value: viewModel.rawType,
                      items: [
                        JournalType.entry,
                        JournalType.perspective,
                        JournalType.retrospective,
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.stringRepresentation),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => viewModel.type =
                          value?.stringRepresentation ??
                              JournalType.entry.stringRepresentation,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: 'When: ',
                        style: TextStyle(
                          color: secondaryColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: viewModel.timeStamp,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (viewModel.type !=
                                    JournalType.entry.stringRepresentation) {
                                  var validDate =
                                      viewModel.timeStampAsDateTime();
                                  // try {
                                  //   validDate =
                                  //       DateFormat().parse(viewModel);
                                  // } catch (ex) {}
                                  final days = DayCreatorService.getDays(
                                    validDate.month,
                                    validDate.year,
                                  );

                                  final startDate =
                                      DateFormat('dd.MM.yyyy').parse(
                                    '01.${validDate.month.toString().padLeft(2, '0')}.${validDate.year}',
                                  );

                                  final endDate =
                                      DateFormat('dd.MM.yyyy').parse(
                                    '${days.toString().padLeft(2, '0')}.${validDate.month.toString().padLeft(2, '0')}.${validDate.year}',
                                  );

                                  final nextDate = await showDatePicker(
                                    context: context,
                                    initialDate: validDate,
                                    firstDate: startDate,
                                    lastDate: endDate,
                                  );
                                  if (nextDate != null) {
                                    viewModel.setTimeStamp(nextDate);
                                    await viewModel.save();
                                  }
                                }
                              },
                            // style: const TextStyle(
                            //   color: Colors.deepPurple,
                            //   fontSize: 15,
                            //   fontFamily: 'PlayFair',
                            // ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // SliderTheme(
                    //   data: const SliderThemeData(
                    //     thumbColor: Colors.een,
                    //     thumbShape: RoundSliderThumbShape(
                    //       enabledThumbRadius: 20,
                    //     ),
                    //   ),
                    //   child:
                    Slider(
                      // min: 0,
                      max: 5,
                      value: double.parse(
                        viewModel.emotionalLevel.toString(),
                      ),
                      onChanged: (val) {
                        viewModel.emotionalLevel = val.toInt();
                        setState(() {});
                      },
                    ),
                    // ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //           width: 32,
                    //           child: TextButton(
                    //               onPressed: () =>
                    //                   viewModel.emotionalLevel = 1,
                    //               child: Text(Emojis.frowningFace))),
                    //       Container(
                    //           width: 32,
                    //           child: TextButton(
                    //               onPressed: () =>
                    //                   viewModel.emotionalLevel = 2,
                    //               child:
                    //                   Text(Emojis.slightlyFrowningFace))),
                    //       Container(
                    //           width: 32,
                    //           child: TextButton(
                    //               onPressed: () =>
                    //                   viewModel.emotionalLevel = 3,
                    //               child: Text(Emojis.neutralFace))),
                    //       Container(
                    //           width: 32,
                    //           child: TextButton(
                    //               onPressed: () =>
                    //                   viewModel.emotionalLevel = 4,
                    //               child:
                    //                   Text(Emojis.slightlySmilingFace))),
                    //       Container(
                    //           width: 32,
                    //           child: TextButton(
                    //               onPressed: () =>
                    //                   viewModel.emotionalLevel = 5,
                    //               child: Text(Emojis.smilingFace))),
                    //     ]),
                    const SizedBox(height: 10),

                    // Title field
                    const Text('Title (Optional)'),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Journal Entry Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        viewModel.title = value;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Tags section
                    const Text('Tags (Optional)'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              labelText: 'Add a tag',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final tag = _tagController.text.trim();
                            if (tag.isNotEmpty) {
                              viewModel.addTag(tag);
                              _tagController.clear();
                              setState(() {});
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: viewModel.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () {
                            viewModel.removeTag(tag);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Topic selector
                    const Text('Topic (Optional)'),
                    Consumer<JournalEntryExtendedViewModel>(
                      builder: (context, viewModel, child) {
                        return FutureBuilder<List<Topic>>(
                          future: viewModel.getAvailableTopics(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final topics = snapshot.data ?? [];
                            final selectedTopicExists = topics.any(
                              (topic) => topic.id == viewModel.topicId,
                            );

                            return DropdownButton<Topic>(
                              value: selectedTopicExists
                                  ? topics.firstWhere(
                                      (topic) => topic.id == viewModel.topicId,
                                      orElse: () => Topic.emptyTopic(),
                                    )
                                  : null,
                              hint: const Text('Select a topic'),
                              items: topics.map((topic) {
                                return DropdownMenuItem<Topic>(
                                  value: topic,
                                  child: Text(topic.title),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                viewModel.topicId = value.id;
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // HashTagTextField(
                    TextField(
                      maxLines: 30,
                      // style: const TextStyle(fontFamily: 'Playfair'),
                      decoration: const InputDecoration(
                        labelText: 'How are you today?',
                      ),
                      controller: _controller,
                      onChanged: (value) {
                        viewModel.text = value;
                      },

                      // onDetectionTyped: (text) {
                      //   print(text);
                      // },
                      // onDetectionFinished: () {
                      //   print('finished');
                      // },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
