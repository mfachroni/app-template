// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:smartklas_frontend/layouts/provider/sidebar_provider.dart';

// class AppSidebar extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   const AppSidebar({super.key, required this.scaffoldKey});

//   @override
//   State<StatefulWidget> createState() {
//     return AppSidebarState();
//   }
// }

// class AppSidebarState extends State<AppSidebar> {
//   int selectedIndex = 0;
//   bool extended = false;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 250,
//       child: Material(
//         child: Scrollbar(
//           controller: _scrollController,
//           child: Consumer<SidebarProvider>(
//             builder: (context, value, child) {
//               return ListView.builder(
//                 controller: _scrollController,
//                 itemCount: value.listMenu.length,
//                 itemBuilder: (context, index) {
//                   if (value.listMenu[index].type == SideType.menu) {
//                     SideMenu item = value.listMenu[index] as SideMenu;

//                     return _SidebarMenu(
//                       menu: item,
//                     );
//                   }

//                   return const SizedBox();
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void toggleSidebar() {
//     setState(() {
//       extended = !extended;
//     });
//   }
// }

// class _SidebarMenu extends StatelessWidget {
//   final SideMenu menu;
//   final int treeIndex;
//   final double fontSize = 14;
//   final double iconSize = 20;

//   const _SidebarMenu({
//     required this.menu,
//     this.treeIndex = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isSelected = menu.isSelected(context);
//     if (menu.menus.isEmpty) {
//       return ListTile(
//         dense: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16)
//             .copyWith(left: 16 + (treeIndex * 8)),
//         selected: isSelected,
//         leading: Icon(
//           menu.iconData,
//           size: menu.iconData == CupertinoIcons.circle ? 12 : iconSize,
//         ),
//         title: Text(
//           menu.label,
//           style: TextStyle(fontSize: fontSize),
//         ),
//         onTap: () => menu.action(context),
//         style: ListTileStyle.drawer,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//       );
//     } else {
//       return _SideMenuExpansion(
//         menu: menu,
//         treeIndex: treeIndex,
//         fontSize: fontSize,
//         iconSize: iconSize,
//         // isExpanded: isSelected,
//       );
//     }
//   }
// }

// class _SideMenuExpansion extends StatefulWidget {
//   final SideMenu menu;
//   final int treeIndex;
//   final double fontSize;
//   final double iconSize;

//   const _SideMenuExpansion({
//     required this.menu,
//     this.treeIndex = 0,
//     required this.fontSize,
//     required this.iconSize,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return _SideMenuExpansionState();
//   }
// }

// class _SideMenuExpansionState extends State<_SideMenuExpansion> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16)
//               .copyWith(left: 16 + (widget.treeIndex * 8)),
//           selected: widget.menu.isExpanded || widget.menu.isSelected(context),
//           leading: Icon(
//             widget.menu.iconData,
//             size: widget.iconSize,
//           ),
//           title: Text(
//             widget.menu.label,
//             style: TextStyle(fontSize: widget.fontSize),
//           ),
//           onTap: () {
//             setState(() {
//               Provider.of<SidebarProvider>(context, listen: false)
//                   .setExpanded(widget.menu, !widget.menu.isExpanded);
//             });
//           },
//           style: ListTileStyle.drawer,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           trailing: Icon(
//             widget.menu.isExpanded || widget.menu.isSelected(context)
//                 ? Icons.arrow_drop_down
//                 : Icons.arrow_right_sharp,
//             size: widget.iconSize,
//           ),
//         ),
//         AnimatedContainer(
//           duration: const Duration(
//             milliseconds: 200,
//           ),
//           height: widget.menu.isExpanded || widget.menu.isSelected(context)
//               ? getMenuLength(widget.menu, 0, 1) * 40
//               : 0,
//           child: ListView(
//             reverse: true,
//             children: widget.menu.menus.reversed
//                 .map((e) => _SidebarMenu(
//                       menu: e,
//                       treeIndex: widget.treeIndex + 1,
//                     ))
//                 .toList(),
//           ),
//         )
//       ],
//     );
//   }

//   int getMenuLength(SideMenu menu, int currentTotal, int count) {
//     if (menu.menus.isNotEmpty) {
//       currentTotal = menu.menus.length;
//       for (var item in menu.menus) {
//         if (item.isExpanded || item.isSelected(context)) {
//           currentTotal = currentTotal +
//               getMenuLength(item, currentTotal + item.menus.length, count + 1);
//         }
//       }
//     } else {
//       currentTotal = menu.menus.length;
//     }
//     return currentTotal;
//   }
// }

// abstract class SideItem {
//   SideType get type;
// }

// enum SideType { menu, title }

// class SideMenu extends SideItem {
//   String label;
//   String key;
//   String routePath;
//   IconData iconData;
//   List<SideMenu> menus;
//   List<String> permissions;
//   bool isExpanded;

//   SideMenu({
//     required this.label,
//     required this.key,
//     required this.routePath,
//     required this.iconData,
//     this.menus = const [],
//     this.permissions = const [],
//     this.isExpanded = false,
//   });

//   factory SideMenu.fromJson(Map<String, dynamic> json) {
//     return SideMenu(
//       label: json['label'],
//       key: json['key'],
//       routePath: json['routepath'],
//       iconData: Icons.dashboard,
//     );
//   }

//   void action(BuildContext context) {
//     GoRouter.of(context).go(routePath);
//   }

//   bool isSelected(BuildContext context) {
//     return _isSelectedItem(context, this);
//   }

//   bool _isSelectedItem(BuildContext context, SideMenu item) {
//     var ret = false;
//     if (item.menus.isEmpty) {
//       ret = GoRouter.of(context).location == item.routePath;
//     } else {
//       for (var e in item.menus) {
//         ret = GoRouter.of(context).location.contains(e.routePath);
//         if (ret) {
//           break;
//         }
//         ret = _isSelectedItem(context, e);
//         if (ret) {
//           break;
//         }
//       }
//     }

//     return ret;
//   }

//   @override
//   SideType type = SideType.menu;
// }
