import 'package:app_template/app_template_controller_widget.dart';
import 'package:app_template/app_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Color sideBarColor = Color(0xFF0F172B);
final Color sideBarTextIconColor = Color(0xFF94A3B8);
final Color sideBarTextIconSelectedColor = Colors.white;

class AppSidebar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AppSidebar({super.key, required this.scaffoldKey});

  @override
  State<StatefulWidget> createState() {
    return AppSidebarState();
  }
}

class AppSidebarState extends State<AppSidebar> {
  int selectedIndex = 0;
  bool extended = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    Future.delayed(
      Duration.zero,
      () {
        String location =
            AppTemplateControllerWidget.of(context)!.getCurrentLocation();
        AppTemplateControllerWidget.of(context)!
            .appController
            .setSelected(location);
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Material(
        color: sideBarColor,
        child: Scrollbar(
          controller: _scrollController,
          child: Consumer<AppController>(
            builder: (context, value, child) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: value.listMenu.length,
                itemBuilder: (context, index) {
                  if (value.listMenu[index].type == SideType.menu) {
                    SideMenu item = value.listMenu[index];

                    return _SidebarMenu(
                      menu: item,
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

  void toggleSidebar() {
    setState(() {
      extended = !extended;
    });
  }
}

class _SidebarMenu extends StatelessWidget {
  final SideMenu menu;
  final int treeIndex;
  final double fontSize = 12;
  final double iconSize = 20;

  const _SidebarMenu({
    required this.menu,
    this.treeIndex = 0,
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
            hoverColor: const Color(0xFF2D3345),
            selectedTileColor: const Color(0xFF2D3345),
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
            onTap: () => menu.action(context),
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

  const _SideMenuExpansion({
    required this.menu,
    this.treeIndex = 0,
    required this.fontSize,
    required this.iconSize,
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
          hoverColor: const Color(0xFF2D3345),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16)
              .copyWith(left: 16 + (widget.treeIndex * 8)),
          selected: Provider.of<AppController>(context, listen: false)
              .isExpanded(widget.menu),
          leading: Icon(
            widget.menu.iconData,
            size: widget.iconSize,
            color: Provider.of<AppController>(context, listen: false)
                    .isExpanded(widget.menu)
                ? sideBarTextIconSelectedColor
                : sideBarTextIconColor,
          ),
          title: Text(
            widget.menu.label,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Provider.of<AppController>(context, listen: false)
                      .isExpanded(widget.menu)
                  ? sideBarTextIconSelectedColor
                  : sideBarTextIconColor,
            ),
          ),
          onTap: () {
            setState(() {
              Provider.of<AppController>(context, listen: false).setExpanded(
                  widget.menu,
                  !Provider.of<AppController>(context, listen: false)
                      .isExpanded(widget.menu));
            });
          },
          style: ListTileStyle.drawer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          trailing: Icon(
            Provider.of<AppController>(context, listen: false)
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
          height: Provider.of<AppController>(context, listen: false)
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
        if (Provider.of<AppController>(context, listen: false)
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
        if (Provider.of<AppController>(context, listen: false)
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
