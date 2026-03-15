import 'package:emoapp/model/emotion.dart';
import 'package:emoapp/view_model/emotion_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionSelector extends StatefulWidget {
  const EmotionSelector({
    Key? key,
    this.onEmotionsSelected,
    this.initialEmotionIds = const [],
    this.maxSelections,
  }) : super(key: key);

  final Function(List<String>)? onEmotionsSelected;
  final List<String> initialEmotionIds;
  final int? maxSelections;

  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  String _selectedCluster = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialEmotionIds.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final viewModel =
            Provider.of<EmotionSelectionViewModel>(context, listen: false);
        viewModel.setSelectedEmotions(widget.initialEmotionIds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmotionSelectionViewModel>(
      create: (_) => EmotionSelectionViewModel(),
      child: Consumer<EmotionSelectionViewModel>(
        builder: (context, viewModel, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and selected count
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'How do you feel today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (viewModel.selectedEmotionIds.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${viewModel.selectedEmotionIds.length} selected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Cluster group tabs
            FutureBuilder<List<String>>(
              future: viewModel.getClusters(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final clusters = snapshot.data ?? [];
                if (_selectedCluster.isEmpty && clusters.isNotEmpty) {
                  _selectedCluster = clusters.first;
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: clusters
                          .map(
                            (cluster) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: FilterChip(
                                label: Text(
                                  cluster[0].toUpperCase() +
                                      cluster.substring(1),
                                ),
                                selected: _selectedCluster == cluster,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCluster = cluster;
                                    });
                                  }
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Emotions grid for selected cluster
            Expanded(
              child: FutureBuilder<Map<String, List<Emotion>>>(
                future: viewModel.getEmotionsByCluster(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final emotionsByCluster = snapshot.data ?? {};
                  final emotions = emotionsByCluster[_selectedCluster] ?? [];

                  if (emotions.isEmpty) {
                    return const Center(
                      child: Text('No emotions in this category'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: emotions.length,
                    itemBuilder: (context, index) {
                      final emotion = emotions[index];
                      final isSelected =
                          viewModel.isEmotionSelected(emotion.id);
                      final canSelect = widget.maxSelections == null ||
                          isSelected ||
                          viewModel.selectedEmotionIds.length <
                              widget.maxSelections!;

                      return GestureDetector(
                        onTap: canSelect
                            ? () {
                                viewModel.toggleEmotion(emotion.id);
                                widget.onEmotionsSelected
                                    ?.call(viewModel.selectedEmotionIds);
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                emotion.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  emotion.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
