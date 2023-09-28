import 'package:app_template/app_sidebar.dart';
import 'package:app_template/app_template_controller_widget.dart';
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppSidebar(
                    key: _sidebarState,
                    scaffoldKey: _scaffoldKey,
                  ),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // AppBar(
                      //   elevation: 1,
                      //   title: const Text('Smartklas'),
                      //   actions: [
                      //     IconButton(
                      //       onPressed: () {
                      //         GoRouter.of(
                      //           context,
                      //         ).pop();
                      //       },
                      //       icon: const Icon(
                      //         Icons.settings,
                      //       ),
                      //     )
                      //   ],
                      // ),
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
                                  padding: bodyPadding.copyWith(
                                    bottom: 8,
                                  ),
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
      
    );
  }
}
