import 'dart:async';

import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:jmap_dart_client/jmap/core/filter/filter.dart';
import 'package:jmap_dart_client/jmap/core/properties/properties.dart';
import 'package:jmap_dart_client/jmap/core/sort/comparator.dart';
import 'package:jmap_dart_client/jmap/core/state.dart';
import 'package:jmap_dart_client/jmap/core/unsigned_int.dart';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';
import 'package:jmap_dart_client/jmap/mail/mailbox/mailbox.dart';
import 'package:model/email/presentation_email.dart';
import 'package:model/extensions/email_extension.dart';
import 'package:tmail_ui_user/features/thread/data/datasource/thread_datasource.dart';
import 'package:tmail_ui_user/features/thread/data/model/email_change_response.dart';
import 'package:tmail_ui_user/features/thread/data/network/thread_isolate_worker.dart';
import 'package:tmail_ui_user/features/thread/domain/model/email_response.dart';
import 'package:tmail_ui_user/features/thread/data/network/thread_api.dart';
import 'package:tmail_ui_user/features/thread/domain/model/filter_message_option.dart';
import 'package:tmail_ui_user/main/exceptions/exception_thrower.dart';

class ThreadDataSourceImpl extends ThreadDataSource {

  final ThreadAPI threadAPI;
  final ThreadIsolateWorker _threadIsolateWorker;
  final ExceptionThrower _exceptionThrower;

  ThreadDataSourceImpl(
    this.threadAPI,
    this._threadIsolateWorker,
    this._exceptionThrower
  );

  @override
  Future<EmailsResponse> getAllEmail(
    AccountId accountId,
    {
      UnsignedInt? limit,
      Set<Comparator>? sort,
      Filter? filter,
      Properties? properties,
    }
  ) {
    return Future.sync(() async {
      return await threadAPI.getAllEmail(
        accountId,
        limit: limit,
        sort: sort,
        filter: filter,
        properties: properties);
    }).catchError((error) {
      _exceptionThrower.throwException(error);
    });
  }

  @override
  Future<EmailChangeResponse> getChanges(
      AccountId accountId,
      State sinceState,
      {
        Properties? propertiesCreated,
        Properties? propertiesUpdated
      }
  ) {
    return Future.sync(() async {
      return await threadAPI.getChanges(
        accountId,
        sinceState,
        propertiesCreated: propertiesCreated,
        propertiesUpdated: propertiesUpdated);
    }).catchError((error) {
      _exceptionThrower.throwException(error);
    });
  }

  @override
  Future<List<Email>> getAllEmailCache({MailboxId? inMailboxId, Set<Comparator>? sort, FilterMessageOption? filterOption, UnsignedInt? limit}) {
    throw UnimplementedError();
  }

  @override
  Future<void> update({List<Email>? updated, List<Email>? created, List<EmailId>? destroyed}) {
    throw UnimplementedError();
  }

  @override
  Future<List<EmailId>> emptyTrashFolder(AccountId accountId, MailboxId mailboxId, Future<void> Function(List<EmailId>? newDestroyed) updateDestroyedEmailCache) {
    return Future.sync(() async {
      return await _threadIsolateWorker.emptyTrashFolder(
          accountId,
          mailboxId,
          updateDestroyedEmailCache,
      );
    }).catchError((error) {
      _exceptionThrower.throwException(error);
    });
  }

  @override
  Future<PresentationEmail> getEmailById(AccountId accountId, EmailId emailId, {Properties? properties}) {
    return Future.sync(() async {
      final email = await threadAPI.getEmailById(accountId, emailId, properties: properties);
      return email.toPresentationEmail();
    }).catchError((error) {
      _exceptionThrower.throwException(error);
    });
  }
}