# Emotion System - Quick Start Guide

## Files Created

### Models
- **`lib/model/emotion.dart`** - The Emotion model with emoji, name, cluster group, and value
- **`lib/model/emotion.g.dart`** - Auto-generated JSON serialization (created by build_runner)
- **`lib/model/default_emotions.dart`** - 40+ pre-configured emotions across 11 cluster groups

### Services
- **`lib/services/emotion_service.dart`** - EmotionService for database operations
- **Updated `lib/services/service_locator.dart`** - Registers emotion service and initializes default emotions

### View Models
- **`lib/view_model/emotion_selection_view_model.dart`** - State management for emotion selection

### Widgets
- **`lib/widgets/emotion_selector.dart`** - Interactive emotion grid with cluster grouping
- **`lib/widgets/emotion_check_in_view.dart`** - Full-screen "How do you feel today?" view
- **`lib/widgets/journal_entry_with_emotions.dart`** - Integration widget for journal entries

### Updated Model
- **`lib/model/journal_entry_extended.dart`** - Added `emotionIds: List<String>` field

## Quick Integration Examples

### 1. Open Emotion Check-In in a Dialog

```dart
final result = await showDialog<Map<String, dynamic>>(
  context: context,
  builder: (context) => const Dialog(
    child: EmotionCheckInView(),
  ),
);

if (result != null) {
  final emotionIds = result['emotionIds'] as List<String>;
  final title = result['title'] as String; // Optional title entered by user
  // Create journal entry with emotions...
}
```

### 2. Add to Journal Entry Editor

```dart
// In JournalEditCard widget
import 'package:emoapp/widgets/journal_entry_with_emotions.dart';

// Add to the build method:
JournalEntryWithEmotions(
  journalEntry: widget.journalEntry,
  onEmotionsUpdated: (emotionIds) {
    _selectedEmotionIds = emotionIds;
  },
),

// When saving the entry:
final updatedEntry = JournalEntryExtended(
  // ... existing fields ...
  emotionIds: _selectedEmotionIds,
);
await journalService.create(updatedEntry);
```

### 3. Display Emotions on Journal Card

```dart
// In JournalCard widget
import 'package:emoapp/widgets/emotion_check_in_view.dart';

// Show emotions:
EmotionDisplayWidget(
  emotionIds: widget.journalEntry.emotionIds,
  maxDisplay: 5,
),
```

### 4. Query Emotions by Cluster

```dart
import 'package:emoapp/model/default_emotions.dart';

// Get all anger emotions
final angerEmotions = DefaultEmotions.getEmotionsByCluster('anger');

// Get emotion by ID
final emotion = DefaultEmotions.findEmotionById('joy_happy');
```

## Data Structure

### Emotion Model
```dart
Emotion {
  id: String,              // Unique identifier
  emoji: String,           // Unicode emoji: "😊"
  name: String,            // "Happy"
  clusterGroup: String,    // "joy"
  value: int,              // 0-10 intensity
  description: String,     // Optional description
}
```

### Journal Entry Integration
```dart
JournalEntryExtended {
  // ... existing fields ...
  emotionIds: List<String>, // ["joy_happy", "gratitude_grateful"]
}
```

## Emotion Clusters

The system includes these pre-configured clusters:

| Cluster | Emotions |
|---------|----------|
| **anger** | Furious, Angry, Irritated, Frustrated |
| **joy** | Ecstatic, Happy, Cheerful, Relieved, Grateful |
| **sadness** | Devastated, Sad, Melancholic, Disappointed, Lonely |
| **fear** | Terrified, Afraid, Anxious, Nervous, Insecure |
| **disgust** | Repulsed, Disgusted, Aversion |
| **guilt** | Ashamed, Guilty, Regretful |
| **surprise** | Amazed, Surprised, Awed |
| **love** | Loved, Loving, Tender, Affectionate |
| **neutral** | Calm, Indifferent, Bored |
| **pride** | Proud, Confident |
| **excitement** | Excited, Hopeful, Eager |

## Key Features

✅ **Reference-based**: Journal entries store only emotion IDs, not full objects  
✅ **Fallback handling**: Missing emotions display as "Unknown Emotion"  
✅ **Clustered UI**: Emotions organized by psychological categories  
✅ **Pre-populated**: 40+ default emotions loaded on first app run  
✅ **Extensible**: Easy to add custom emotions  
✅ **Cached**: View model caches emotions for performance  

## Database Persistence

Emotions are stored in the same flat-file database as other entities. The service locator automatically:
1. Registers the EmotionService
2. Checks if default emotions exist
3. Creates them if the database is empty

## Next Steps

1. Add emotion display to journal card view
2. Add emotion selection to journal entry editor
3. Optionally create emotion analytics/statistics
4. Consider adding emotion intensity scaling (1-10) when selecting
5. Create emotion trends visualization

See `EMOTION_SYSTEM.md` for complete documentation.
