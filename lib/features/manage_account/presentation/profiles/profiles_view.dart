
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/menu/settings_utils.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/model/profiles_tab_type.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/identities/identities_view.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/profiles_controller.dart';

class ProfilesView extends GetWidget<ProfilesController> {

  final _responsiveUtils = Get.find<ResponsiveUtils>();

  ProfilesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsUtils.getBackgroundColor(context, _responsiveUtils),
      body: Container(
        margin: _responsiveUtils.isWebDesktop(context)
          ? const EdgeInsets.all(16)
          : EdgeInsets.symmetric(horizontal: SettingsUtils.getHorizontalPadding(context, _responsiveUtils)),
        color: _responsiveUtils.isWebDesktop(context) ? null : Colors.white,
        decoration: _responsiveUtils.isWebDesktop(context)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.colorBorderSettingContentWeb, width: 1),
                color: Colors.white)
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              _responsiveUtils.isWebDesktop(context) ? 16 : 0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: DefaultTabController(
                initialIndex: 0,
                length: 1,
                child: Scaffold(
                  appBar: TabBar(
                      unselectedLabelColor: AppColor.colorTextButtonHeaderThread,
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColor.colorTextButtonHeaderThread),
                      labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor),
                      labelColor: AppColor.primaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      indicator: const CustomIndicator(
                        indicatorHeight: 4,
                        indicatorColor: AppColor.primaryColor,
                        indicatorSize: CustomIndicatorSize.full),
                      onTap: (index) {},
                      tabs: [
                        Tab(text: ProfilesTabType.identities.getName(context)),
                      ]),
                  body: Column(children: [
                    const Divider(color: AppColor.colorDividerMailbox, height: 0.5, thickness: 0.2),
                    Expanded(child: TabBarView(
                      children: [
                        IdentitiesView(),
                      ],
                    ))
                  ]),
                )
            ),
          ),
        ),
      ),
    );
  }
}