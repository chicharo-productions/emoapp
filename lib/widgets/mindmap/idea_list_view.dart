import 'package:emoapp/view_model/mindmap_view_model.dart';
import 'package:emoapp/widgets/mindmap/edit_idea_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// List view display of all ideas for the user
class IdeaListView extends StatefulWidget {
  const IdeaListView({
    Key? key,
    this.currentUserUuid,
  }) : super(key: key);

  final String? currentUserUuid;

  @override
  State<IdeaListView> createState() => _IdeaListViewState();
}

class _IdeaListViewState extends State<IdeaListView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MindmapViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ideas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (query) {
                      viewModel.searchQuery = query;
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.searchQuery = '';
                    },
                  ),
              ],
            ),
          ),
          // Ideas list
          Expanded(
            child: viewModel.filteredIdeas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No ideas yet. Create one in the mindmap!'
                              : 'No ideas match your search.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: viewModel.filteredIdeas.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final idea = viewModel.filteredIdeas[index];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[100],
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                idea.references.length.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            idea.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                idea.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (idea.referencedTopic.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Chip(
                                        label: Text(
                                          idea.referencedTopic,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        backgroundColor: Colors.green[100],
                                        side: BorderSide(
                                          color: Colors.green[300]!,
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  if (idea.references.isNotEmpty)
                                    Chip(
                                      label: Text(
                                        '${idea.references.length} linked',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: Colors.orange[100],
                                      side: BorderSide(
                                        color: Colors.orange[300]!,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    viewModel.selectIdea(idea);
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ChangeNotifierProvider.value(
                                        value: viewModel,
                                        child: EditIdeaDialog(
                                          idea: idea,
                                          currentUserUuid:
                                              widget.currentUserUuid,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    if (idea.canEdit(widget.currentUserUuid)) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Idea?'),
                                          content: const Text(
                                            'This action cannot be undone.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await viewModel
                                                    .deleteIdea(idea.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You do not have permission to delete this idea.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            viewModel.selectIdea(idea);
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                value: viewModel,
                                child: EditIdeaDialog(
                                  idea: idea,
                                  currentUserUuid: widget.currentUserUuid,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
