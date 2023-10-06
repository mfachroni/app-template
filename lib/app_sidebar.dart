// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_template/controller/app_sidebar_controller.dart';

class AppSidebar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color sideBarColor;
  final Color sideBarTextIconColor;
  final Color sideBarTextIconSelectedColor;
  final Color selectedTileColor;
  final List<SideMenu> listMenu;
  final double width;
  final Function(BuildContext context, SideMenu sideMenu) action;
  final Function()? onCreated;
  final Function()? onInit;

  const AppSidebar({
    super.key,
    required this.scaffoldKey,
    this.sideBarColor = const Color(0xFF0F172B),
    this.sideBarTextIconColor = const Color(0xFF94A3B8),
    this.sideBarTextIconSelectedColor = Colors.white,
    this.listMenu = const [],
    this.width = 250,
    required this.action,
    this.selectedTileColor = const Color(0xFF2D3345),
    this.onCreated,
    this.onInit,
  });

  @override
  State<StatefulWidget> createState() {
    return AppSidebarState();
  }
}

class AppSidebarState extends State<AppSidebar> {
  int selectedIndex = 0;
  bool extended = false;
  AppSidebarController controller = AppSidebarController();

  @override
  void initState() {
    controller.setListMenu(widget.listMenu);
    if (widget.onInit != null) {
      widget.onInit!();
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => controller,
        ),
      ],
      child: Builder(
        builder: (context) => _SideMenuBuild(
          action: widget.action,
          listMenu: widget.listMenu,
          scaffoldKey: widget.scaffoldKey,
          selectedTileColor: widget.selectedTileColor,
          sideBarColor: widget.sideBarColor,
          sideBarTextIconColor: widget.sideBarTextIconColor,
          sideBarTextIconSelectedColor: widget.sideBarTextIconSelectedColor,
          width: widget.width,
          onCreated: widget.onCreated,
        ),
      ),
    );
  }
}

class _SideMenuBuild extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color sideBarColor;
  final Color sideBarTextIconColor;
  final Color sideBarTextIconSelectedColor;
  final Color selectedTileColor;
  final List<SideMenu> listMenu;
  final double width;
  final Function(BuildContext context, SideMenu sideMenu) action;
  final Function()? onCreated;
  const _SideMenuBuild({
    Key? key,
    required this.scaffoldKey,
    required this.sideBarColor,
    required this.sideBarTextIconColor,
    required this.sideBarTextIconSelectedColor,
    required this.selectedTileColor,
    required this.listMenu,
    required this.width,
    required this.action,
    required this.onCreated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SideMenuBuildState();
  }
}

