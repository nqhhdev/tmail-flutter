import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';

abstract class EmailRepository {
  Future<Email> getEmailContent(AccountId accountId, EmailId emailId);
}