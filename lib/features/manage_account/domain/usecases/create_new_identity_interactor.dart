import 'dart:core';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:tmail_ui_user/features/manage_account/domain/model/create_new_identity_request.dart';
import 'package:tmail_ui_user/features/manage_account/domain/repository/identity_repository.dart';
import 'package:tmail_ui_user/features/manage_account/domain/state/create_new_identity_state.dart';

class CreateNewIdentityInteractor {
  final IdentityRepository _identityRepository;

  CreateNewIdentityInteractor(this._identityRepository);

  Stream<Either<Failure, Success>> execute(AccountId accountId, CreateNewIdentityRequest identityRequest) async* {
    try {
      yield Right(CreateNewIdentityLoading());
      final newIdentity = await _identityRepository.createNewIdentity(accountId, identityRequest);
      yield Right(CreateNewIdentitySuccess(newIdentity));
    } catch (exception) {
      yield Left(CreateNewIdentityFailure(exception));
    }
  }
}