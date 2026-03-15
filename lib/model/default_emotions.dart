import 'package:emoapp/model/emotion.dart';

/// Contains predefined emotions that come with the app
/// Based on a comprehensive emotion wheel including primary and secondary emotions
class DefaultEmotions {
  /// Primary emotion groups (basic emotions)
  static final List<Emotion> primaryEmotions = [
    // ANGER GROUP
    Emotion(
      id: 'anger_furious',
      emoji: '😠',
      name: 'Furious',
      clusterGroup: 'anger',
      value: 10,
      description: 'Extreme anger and rage',
    ),
    Emotion(
      id: 'anger_angry',
      emoji: '😡',
      name: 'Angry',
      clusterGroup: 'anger',
      value: 8,
      description: 'Significant anger',
    ),
    Emotion(
      id: 'anger_irritated',
      emoji: '😤',
      name: 'Irritated',
      clusterGroup: 'anger',
      value: 5,
      description: 'Mildly annoyed or irritated',
    ),
    Emotion(
      id: 'anger_frustrated',
      emoji: '😒',
      name: 'Frustrated',
      clusterGroup: 'anger',
      value: 6,
      description: 'Feeling blocked or thwarted',
    ),

    // JOY/HAPPINESS GROUP
    Emotion(
      id: 'joy_ecstatic',
      emoji: '🤩',
      name: 'Ecstatic',
      clusterGroup: 'joy',
      value: 10,
      description: 'Overwhelming joy and happiness',
    ),
    Emotion(
      id: 'joy_happy',
      emoji: '😊',
      name: 'Happy',
      clusterGroup: 'joy',
      value: 8,
      description: 'Content and cheerful',
    ),
    Emotion(
      id: 'joy_cheerful',
      emoji: '😄',
      name: 'Cheerful',
      clusterGroup: 'joy',
      value: 7,
      description: 'Bright and upbeat',
    ),
    Emotion(
      id: 'joy_relieved',
      emoji: '😌',
      name: 'Relieved',
      clusterGroup: 'joy',
      value: 6,
      description: 'Burden lifted, peaceful',
    ),
    Emotion(
      id: 'joy_grateful',
      emoji: '🙏',
      name: 'Grateful',
      clusterGroup: 'joy',
      value: 7,
      description: 'Appreciative and thankful',
    ),

    // SADNESS GROUP
    Emotion(
      id: 'sadness_devastated',
      emoji: '😭',
      name: 'Devastated',
      clusterGroup: 'sadness',
      value: 10,
      description: 'Deep despair and sorrow',
    ),
    Emotion(
      id: 'sadness_sad',
      emoji: '😢',
      name: 'Sad',
      clusterGroup: 'sadness',
      value: 8,
      description: 'Sorrowful or unhappy',
    ),
    Emotion(
      id: 'sadness_melancholic',
      emoji: '😔',
      name: 'Melancholic',
      clusterGroup: 'sadness',
      value: 6,
      description: 'Pensive and slightly sad',
    ),
    Emotion(
      id: 'sadness_disappointed',
      emoji: '😞',
      name: 'Disappointed',
      clusterGroup: 'sadness',
      value: 5,
      description: 'Let down or unfulfilled',
    ),
    Emotion(
      id: 'sadness_lonely',
      emoji: '😞',
      name: 'Lonely',
      clusterGroup: 'sadness',
      value: 7,
      description: 'Isolated or alone',
    ),

    // FEAR GROUP
    Emotion(
      id: 'fear_terrified',
      emoji: '😨',
      name: 'Terrified',
      clusterGroup: 'fear',
      value: 10,
      description: 'Extreme fear and panic',
    ),
    Emotion(
      id: 'fear_afraid',
      emoji: '😖',
      name: 'Afraid',
      clusterGroup: 'fear',
      value: 8,
      description: 'Experiencing fear',
    ),
    Emotion(
      id: 'fear_anxious',
      emoji: '😰',
      name: 'Anxious',
      clusterGroup: 'fear',
      value: 7,
      description: 'Worried or nervous',
    ),
    Emotion(
      id: 'fear_nervous',
      emoji: '😟',
      name: 'Nervous',
      clusterGroup: 'fear',
      value: 6,
      description: 'Uneasy or worried',
    ),
    Emotion(
      id: 'fear_insecure',
      emoji: '😑',
      name: 'Insecure',
      clusterGroup: 'fear',
      value: 5,
      description: 'Lacking confidence',
    ),

    // DISGUST GROUP
    Emotion(
      id: 'disgust_repulsed',
      emoji: '🤮',
      name: 'Repulsed',
      clusterGroup: 'disgust',
      value: 9,
      description: 'Strong aversion or revulsion',
    ),
    Emotion(
      id: 'disgust_disgusted',
      emoji: '😠',
      name: 'Disgusted',
      clusterGroup: 'disgust',
      value: 8,
      description: 'Strong disapproval',
    ),
    Emotion(
      id: 'disgust_aversion',
      emoji: '😒',
      name: 'Aversion',
      clusterGroup: 'disgust',
      value: 6,
      description: 'Dislike or avoidance',
    ),

    // GUILT & SHAME GROUP
    Emotion(
      id: 'guilt_ashamed',
      emoji: '😳',
      name: 'Ashamed',
      clusterGroup: 'guilt',
      value: 9,
      description: 'Deep shame about actions or self',
    ),
    Emotion(
      id: 'guilt_guilty',
      emoji: '😔',
      name: 'Guilty',
      clusterGroup: 'guilt',
      value: 8,
      description: 'Responsible for wrongdoing',
    ),
    Emotion(
      id: 'guilt_regretful',
      emoji: '😞',
      name: 'Regretful',
      clusterGroup: 'guilt',
      value: 7,
      description: 'Wishing things were different',
    ),

    // SURPRISE & WONDER GROUP
    Emotion(
      id: 'surprise_amazed',
      emoji: '😲',
      name: 'Amazed',
      clusterGroup: 'surprise',
      value: 7,
      description: 'Astonished or impressed',
    ),
    Emotion(
      id: 'surprise_surprised',
      emoji: '😲',
      name: 'Surprised',
      clusterGroup: 'surprise',
      value: 6,
      description: 'Unexpected discovery',
    ),
    Emotion(
      id: 'surprise_awed',
      emoji: '🤩',
      name: 'Awed',
      clusterGroup: 'surprise',
      value: 8,
      description: 'Wonder and admiration',
    ),

    // LOVE & AFFECTION GROUP
    Emotion(
      id: 'love_loved',
      emoji: '🥰',
      name: 'Loved',
      clusterGroup: 'love',
      value: 9,
      description: 'Feeling cherished and cared for',
    ),
    Emotion(
      id: 'love_loving',
      emoji: '😍',
      name: 'Loving',
      clusterGroup: 'love',
      value: 9,
      description: 'Full of affection',
    ),
    Emotion(
      id: 'love_tender',
      emoji: '🥺',
      name: 'Tender',
      clusterGroup: 'love',
      value: 7,
      description: 'Gentle and caring',
    ),
    Emotion(
      id: 'love_affectionate',
      emoji: '😍',
      name: 'Affectionate',
      clusterGroup: 'love',
      value: 8,
      description: 'Warmly attached',
    ),

    // NEUTRAL/CALM GROUP
    Emotion(
      id: 'neutral_calm',
      emoji: '😐',
      name: 'Calm',
      clusterGroup: 'neutral',
      value: 5,
      description: 'At peace and tranquil',
    ),
    Emotion(
      id: 'neutral_indifferent',
      emoji: '😑',
      name: 'Indifferent',
      clusterGroup: 'neutral',
      value: 3,
      description: 'Neither positive nor negative',
    ),
    Emotion(
      id: 'neutral_bored',
      emoji: '😑',
      name: 'Bored',
      clusterGroup: 'neutral',
      value: 2,
      description: 'Lacking interest',
    ),

    // PRIDE GROUP
    Emotion(
      id: 'pride_proud',
      emoji: '😌',
      name: 'Proud',
      clusterGroup: 'pride',
      value: 8,
      description: 'Satisfied with accomplishment',
    ),
    Emotion(
      id: 'pride_confident',
      emoji: '💪',
      name: 'Confident',
      clusterGroup: 'pride',
      value: 7,
      description: 'Self-assured and capable',
    ),

    // EXCITED/ANTICIPATION GROUP
    Emotion(
      id: 'excitement_excited',
      emoji: '🎉',
      name: 'Excited',
      clusterGroup: 'excitement',
      value: 8,
      description: 'Enthusiastic anticipation',
    ),
    Emotion(
      id: 'excitement_hopeful',
      emoji: '🌟',
      name: 'Hopeful',
      clusterGroup: 'excitement',
      value: 7,
      description: 'Optimistic about the future',
    ),
    Emotion(
      id: 'excitement_eager',
      emoji: '😃',
      name: 'Eager',
      clusterGroup: 'excitement',
      value: 7,
      description: 'Keen and ready',
    ),
  ];

  /// Get all default emotions
  static List<Emotion> getAllEmotions() => primaryEmotions;

  /// Get emotions by cluster group
  static List<Emotion> getEmotionsByCluster(String clusterGroup) =>
      primaryEmotions.where((e) => e.clusterGroup == clusterGroup).toList();

  /// Get unique cluster groups
  static List<String> getClusters() =>
      primaryEmotions.map((e) => e.clusterGroup).toSet().toList();

  /// Find emotion by ID
  static Emotion? findEmotionById(String id) {
    try {
      return primaryEmotions.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
