
import 'package:model/model.dart';
import 'package:tmail_ui_user/features/composer/domain/model/auto_complete_pattern.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContactSuggestions(AutoCompletePattern autoCompletePattern);
}