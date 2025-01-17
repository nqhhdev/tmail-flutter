import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jmap_dart_client/jmap/mail/mailbox/mailbox.dart';
import 'package:model/model.dart';
import 'package:tmail_ui_user/features/mailbox/domain/extensions/presentation_mailbox_extension.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_actions.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_displayed.dart';
import 'package:tmail_ui_user/features/mailbox/presentation/model/mailbox_node.dart';
import 'package:tmail_ui_user/main/localizations/app_localizations.dart';

typedef OnExpandFolderActionClick = void Function(MailboxNode);
typedef OnOpenMailboxFolderClick = void Function(MailboxNode);
typedef OnSelectMailboxFolderClick = void Function(MailboxNode);
typedef OnMenuActionClick = void Function(RelativeRect, MailboxNode);
typedef OnDragItemAccepted = void Function(List<PresentationEmail>, PresentationMailbox);

class MailBoxFolderTileBuilder {

  final _responsiveUtils = Get.find<ResponsiveUtils>();

  final MailboxNode _mailboxNode;
  final BuildContext _context;
  final ImagePaths _imagePaths;
  final SelectMode allSelectMode;
  final MailboxDisplayed mailboxDisplayed;
  final MailboxNode? lastNode;
  final PresentationMailbox? mailboxNodeSelected;
  final MailboxActions? mailboxActions;
  final MailboxId? mailboxIdAlreadySelected;

  OnExpandFolderActionClick? _onExpandFolderActionClick;
  OnOpenMailboxFolderClick? _onOpenMailboxFolderClick;
  OnSelectMailboxFolderClick? _onSelectMailboxFolderClick;
  OnMenuActionClick? _onMenuActionClick;
  OnDragItemAccepted? _onDragItemAccepted;

  bool isHoverItem = false;

  MailBoxFolderTileBuilder(
    this._context,
    this._imagePaths,
    this._mailboxNode,
    {
      this.allSelectMode = SelectMode.INACTIVE,
      this.mailboxDisplayed = MailboxDisplayed.mailbox,
      this.lastNode,
      this.mailboxNodeSelected,
      this.mailboxActions,
      this.mailboxIdAlreadySelected
    }
  );

  void addOnExpandFolderActionClick(OnExpandFolderActionClick onExpandFolderActionClick) {
    _onExpandFolderActionClick = onExpandFolderActionClick;
  }

  void addOnOpenMailboxFolderClick(OnOpenMailboxFolderClick onOpenMailboxFolderClick) {
    _onOpenMailboxFolderClick = onOpenMailboxFolderClick;
  }

  void addOnSelectMailboxFolderClick(OnSelectMailboxFolderClick onSelectMailboxFolderClick) {
    _onSelectMailboxFolderClick = onSelectMailboxFolderClick;
  }

  void addOnMenuActionClick(OnMenuActionClick onMenuActionClick) {
    _onMenuActionClick = onMenuActionClick;
  }

  void addOnDragItemAccepted(OnDragItemAccepted onDragItemAccepted) {
    _onDragItemAccepted = onDragItemAccepted;
  }

  Widget build() => DragTarget<List<PresentationEmail>>(
    builder: (context, _, __,) {
      return _buildMailboxItem();
    },
    onAccept: (emails) {
      _onDragItemAccepted?.call(emails, _mailboxNode.item);
    },
  );

