import 'package:emoapp/model/emotion.dart';
import 'package:emoapp/services/flat_file_service.dart';

class EmotionService extends FlatFileEntityService<Emotion> {
  EmotionService(super.entityValidation, super.sdb);
}