class _SideMenuBuildState extends State<_SideMenuBuild> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<AppSidebarController>(context, listen: false)
      //     .setListMenu(widget.listMenu)
      //     .then((value) {
      if (widget.onCreated != null) {
        widget.onCreated!();
      }
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Material(
        color: widget.sideBarColor,
        child: Scrollbar(
          controller: _scrollController,
          child: Consumer<AppSidebarController>(
            builder: (context, value, child) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: value.listMenu.length,
                itemBuilder: (context, index) {
                  if (value.listMenu[index].type == SideType.menu) {
                    SideMenu item = value.listMenu[index];

                    return _SidebarMenu(
                      menu: item,
                      sideBarTextIconColor: widget.sideBarTextIconColor,
                      sideBarTextIconSelectedColor:
                          widget.sideBarTextIconSelectedColor,
                      action: widget.action,
                      selectedTileColor: widget.selectedTileColor,
                    );
                  }

                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SidebarMenu extends StatelessWidget {
  final SideMenu menu;
  final int treeIndex;
  final double fontSize = 12;
  final double iconSize = 20;
  final Color sideBarTextIconSelectedColor;
  final Color sideBarTextIconColor;
  final Color selectedTileColor;
  final Function(BuildContext context, SideMenu sideMenu) action;

  const _SidebarMenu({
    required this.menu,
    this.treeIndex = 0,
    required this.sideBarTextIconSelectedColor,
    required this.sideBarTextIconColor,
    required this.action,
    required this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = menu.isSelected();
    if (menu.menus.isEmpty) {
      return Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                .copyWith(left: 16 + (treeIndex * 8)),
            selected: isSelected,
            hoverColor: selectedTileColor, //const Color(0xFF2D3345),
            selectedTileColor: selectedTileColor, //  Color(0xFF2D3345),
            selectedColor: sideBarTextIconSelectedColor,
            leading: Icon(
              menu.iconData,
              size: menu.iconData == CupertinoIcons.circle ? 12 : iconSize,
              color: isSelected
                  ? sideBarTextIconSelectedColor
                  : sideBarTextIconColor,
            ),
            title: Text(
              menu.label,
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected
                    ? sideBarTextIconSelectedColor
                    : sideBarTextIconColor,
              ),
            ),
            onTap: () {
              action(context, menu);
            },
            style: ListTileStyle.drawer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(
            height: 4,
          )
        ],
      );
    } else {
      return Column(children: [
        _SideMenuExpansion(
          menu: menu,
          treeIndex: treeIndex,
          fontSize: fontSize,
          iconSize: iconSize,
          sideBarTextIconColor: sideBarTextIconColor,
          sideBarTextIconSelectedColor: sideBarTextIconSelectedColor,
          action: action,
          selectedTileColor: selectedTileColor,
        ),
        const SizedBox(
          height: 4,
        )
      ]);
    }
  }
}

class _SideMenuExpansion extends StatefulWidget {
  final SideMenu menu;
  final int treeIndex;
  final double fontSize;
  final double iconSize;
  final Color sideBarTextIconSelectedColor;
  final Color sideBarTextIconColor;
  final Color selectedTileColor;
  final Function(BuildContext context, SideMenu sideMenu) action;

  const _SideMenuExpansion({
    required this.menu,
    this.treeIndex = 0,
    required this.fontSize,
    required this.iconSize,
    required this.sideBarTextIconSelectedColor,
    required this.sideBarTextIconColor,
    required this.action,
    required this.selectedTileColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _SideMenuExpansionState();
  }
}

class _SideMenuExpansionState extends State<_SideMenuExpansion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int menuLength = getMenuLength(widget.menu, 0, 1);
    int menuExpanded = getMenuExpanded(widget.menu, 0, 1);
    return Column(
      children: [
        ListTile(
          dense: true,
          hoverColor: widget.selectedTileColor,
          selectedTileColor: widget.selectedTileColor,
          selectedColor: widget.sideBarTextIconSelectedColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16)
              .copyWith(left: 16 + (widget.treeIndex * 8)),
          selected: Provider.of<AppSidebarController>(context, listen: false)
              .isExpanded(widget.menu),
          leading: Icon(
            widget.menu.iconData,
            size: widget.iconSize,
            color: Provider.of<AppSidebarController>(context, listen: false)
                    .isExpanded(widget.menu)
                ? widget.sideBarTextIconSelectedColor
                : widget.sideBarTextIconColor,
          ),
          title: Text(
            widget.menu.label,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Provider.of<AppSidebarController>(context, listen: false)
                      .isExpanded(widget.menu)
                  ? widget.sideBarTextIconSelectedColor
                  : widget.sideBarTextIconColor,
            ),
          ),
          onTap: () {
            Provider.of<AppSidebarController>(context, listen: false)
                .setExpanded(
                    widget.menu,
                    !Provider.of<AppSidebarController>(context, listen: false)
                        .isExpanded(widget.menu));
          },
          style: ListTileStyle.drawer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          trailing: Icon(
            Provider.of<AppSidebarController>(context, listen: false)
                    .isExpanded(widget.menu)
                ? Icons.arrow_drop_down
                : Icons.arrow_right_sharp,
            size: widget.iconSize,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          height: Provider.of<AppSidebarController>(context, listen: false)
                  .isExpanded(widget.menu)
              ? (menuLength * 40) + (menuLength * 4) + ((menuExpanded) * 4) + 4
              : 0,
          child: ListView(
            reverse: true,
            children: [
              ...widget.menu.menus.reversed
                  .map((e) => _SidebarMenu(
                        menu: e,
                        treeIndex: widget.treeIndex + 1,
                        sideBarTextIconColor: widget.sideBarTextIconColor,
                        sideBarTextIconSelectedColor:
                            widget.sideBarTextIconSelectedColor,
                        action: widget.action,
                        selectedTileColor: widget.selectedTileColor,
                      ))
                  .toList(),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int getMenuLength(SideMenu menu, int currentTotal, int count) {
    if (menu.menus.isNotEmpty) {
      currentTotal = menu.menus.length;
      for (var item in menu.menus) {
        if (Provider.of<AppSidebarController>(context, listen: false)
            .isExpanded(item)) {
          currentTotal = currentTotal +
              getMenuLength(item, currentTotal + item.menus.length, count + 1);
        }
      }
    } else {
      currentTotal = menu.menus.length;
    }
    return currentTotal;
  }

  int getMenuExpanded(SideMenu menu, int currentTotal, int count) {
    if (menu.menus.isNotEmpty) {
      for (var item in menu.menus) {
        if (Provider.of<AppSidebarController>(context, listen: false)
            .isExpanded(item)) {
          currentTotal++;

          currentTotal = getMenuExpanded(item, currentTotal, count + 1);
        }
      }
    }
    return currentTotal;
  }
}

class DeepMenu {
  int expandedCount;
  int maxDeep;

  DeepMenu({this.expandedCount = 0, this.maxDeep = 0});
}

abstract class SideItem {
  SideType get type;
}

enum SideType { menu, title }

class SideMenu extends SideItem {
  String label;
  String key;
  String routePath;
  IconData iconData;
  List<SideMenu> menus;
  List<String> permissions;
  bool selected;

  SideMenu({
    required this.label,
    required this.key,
    required this.routePath,
    required this.iconData,
    this.menus = const [],
    this.permissions = const [],
    this.selected = false,
  });

  factory SideMenu.fromJson(Map<String, dynamic> json) {
    return SideMenu(
      label: json['label'],
      key: json['key'],
      routePath: json['routepath'],
      iconData: Icons.dashboard,
    );
  }

  void action(BuildContext context) {
    // GoRouter.of(context).go(routePath);
  }

  bool isSelected() {
    if (menus.isEmpty) {
      return selected;
    }
    return _isSelectedItem(this);
  }

  bool _isSelectedItem(SideMenu item) {
    var ret = false;
    if (item.menus.isEmpty) {
      ret = item.selected;
    } else {
      for (var element in item.menus) {
        ret = _isSelectedItem(element);

        if (ret) {
          break;
        }
      }
    }

    return ret;
  }

  @override
  SideType type = SideType.menu;
}
