import 'package:core/presentation/state/failure.dart';
import 'package:core/presentation/state/success.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:jmap_dart_client/jmap/core/id.dart';
import 'package:model/mailbox/presentation_mailbox.dart';
import 'package:tmail_ui_user/features/base/base_controller.dart';
import 'package:tmail_ui_user/features/mailbox/domain/state/get_all_mailboxes_state.dart';
import 'package:tmail_ui_user/features/mailbox/domain/usecases/get_all_mailbox_interactor.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_node.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_tree.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_tree_builder.dart';
import 'package:tmail_ui_user/main/routes/app_routes.dart';

class MailboxController extends BaseController {

  final GetAllMailboxInteractor _getAllMailboxInteractor;
  final TreeBuilder _treeBuilder;

  MailboxController(this._getAllMailboxInteractor, this._treeBuilder);

  final folderMailboxTree = MailboxTree(MailboxNode.root()).obs;

  @override
  void onReady() {
    super.onReady();
    getAllMailboxAction();
  }
  
  void getAllMailboxAction() async {
    final AccountId accountId = AccountId(Id('93c56f4408cff66f0a929aea8e3940e753c3275e5622582ae3010e7277b7696c'));
    consumeState(_getAllMailboxInteractor.execute(accountId));
  }

  @override
  void onData(Either<Failure, Success> newState) {
    super.onData(newState);
    newState
      .map((success) => success is GetAllMailboxSuccess
        ? _buildTree(success.folderMailboxList)
        : null);
  }

  @override
  void onDone() {
  }

  @override
  void onError(error) {
  }

  void _buildTree(List<PresentationMailbox> folderMailboxList) async {
    folderMailboxTree.value = await _treeBuilder.generateMailboxTree(folderMailboxList);
  }

  void closeMailboxScreen() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}