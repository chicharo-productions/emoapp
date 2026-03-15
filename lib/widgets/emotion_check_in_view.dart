import 'package:emoapp/model/emotion.dart';
import 'package:emoapp/model/topic.dart';
import 'package:emoapp/services/flat_file_service.dart';
import 'package:emoapp/view_model/emotion_selection_view_model.dart';
import 'package:emoapp/widgets/emotion_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class EmotionCheckInView extends StatefulWidget {
  const EmotionCheckInView({Key? key, this.initialEmotionIds = const []})
      : super(key: key);

  final List<String> initialEmotionIds;

  @override
  State<EmotionCheckInView> createState() => _EmotionCheckInViewState();
}

class _EmotionCheckInViewState extends State<EmotionCheckInView> {
  final TextEditingController _titleController = TextEditingController();
  final List<String> _selectedEmotionIds = [];
  String _selectedTopicId = '';
  List<Topic> _availableTopics = [];
  bool _topicsLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedEmotionIds.addAll(widget.initialEmotionIds);
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    try {
      final service = GetIt.instance.get<FlatFileEntityService<Topic>>();
      final topics = await service.getAll();
      final topicsList = topics.toList();

      setState(() {
        _availableTopics = topicsList;
        // Pre-select the first topic
        if (topicsList.isNotEmpty) {
          _selectedTopicId = topicsList.first.id;
        }
        _topicsLoading = false;
      });
    } catch (e) {
      setState(() {
        _topicsLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateSelectedEmotions(List<String> emotionIds) {
    setState(() {
      _selectedEmotionIds.clear();
      _selectedEmotionIds.addAll(emotionIds);
    });
  }

  Future<void> _saveCheckIn() async {
    if (_selectedEmotionIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one emotion'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Return the selected emotions, optional title, and topic ID
    Navigator.of(context).pop({
      'emotionIds': _selectedEmotionIds,
      'title': _titleController.text.isNotEmpty
          ? _titleController.text
          : 'Emotion Check-in - ${DateFormat('HH:mm').format(DateTime.now())}',
      'topicId': _selectedTopicId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How do you feel today?'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Optional title input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Give this check-in a title (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.edit),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 1,
            ),
          ),

          // Topic selector
          if (!_topicsLoading)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topic (Optional)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedTopicId.isEmpty ? null : _selectedTopicId,
                    hint: const Text('Select a topic'),
                    items: _availableTopics.map((topic) {
                      return DropdownMenuItem<String>(
                        value: topic.id,
                        child: Text(topic.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTopicId = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Emotion selector
          Expanded(
            child: EmotionSelector(
              onEmotionsSelected: _updateSelectedEmotions,
              initialEmotionIds: _selectedEmotionIds,
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveCheckIn,
                icon: const Icon(Icons.check),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Save Check-in (${_selectedEmotionIds.length} selected)',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper widget to display emotions inline (useful for viewing emotions in entries)
class EmotionDisplayWidget extends StatelessWidget {
  const EmotionDisplayWidget({
    Key? key,
    required this.emotionIds,
    this.maxDisplay = 5,
  }) : super(key: key);

  final List<String> emotionIds;
  final int maxDisplay;

  @override
  Widget build(BuildContext context) {
    if (emotionIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return ChangeNotifierProvider<EmotionSelectionViewModel>(
      create: (_) => EmotionSelectionViewModel(),
      child: Consumer<EmotionSelectionViewModel>(
        builder: (context, viewModel, _) => FutureBuilder<List<Emotion>>(
          future: Future.wait(
            emotionIds
                .take(maxDisplay)
                .map((id) => viewModel.getEmotionById(id)),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final emotions = snapshot.data ?? [];
            if (emotions.isEmpty) {
              return const SizedBox.shrink();
            }

            return Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...emotions.map(
                  (emotion) => Chip(
                    label: Text('${emotion.emoji} ${emotion.name}'),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                if (emotionIds.length > maxDisplay)
                  Chip(
                    label: Text('+${emotionIds.length - maxDisplay} more'),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
