import 'package:app_template/app_sidebar.dart';
import 'package:app_template/app_template_controller_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

abstract class AppController extends ChangeNotifier {
  String pageTitle = 'Page Title';
  double elevation = 0;

  List<SideMenu> listMenu = [];
  List<String> listExpanded = [];

  Future<Response> getSidebarData(BuildContext context);
  actionSidebar(BuildContext context, String routePath);
  String getCurrentLocation();

  late Map<String, String> routePath;
  late Map<String, IconData> iconData;

  Future<void> loadSideMenu(BuildContext context) async {
    String location = getCurrentLocation();

    Response response = await getSidebarData(context);

    List<dynamic> rawData = response.data;

    listMenu.clear();
    for (var element in rawData) {
      listMenu.add(
        SideMenu(
            label: element['name'],
            key: element['key'],
            routePath: routePath.containsKey(element['key'])
                ? routePath[element['key']]!
                : '-',
            iconData: iconData.containsKey(element['key'])
                ? iconData[element['key']]!
                : CupertinoIcons.dot_square,
            menus: searchChildren(element['children']),
            selected: routePath.containsKey(element['key'])
                ? routePath[element['key']]! == location
                : false),
      );
    }

    searchAndSetSelected(listMenu, location);
    initExpanded(listMenu);

    notifyListeners();
  }

  List<SideMenu> searchChildren(List<dynamic> element) {
    List<SideMenu> children = [];
    if (element.isNotEmpty) {
      for (var item in element) {
        children.add(SideMenu(
            label: item['name'],
            key: item['key'],
            routePath: routePath.containsKey(item['key'])
                ? routePath[item['key']]!
                : 'zzzz',
            iconData: iconData.containsKey(item['key'])
                ? iconData[item['key']]!
                : CupertinoIcons.circle,
            menus: searchChildren(item['children'])));
      }
    }

    return children;
  }

  void setExpanded(SideMenu menu, bool value) {
    if (value) {
      listExpanded.add(menu.key);
    } else {
      listExpanded.remove(menu.key);
    }

    notifyListeners();
  }

  bool isExpanded(SideMenu menu) {
    if (listExpanded.indexWhere((element) => element == menu.key) != -1) {
      return true;
    }

    return false;
  }

  void setSelected(String routePath) {
    searchAndSetSelected(listMenu, routePath);
    listExpanded.clear();
    initExpanded(listMenu);

    notifyListeners();
  }

  void searchAndSetSelected(List<SideMenu> menus, String routePath) {
    for (var element in menus) {
      if (element.menus.isEmpty) {
        element.selected = routePath.contains(element.routePath);
      } else {
        searchAndSetSelected(element.menus, routePath);
      }
    }
  }

  void initExpanded(List<SideMenu> menus) {
    for (var element in menus) {
      if (element.menus.isNotEmpty) {
        if (element.isSelected()) {
          listExpanded.add(element.key);
        } else {
          listExpanded.remove(element.key);
        }
        initExpanded(element.menus);
      }
    }
  }
}
