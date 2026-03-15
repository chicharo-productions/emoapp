# Emotion System Documentation

## Overview

The emotion system allows users to track and associate specific emotions with their journal entries. Each emotion has:
- **Emoji**: A visual representation
- **Name**: The emotion name (e.g., "Angry", "Happy")
- **Cluster Group**: A category the emotion belongs to (e.g., "anger", "joy", "sadness")
- **Value**: An intensity level (0-10)
- **Description**: Optional description of the emotion

## Architecture

### Models

#### `Emotion` Model (`lib/model/emotion.dart`)
- Extends `EntityBase<Emotion>` for persistence
- JSON serializable for storage
- Has a factory method `Emotion.empty()` for fallback display when emotions are not found

#### `JournalEntryExtended` Updates
- Added `emotionIds: List<String>` field
- Stores IDs of associated emotions (not the full emotion objects)
- This is a reference-based approach for lightweight storage

### Services

#### `EmotionService` (`lib/services/emotion_service.dart`)
- Extends `FlatFileEntityService<Emotion>`
- Manages emotion CRUD operations

#### Service Locator Registration
- Automatically registers emotions on app startup
- Initializes default emotions if database is empty
- Accessible via: `GetIt.instance.get<FlatFileEntityService<Emotion>>()`

### Default Emotions

The app comes with a comprehensive set of default emotions organized into clusters:

1. **Anger**: Furious, Angry, Irritated, Frustrated
2. **Joy**: Ecstatic, Happy, Cheerful, Relieved, Grateful
3. **Sadness**: Devastated, Sad, Melancholic, Disappointed, Lonely
4. **Fear**: Terrified, Afraid, Anxious, Nervous, Insecure
5. **Disgust**: Repulsed, Disgusted, Aversion
6. **Guilt**: Ashamed, Guilty, Regretful
7. **Surprise**: Amazed, Surprised, Awed
8. **Love**: Loved, Loving, Tender, Affectionate
9. **Neutral**: Calm, Indifferent, Bored
10. **Pride**: Proud, Confident
11. **Excitement**: Excited, Hopeful, Eager

## Usage

### 1. Using the Emotion Check-In View

Open the full emotion selection screen:

```dart
final result = await Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const EmotionCheckInView(),
  ),
);

if (result != null) {
  final emotionIds = result['emotionIds'] as List<String>;
  final title = result['title'] as String;
  // Use the emotions...
}
```

### 2. Using the Emotion Selector Widget

Embed the emotion selector in your own UI:

```dart
EmotionSelector(
  onEmotionsSelected: (emotionIds) {
    // Handle selected emotions
  },
  initialEmotionIds: existingEmotionIds,
  maxSelections: 5, // Optional: limit selections
)
```

### 3. Displaying Emotions

Show selected emotions in a formatted way:

```dart
EmotionDisplayWidget(
  emotionIds: journalEntry.emotionIds,
  maxDisplay: 5,
)
```

### 4. Using Emotions with Journal Entries

Integrate emotions when creating/editing journal entries:

```dart
// In JournalEditCard, add:
JournalEntryWithEmotions(
  journalEntry: widget.journalEntry,
  onEmotionsUpdated: (emotionIds) {
    viewModel.emotionIds = emotionIds;
  },
)

// When saving:
final updatedEntry = JournalEntryExtended(
  id: journalEntry.id,
  text: _controller.text,
  timeStamp: journalEntry.timeStamp,
  emotionalLevel: journalEntry.emotionalLevel,
  type: journalEntry.type,
  discussionId: journalEntry.discussionId,
  emotionIds: selectedEmotionIds, // Pass the selected emotion IDs
);
await entryService.create(updatedEntry);
```

## View Model: `EmotionSelectionViewModel`

Provides state management for emotion selection:

```dart
final viewModel = EmotionSelectionViewModel();

// Get all emotions
final allEmotions = await viewModel.getAllEmotions();

// Get emotions by cluster
final emotionsByCluster = await viewModel.getEmotionsByCluster();

// Get clusters
final clusters = await viewModel.getClusters();

// Get specific emotion
final emotion = await viewModel.getEmotionById(emotionId);

// Manage selections
viewModel.toggleEmotion(emotionId);
viewModel.setSelectedEmotions(emotionIds);
viewModel.clearSelections();
viewModel.isEmotionSelected(emotionId);

// Get selected emotions
final selected = await viewModel.getSelectedEmotions();
```

## Integration Steps

### Step 1: Update JournalEditCard

Add emotion selection to the journal entry editor:

```dart
// In lib/widgets/journal_edit_card.dart

import 'package:emoapp/widgets/journal_entry_with_emotions.dart';

// In the build method, add:
JournalEntryWithEmotions(
  journalEntry: widget.journalEntry,
  onEmotionsUpdated: (emotionIds) {
    viewModel.setEmotionIds(emotionIds);
  },
),

// When saving, ensure emotionIds are included:
_updatedEntry = JournalEntryExtended(
  // ... other fields ...
  emotionIds: viewModel.emotionIds,
);
```

### Step 2: Update JournalCard

Display emotions when viewing entries:

```dart
// In lib/widgets/journal_card.dart

import 'package:emoapp/widgets/emotion_check_in_view.dart';

// In the subtitle or below the title:
EmotionDisplayWidget(
  emotionIds: widget.journalEntry.emotionIds,
  maxDisplay: 3,
),
```

### Step 3: Add "How do you feel today?" Button

Add a quick emotion check-in button to the dashboard:

```dart
FloatingActionButton.extended(
  onPressed: () async {
    final result = await showDialog(
      context: context,
      builder: (context) => const Dialog(
        child: EmotionCheckInView(),
      ),
    );
    if (result != null) {
      // Create a journal entry with the selected emotions
      final entry = JournalEntryExtended(
        id: const Uuid().v4(),
        text: result['title'],
        timeStamp: DateTime.now(),
        emotionalLevel: 5,
        type: JournalType.entry.index,
        discussionId: '',
        emotionIds: result['emotionIds'],
      );
      // Save the entry...
    }
  },
  label: const Text('How do you feel?'),
  icon: const Icon(Icons.sentiment_satisfied),
)
```

## Database Persistence

- Emotions are stored in the flat file database
- JournalEntryExtended stores only emotion IDs (not full objects)
- When displaying emotions, IDs are resolved to Emotion objects
- If an emotion is deleted but still referenced, `Emotion.empty()` is shown

## Considerations

1. **Performance**: Emotion objects are cached in `EmotionSelectionViewModel` to avoid repeated database queries
2. **Extensibility**: New emotions can be added to `DefaultEmotions` as needed
3. **Localization**: Emotion names and descriptions can be localized by extending the system
4. **Custom Emotions**: Users can potentially create custom emotions (extend `DefaultEmotions` or database)

## Future Enhancements

- Analytics: Track which emotions are used most frequently
- Emotion trends: Show emotion patterns over time
- Emotion statistics: Correlate emotions with emotional levels
- Custom emotions: Allow users to create and save custom emotions
- Emotion intensity: Add a scale (1-10) when selecting emotions
- Emotion combinations: Recognize common emotion pairs/combinations
