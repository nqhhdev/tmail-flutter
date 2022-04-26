
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/menu/manage_account_menu_controller.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/menu/widgets/account_property_tile_builder.dart';
import 'package:tmail_ui_user/main/localizations/app_localizations.dart';

class ManageAccountMenuView extends GetWidget<ManageAccountMenuController> {

  final _responsiveUtils = Get.find<ResponsiveUtils>();
  final _imagePaths = Get.find<ImagePaths>();

  ManageAccountMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Drawer(
        elevation: _responsiveUtils.isDesktop(context) ? 0 : 16.0,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
              children: [
                if (!_responsiveUtils.isDesktop(context))
                  Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                      child: Row(children: [
                        (SloganBuilder(arrangedByHorizontal: true)
                            ..setSloganText(AppLocalizations.of(context).app_name)
                            ..setSloganTextAlign(TextAlign.center)
                            ..setSloganTextStyle(const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
                            ..setSizeLogo(24)
                            ..setLogo(_imagePaths.icLogoTMail))
                          .build(),
                        Obx(() {
                          if (controller.dashBoardController.appInformation.value != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'v.${controller.dashBoardController.appInformation.value!.version}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13, color: AppColor.colorContentEmail, fontWeight: FontWeight.w500),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ])
                  ),
                if (!_responsiveUtils.isDesktop(context))
                  const Divider(color: AppColor.colorDividerMailbox, height: 0.5, thickness: 0.2),
                Expanded(child: Container(
                  color: _responsiveUtils.isDesktop(context) ? AppColor.colorBgDesktop : Colors.white,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 32, top: 34),
                        child: Text(
                            AppLocalizations.of(context).manage_account,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17))),
                    const SizedBox(height: 12),
                    ListView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        key: const Key('list_manage_account_property'),
                        shrinkWrap: true,
                        itemCount: controller.listAccountProperties.length,
                        itemBuilder: (context, index) => Obx(() => AccountPropertyTileBuilder(
                            context,
                            _imagePaths,
                            _responsiveUtils,
                            controller.listAccountProperties[index],
                            controller.dashBoardController.accountPropertySelected.value))),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: AppColor.lineItemListColor, height: 0.5, thickness: 0.2)),
                    Padding(padding: const EdgeInsets.only(left: 32),
                      child: InkWell(child: Row(children: [
                        SvgPicture.asset(_imagePaths.icLogout, fit: BoxFit.fill),
                        const SizedBox(width: 12),
                        Expanded(child: Text(AppLocalizations.of(context).sign_out,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black)))
                      ]))),
                  ]),
                )),
              ]
          ),
        )
     );
  }
}