# Collaborative Mindmap Feature

This document describes the new collaborative mindmap feature added to the EMO APP dashboard.

## Overview

The Collaborative Mindmap is a feature that allows users to create, organize, and link ideas in a visual mindmap interface. Ideas are represented as nodes that can be positioned on a canvas, connected to other ideas through references, and edited with rich metadata.

## Features

### 1. Zoomable Canvas Interface
- **Pan & Zoom Controls**: Users can zoom in/out and pan across the canvas to view and work with ideas
- **Zoom Levels**: Supports zoom from 10% to 300%
- **Reset Controls**: Button to reset zoom and pan to default states
- **Grid Background**: Visual grid for better positioning reference

### 2. Idea Management
- **Create Ideas**: Click anywhere on the canvas to create a new idea at that position
- **Edit Ideas**: Double-tap or select from list to open edit dialog
- **Delete Ideas**: Remove ideas with confirmation dialog
- **Position Control**: Drag ideas across the canvas by long-pressing

### 3. Idea Properties
Each idea contains:
- `id`: Unique UUID identifier
- `title`: Short title for the idea
- `content`: Detailed description
- `references`: List of links to other ideas
- `ownerUuid`: Owner of the idea (optional for now)
- `groupUuid`: Visibility group for sharing (optional)
- `positionX, positionY`: Canvas coordinates (doubles)
- `referencedTopic`: Optional reference to a topic

### 4. Ownership & Permissions
- **Owner Control**: Only idea owners can edit, move, or delete ideas
- **Transfer Ownership**: Owners can transfer ideas to other users
- **Permission Checks**: UI disables editing if you don't have permission
- **Optional Users**: User assignment is optional for now

### 5. Visibility Groups
- Ideas can be organized into visibility groups for sharing with other users
- Default "Personal" group created automatically
- Owners can change which group an idea belongs to

### 6. References System
- Ideas can reference other ideas (linked lists concept)
- Each reference shows:
  - `id`: Unique reference identifier
  - `text`: Display text for the reference
  - `ideaUuid`: UUID of the referenced idea
- Visual lines drawn connecting referenced ideas on the canvas
- Reference count badge displayed on idea nodes

### 7. Dual View System
- **Mindmap View**: Visual canvas-based view with zoom/pan
- **List View**: Traditional list view with search filtering
- Toggle between views using the view switcher button in the app bar

## File Structure

```
lib/
├── model/
│   ├── idea.dart              # Main idea model
│   ├── idea.g.dart            # Generated JSON serialization
│   ├── reference.dart         # Reference model
│   ├── reference.g.dart       # Generated JSON serialization
│   ├── user.dart              # User model (optional)
│   ├── user.g.dart            # Generated JSON serialization
│   ├── visibility_group.dart  # Visibility group model
│   └── visibility_group.g.dart # Generated JSON serialization
├── services/
│   ├── idea_service.dart      # CRUD operations for ideas
│   └── service_locator.dart   # Service registration (updated)
├── view_model/
│   └── mindmap_view_model.dart # State management and business logic
└── widgets/
    └── mindmap/
        ├── mindmap_screen.dart      # Main screen container
        ├── mindmap_view.dart        # Canvas view with zoom/pan
        ├── idea_node_widget.dart    # Individual idea node display
        ├── edit_idea_dialog.dart    # Edit dialog with tabbed interface
        └── idea_list_view.dart      # List view with search
```

## Usage

### Starting the Mindmap Feature

1. Navigate to the "Mindmap" option in the app drawer
2. The mindmap screen will load with all your ideas
3. Use the toggle button in the app bar to switch between mindmap and list views

### Creating an Idea

**From Mindmap View:**
1. Click the "New Idea" FAB button, or
2. Click anywhere on the canvas to create at that position

**From List View:**
1. The FAB is not available in list view
2. Use mindmap view to create ideas

### Editing an Idea

1. **From Mindmap**: Double-tap the idea node
2. **From List**: Click the edit icon or the idea card itself
3. Edit dialog opens with tabs:
   - **Content**: Edit title and description
   - **References**: Add/remove links to other ideas
   - **Share**: Transfer ownership and manage visibility groups
   - **More**: View metadata and delete option

### Deleting an Idea

1. Open the idea edit dialog
2. Go to the "More" tab
3. Click "Delete Idea" button
4. Confirm in the dialog

### Moving Ideas

1. Long-press (tap and hold) on an idea node
2. Drag the idea to the new position
3. Release to save the position
4. A green indicator appears while dragging

### Linking Ideas

1. Open an idea for editing
2. Go to the "References" tab
3. Type in the search field to find other ideas
4. Click on a suggestion to add it as a reference
5. To remove a reference, click the delete icon next to it

## Technical Implementation

### Architecture Pattern

The implementation follows the established patterns in the emoapp codebase:

#### Models
- All models extend `EntityBase<T>` for consistency
- Use `@JsonSerializable()` annotation for automatic JSON serialization
- Include factory constructors and validation methods

#### Services
- `IdeaService` extends `FlatFileEntityService<Idea>`
- Services provide CRUD operations and custom queries
- Use dependency injection via GetIt service locator

