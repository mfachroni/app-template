import 'package:app_template/app_container.dart';
import 'package:app_template/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTopBar extends StatefulWidget {
  const AppTopBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatePage();
  }
}

class _StatePage extends State<AppTopBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: AppBar().preferredSize.height,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  // IconButton(
                  //   constraints:
                  //       const BoxConstraints(maxWidth: 38, maxHeight: 38),
                  //   onPressed: () {
                  //     if (Responsive.isMobile(context)) {
                  //       Scaffold.of(context).openDrawer();
                  //     } else {
                  //       Provider.of<AppController>(context, listen: false)
                  //           .sidebarToggle();
                  //     }
                  //   },
                  //   icon: const Icon(Icons.dehaze),
                  // ),
                  const SizedBox(
                    width: 8,
                  ),
                  // if (widget.pageTitle != null)
                  Consumer<AppController>(
                      builder: (context, value, child) {
                    return Text(value.pageTitle,
                        style: Theme.of(context).textTheme.headlineSmall!);
                    //       if (!Responsive.isMobile(context))
                    //         Container(
                    //           margin: const EdgeInsets.symmetric(horizontal: 8),
                    //           width: 1,
                    //           height: 20,
                    //           color: Colors.grey.shade300,
                    //         ),
                    //       if (!Responsive.isMobile(context))
                    //         Consumer<BreadcrumbController>(
                    //           builder: (context, value, child) {
                    //             if (value.breadcrumbs.isEmpty) {
                    //               return const SizedBox();
                    //             }
                    //             return BreadCrumb.builder(
                    //               itemCount: value.breadcrumbs.length,
                    //               builder: (index) {
                    //                 AppBreadcrumb breadcrumb = value.breadcrumbs[index];

                    //                 return BreadCrumbItem(
                    //                   content: Text(breadcrumb.label.toUpperCase()),
                    //                   onTap: () {
                    //                     // Helper.setBreadcrumb(context, breadcrumb.name!);
                    //                     GoRouter.of(context).go(breadcrumb.path);
                    //                   },
                    //                 );
                    //               },
                    //               divider: Icon(
                    //                 Icons.chevron_right,
                    //                 color: Colors.grey.shade400,
                    //               ),
                    //             );

                    //           },
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    // Row(
                    //   children: [
                    //     const TopBarButtonNotif(),
                    //     AppTopBarUserButton(),
                    //   ],
                    // )
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
