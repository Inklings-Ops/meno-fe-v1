/// Enum representing the placement of an icon in a button.
///
/// This enum defines the possible positions for an icon relative to the
/// button's text.
///
/// - [left]: The icon is placed to the left of the text.
/// - [right]: The icon is placed to the right of the text.
///
/// Example usage:
/// ```dart
/// ElevatedButton.icon(
///   icon: Icon(Icons.thumb_up),
///   label: Text('Like'),
///   iconPlacement: MButtonIconPlacement.left, // Icon on the left
/// )
/// ```
///
/// ```dart
/// ElevatedButton.icon(
///   icon: Icon(Icons.thumb_up),
///   label: Text('Like'),
///   iconPlacement: MButtonIconPlacement.right, // Icon on the right
/// )
/// ```
enum MButtonIconPlacement {
  /// Icon is placed to the left of the text.
  left,

  /// Icon is placed to the right of the text.
  right
}
