import 'package:emoapp/model/journal_entry_extended.dart';
import 'package:emoapp/widgets/emotion_check_in_view.dart';
import 'package:flutter/material.dart';

/// Example integration of emotions with journal entry creation
/// This shows how to combine emotion selection with journal entries
class JournalEntryWithEmotions extends StatefulWidget {
  const JournalEntryWithEmotions({
    Key? key,
    required this.journalEntry,
    this.onEmotionsUpdated,
  }) : super(key: key);

  final JournalEntryExtended journalEntry;
  final Function(List<String>)? onEmotionsUpdated;

  @override
  State<JournalEntryWithEmotions> createState() =>
      _JournalEntryWithEmotionsState();
}

class _JournalEntryWithEmotionsState extends State<JournalEntryWithEmotions> {
  late List<String> _emotionIds;

  @override
  void initState() {
    super.initState();
    _emotionIds = List.from(widget.journalEntry.emotionIds);
  }

  void _openEmotionSelector() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => Dialog(
        child: EmotionCheckInView(
          initialEmotionIds: _emotionIds,
        ),
      ),
    );

    if (result != null && result['emotionIds'] is List<String>) {
      setState(() {
        _emotionIds = result['emotionIds'];
      });
      widget.onEmotionsUpdated?.call(_emotionIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show selected emotions
        if (_emotionIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Associated Emotions:'),
                const SizedBox(height: 8),
                EmotionDisplayWidget(
                  emotionIds: _emotionIds,
                  maxDisplay: 10,
                ),
              ],
            ),
          ),

        // Button to open emotion selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton.icon(
            onPressed: _openEmotionSelector,
            icon: const Icon(Icons.sentiment_satisfied),
            label: Text(
              _emotionIds.isEmpty
                  ? 'Add Emotions'
                  : 'Update Emotions (${_emotionIds.length})',
            ),
          ),
        ),
      ],
    );
  }
}
