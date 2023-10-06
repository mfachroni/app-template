import 'package:app_template/app_sidebar.dart';
import 'package:flutter/cupertino.dart';

class AppSidebarController<T> extends ChangeNotifier {
  List<SideMenu> listMenu = [];
  List<String> listExpanded = [];

  late Map<String, String> routePath;
  late Map<String, IconData> iconData;

  Future<void> setListMenu(List<SideMenu> tmpMenus) async {

    listMenu.clear();
    listMenu =tmpMenus;

    // searchAndSetSelected(listMenu, location);
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

  void setSelected(SideMenu sideMenu) {
    searchAndSetSelected(listMenu, sideMenu);
    listExpanded.clear();
    initExpanded(listMenu);

    notifyListeners();
  }

  void searchAndSetSelected(List<SideMenu> menus, SideMenu selectedMenu) {
    for (var element in menus) {
      if (element.menus.isEmpty) {
        element.selected = selectedMenu.key == element.key;
      } else {
        searchAndSetSelected(element.menus, selectedMenu);
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
