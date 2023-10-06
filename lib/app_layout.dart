import 'package:app_template/controller/app_controller.dart';
import 'package:app_template/app_sidebar.dart';
import 'package:app_template/app_topbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<AppSidebarState> _sidebarState = GlobalKey();
  final Widget body;
  final bool scrollable;
  final ScrollController _scrollController = ScrollController();
  final EdgeInsets bodyPadding;
  final Widget? topChild;

  AppLayout(
      {super.key,
      required this.body,
      this.scrollable = false,
      this.bodyPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.topChild});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Consumer<AppController>(
                  builder: (context, value, child) {
                    return value.enableSidebar
                        ? AppSidebar(
                            key: _sidebarState,
                            scaffoldKey: _scaffoldKey,
                            listMenu: value.listMenu,
                            action: (context, sideMenu) {
                              
                            },
                          )
                        : const SizedBox();
                  },
                ),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppTopBar(),
                    const SizedBox(
                      height: 1,
                    ),
                    if (topChild != null) topChild!,
                    const SizedBox(
                      height: 1,
                    ),
                    Expanded(
                      child: Scaffold(
                        key: _scaffoldKey,
                        body: scrollable
                            ? Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  padding: bodyPadding.copyWith(bottom: 48),
                                  controller: _scrollController,
                                  child: body,
                                ),
                              )
                            : Padding(
                                padding: bodyPadding,
                                child: body,
                              ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