  Widget _buildMailboxItem() {
    if (mailboxDisplayed == MailboxDisplayed.mailbox) {
      if (BuildUtils.isWeb) {
        return Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return InkWell(
                  onTap: () => _onOpenMailboxFolderClick?.call(_mailboxNode),
                  onHover: (value) => setState(() => isHoverItem = value),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundColorItem),
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(children: [
                        _buildLeadingMailboxItem(),
                        const SizedBox(width: 4),
                        Expanded(child: _buildTitleFolderItem()),
                        const SizedBox(width: 8),
                        _buildTrailingMailboxItem()
                      ])
                  ),
                );
              }
          ),
        );
      } else {
        return AbsorbPointer(
          absorbing: !_mailboxNode.isActivated,
          child: Opacity(
            opacity: _mailboxNode.isActivated ? 1.0 : 0.3,
            child: InkWell(
              onTap: () => allSelectMode == SelectMode.ACTIVE
                  ? _onSelectMailboxFolderClick?.call(_mailboxNode)
                  : _onOpenMailboxFolderClick?.call(_mailboxNode),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: Container(
                      color: Colors.white,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _mailboxNode.hasChildren() ? 8 : 15),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                _buildLeadingMailboxItem(),
                                const SizedBox(width: 8),
                                Expanded(child: _buildTitleFolderItem()),
                                _buildSelectedIcon(),
                                const SizedBox(width: 8),
                                _buildTrailingMailboxItem()
                              ]),
                            ),
                            _buildDivider(),
                          ]
                      )
                  )
              ),
            ),
          ),
        );
      }
    } else {
      return AbsorbPointer(
        absorbing: !_mailboxNode.isActivated,
        child: Opacity(
          opacity: _mailboxNode.isActivated ? 1.0 : 0.3,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onOpenMailboxFolderClick?.call(_mailboxNode),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  color: mailboxDisplayed == MailboxDisplayed.destinationPicker && _mailboxNode.isSelected
                    ? AppColor.colorItemSelected
                    : Colors.transparent,
                  child: Row(children: [
                    _buildLeadingMailboxItem(),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTitleFolderItem()),
                    _buildSelectedIcon(),
                    const SizedBox(width: 8),
                    _buildTrailingMailboxItem()
                  ])
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLeadingMailboxItem() {
    if (BuildUtils.isWeb) {
      if (mailboxDisplayed == MailboxDisplayed.mailbox) {
        return Row(mainAxisSize: MainAxisSize.min, children: [
          if (_mailboxNode.hasChildren())
            buildIconWeb(
                icon: SvgPicture.asset(
                    _mailboxNode.expandMode == ExpandMode.EXPAND
                        ? _imagePaths.icExpandFolder
                        : _imagePaths.icCollapseFolder,
                    color: _mailboxNode.expandMode == ExpandMode.EXPAND
                        ? AppColor.colorExpandMailbox
                        : AppColor.colorCollapseMailbox,
                    fit: BoxFit.fill),
                minSize: 12,
                splashRadius: 10,
                iconPadding: EdgeInsets.zero,
                tooltip: _mailboxNode.expandMode == ExpandMode.EXPAND
                    ? AppLocalizations.of(_context).collapse
                    : AppLocalizations.of(_context).expand,
                onTap: () => _onExpandFolderActionClick?.call(_mailboxNode))
          else
            const SizedBox(width: 24),
          Transform(
              transform: Matrix4.translationValues(-4.0, 0.0, 0.0),
              child: _buildLeadingIcon())
        ]);
      } else {
        return _buildLeadingIcon();
      }
    } else {
      return _buildLeadingIcon();
    }
  }

  Widget _buildTrailingMailboxItem() {
    if (BuildUtils.isWeb) {
      if (isHoverItem) {
        return _buildMenuIcon();
      } else if (_mailboxNode.item.getCountUnReadEmails().isNotEmpty
          && _mailboxNode.item.matchCountingRules()
          && mailboxDisplayed == MailboxDisplayed.mailbox) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _buildCounter(),
        );
      } else if (_mailboxNode.hasChildren()
          && mailboxDisplayed == MailboxDisplayed.destinationPicker) {
        return buildIconWeb(
            icon: SvgPicture.asset(
                _mailboxNode.expandMode == ExpandMode.EXPAND
                    ? _imagePaths.icExpandFolder
                    : _imagePaths.icCollapseFolder,
                color: _mailboxNode.expandMode == ExpandMode.EXPAND
                    ? AppColor.colorExpandMailbox
                    : AppColor.colorCollapseMailbox,
                fit: BoxFit.fill),
            splashRadius: 10,
            iconPadding: EdgeInsets.zero,
            minSize: 30,
            tooltip: _mailboxNode.expandMode == ExpandMode.EXPAND
                ? AppLocalizations.of(_context).collapse
                : AppLocalizations.of(_context).expand,
            onTap: () => _onExpandFolderActionClick?.call(_mailboxNode)
        );
      } else {
        return const SizedBox(width: 20);
      }
    } else {
      if (_mailboxNode.hasChildren()) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Row(
            children: [
              if (_mailboxNode.item.getCountUnReadEmails().isNotEmpty
                  && _mailboxNode.item.matchCountingRules()
                  && mailboxDisplayed == MailboxDisplayed.mailbox)
                _buildCounter(),
              buildIconWeb(
                  icon: SvgPicture.asset(
                      _mailboxNode.expandMode == ExpandMode.EXPAND
                          ? _imagePaths.icExpandFolder
                          : _imagePaths.icCollapseFolder,
                      color: _mailboxNode.expandMode == ExpandMode.EXPAND
                          ? AppColor.colorExpandMailbox
                          : AppColor.colorCollapseMailbox,
                      fit: BoxFit.fill),
                  splashRadius: mailboxDisplayed == MailboxDisplayed.mailbox ? 20 : 20,
                  iconPadding: EdgeInsets.zero,
                  minSize: mailboxDisplayed == MailboxDisplayed.mailbox ? 40 : 24,
                  tooltip: _mailboxNode.expandMode == ExpandMode.EXPAND
                      ? AppLocalizations.of(_context).collapse
                      : AppLocalizations.of(_context).expand,
                  onTap: () => _onExpandFolderActionClick?.call(_mailboxNode)
              ),
            ],
          ),
        );
      } else if (_mailboxNode.item.getCountUnReadEmails().isNotEmpty
          && _mailboxNode.item.matchCountingRules()
          && mailboxDisplayed == MailboxDisplayed.mailbox) {
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: _buildCounter(),
        );
      } else {
        return const SizedBox(width: 20);
      }
    }
  }

  Widget _buildLeadingIcon() {
    if (BuildUtils.isWeb) {
      return _buildMailboxIcon();
    } else {
      return allSelectMode == SelectMode.ACTIVE
          ? _buildSelectModeIcon()
          : _buildMailboxIcon();
    }
  }

  Widget _buildTitleFolderItem() {
    return Text(
      _mailboxNode.item.name?.name ?? '',
      maxLines: 1,
      softWrap: CommonTextStyle.defaultSoftWrap,
      overflow: CommonTextStyle.defaultTextOverFlow,
      style: const TextStyle(
          fontSize: 15,
          color: AppColor.colorNameEmail,
          fontWeight: FontWeight.normal),
    );
  }

  Widget _buildCounter() {
    return Text(
      _mailboxNode.item.getCountUnReadEmails(),
      maxLines: 1,
      overflow: CommonTextStyle.defaultTextOverFlow,
      style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.normal),
    );
  }

  Widget _buildMailboxIcon() {
    return SvgPicture.asset(
        _mailboxNode.item.getMailboxIcon(_imagePaths),
        width: BuildUtils.isWeb ? 20 : 24,
        height: BuildUtils.isWeb ? 20 : 24,
        fit: BoxFit.fill);
  }

  Widget _buildMenuIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
          onTapDown: (detail) {
            final screenSize = MediaQuery.of(_context).size;
            final offset = detail.globalPosition;
            final position = RelativeRect.fromLTRB(
              offset.dx,
              offset.dy,
              screenSize.width - offset.dx,
              screenSize.height - offset.dy,
            );
            _onMenuActionClick?.call(position, _mailboxNode);
          },
          onTap: () => {},
          child: SvgPicture.asset(_imagePaths.icComposerMenu,
              width: 20,
              height: 20,
              fit: BoxFit.fill)),
    );
  }

  Widget _buildSelectModeIcon() {
    return InkWell(
      onTap: () => _onSelectMailboxFolderClick?.call(_mailboxNode),
      child: SvgPicture.asset(
        _mailboxNode.selectMode == SelectMode.ACTIVE
            ? _imagePaths.icSelected
            : _imagePaths.icUnSelected,
        width: BuildUtils.isWeb ? 20 : 24,
        height: BuildUtils.isWeb ? 20 : 24,
        fit: BoxFit.fill)
    );
  }

  Color get backgroundColorItem {
    if (mailboxDisplayed == MailboxDisplayed.destinationPicker) {
      return Colors.white;
    } else {
      if (BuildUtils.isWeb) {
        if (mailboxNodeSelected?.id == _mailboxNode.item.id || isHoverItem) {
          return AppColor.colorBgMailboxSelected;
        }
        return _responsiveUtils.isDesktop(_context)
            ? AppColor.colorBgDesktop
            : Colors.white;
      } else {
        return Colors.white;
      }
    }
  }

  Widget _buildDivider() {
    if (lastNode?.item.id != _mailboxNode.item.id) {
      return const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Divider(
              color: AppColor.lineItemListColor,
              height: 0.5,
              thickness: 0.2
          )
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSelectedIcon() {
    if (_mailboxNode.item.id == mailboxIdAlreadySelected &&
        mailboxDisplayed == MailboxDisplayed.destinationPicker &&
        (mailboxActions == MailboxActions.select ||
        mailboxActions == MailboxActions.create)) {
      return SvgPicture.asset(
          _imagePaths.icFilterSelected,
          width: 20,
          height: 20,
          fit: BoxFit.fill);
    } else {
      return const SizedBox.shrink();
    }
  }
}