#### ViewModels
- `MindmapViewModel` extends `ChangeNotifier`
- Manages zoom, pan, selection, and editing state
- Provides methods for CRUD operations on ideas
- Handles reference suggestions and spatial queries

#### Widgets
- Use `ChangeNotifierProvider` for dependency injection
- `Consumer` widgets listen to viewmodel changes
- Responsive design with flutter widgets

### JSON Serialization

Models are serialized to JSON for file storage. Run the build_runner if you modify models:

```bash
flutter pub run build_runner build
```

### Service Registration

The `IdeaService` and `VisibilityGroupService` are registered in `service_locator.dart`:

```dart
Future<void> registerIdea() async {
  // Validation function
  (bool, Exception?) ideaValidation(Idea i) => ...
  
  // Register service
  final idea = GetIt.instance.registerSingleton<IdeaService>(
    IdeaService(ideaValidation, Sdb<Idea>()),
  );
}
```

## Database Storage

Ideas are stored using the `Sdb<Idea>()` service which provides flat-file storage. By default:
- Ideas are stored in the app's documents directory
- Files are serialized as JSON
- All ideas are loaded into memory on app start

## Future Enhancements

The following features are marked for future implementation:

1. **User Pools**: Currently, user assignment is optional. Full user pool system can be added later
2. **Real-time Collaboration**: WebSocket support for live collaborative editing
3. **Search & Filter**: Advanced filtering by properties, owner, group, etc.
4. **Export/Import**: Export mindmaps as images, JSON, or other formats
5. **Collaboration**: Permission system for multiple users editing shared ideas
6. **Styling**: Custom colors and appearance for different idea types
7. **Analytics**: Statistics on mindmap structure and idea relationships
8. **AI Integration**: Suggestions for related ideas or auto-linking

## API Reference

### MindmapViewModel

#### Properties
- `zoomLevel`: Current zoom level (0.1 - 3.0)
- `panOffset`: Current pan offset
- `selectedIdea`: Currently selected idea
- `isEditingIdea`: Whether in edit mode
- `ideas`: All ideas
- `filteredIdeas`: Ideas filtered by search query
- `suggestions`: Reference suggestions
- `movingIdea`: Currently moving idea

#### Methods
- `loadIdeas()`: Load all ideas for a user
- `zoomIn() / zoomOut() / resetZoom()`: Zoom controls
- `pan(Offset delta) / resetPan()`: Pan controls
- `createIdea()`: Create a new idea
- `updateIdea()`: Save idea changes
- `deleteIdea()`: Delete an idea
- `selectIdea() / deselectIdea()`: Selection management
- `startMovingIdea() / updateMovingIdeaPosition() / stopMovingIdea()`: Dragging
- `getReferenceSuggestions()`: Get reference suggestions
- `transferOwnership()`: Transfer idea ownership
- `changeGroup()`: Change visibility group

### Idea Model

#### Properties
- `id`: UUID
- `title`: String
- `content`: String
- `references`: List<Reference>
- `ownerUuid`: String
- `groupUuid`: String
- `positionX`, `positionY`: double
- `referencedTopic`: String

#### Methods
- `canEdit(currentUserUuid)`: Check if user can edit
- `addReference()`: Add a reference
- `removeReference()`: Remove a reference
- `updatePosition()`: Update canvas position
- `transferOwnership()`: Change owner
- `changeGroup()`: Change visibility group

### IdeaService

#### Methods
- `getByOwner(ownerUuid)`: Get ideas by owner
- `getByGroup(groupUuid)`: Get ideas in a group
- `getReferences(ideaUuid)`: Get ideas referencing this idea
- `getIdeasInArea()`: Get ideas in a bounding box

## Testing Notes

When testing the feature:

1. **Create Ideas**: Use the FAB or click on canvas to create ideas
2. **Move Ideas**: Long-press and drag to move
3. **Edit Ideas**: Double-tap to edit
4. **References**: Add references in edit dialog
5. **Zoom**: Use the zoom controls to test zoom/pan
6. **List View**: Toggle to list view to see all ideas
7. **Ownership**: Test permission checks with and without owner set
8. **Search**: Filter ideas in list view by title or content

## Known Limitations

1. **User Management**: User assignment is optional and not fully implemented
2. **Persistence**: Ideas are stored locally; no sync across devices
3. **Performance**: Large numbers of ideas (100+) may have rendering performance issues
4. **Collaboration**: Real-time collaboration is not yet implemented
5. **Mobile**: Touch interactions may need refinement on smaller screens

## Troubleshooting

### Ideas Not Loading
- Check that the IdeaService is registered in service_locator.dart
- Verify the Sdb storage directory has write permissions

### Edit Dialog Not Opening
- Ensure the idea has a valid UUID
- Check that the ChangeNotifierProvider is wrapping the widget

### References Not Showing
- Verify that referenced ideas exist and have valid IDs
- Check the connection lines are being drawn (CustomPaint in mindmap_view.dart)

### Zoom/Pan Not Working
- Ensure GestureDetector is properly configured
- Check that TransformationController is being updated

## Contributing

When adding new features to the mindmap:

1. Follow the existing patterns for models (extend EntityBase)
2. Add service methods to IdeaService for new queries
3. Update MindmapViewModel for UI logic
4. Create widgets in the mindmap/ folder
5. Update this documentation with new features
