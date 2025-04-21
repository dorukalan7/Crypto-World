import 'package:flutter/material.dart';

void main() => runApp(tabbar());

class tabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hulk’s TabBar Challenge',
      theme: ThemeData.dark(),
      home: HulkTabBarScreen(),
    );
  }
}

class HulkTabBarScreen extends StatelessWidget {
  final List<TabData> tabs = [
    TabData(icon: Icons.shield, label: 'Defense'),
    TabData(icon: Icons.flash_on, label: 'Power'),
    TabData(icon: Icons.map, label: 'Map'),
    TabData(icon: Icons.build, label: 'Tools'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hulk\'s Tab Controller 💪'),
          backgroundColor: Colors.green[800],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                tabs: tabs
                    .map(
                      (tab) => Tab(
                    icon: Icon(tab.icon),
                    text: tab.label,
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: tabs
              .map(
                (tab) => Center(
              child: Text(
                '${tab.label} View',
                style: TextStyle(fontSize: 24),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

class TabData {
  final IconData icon;
  final String label;

  TabData({required this.icon, required this.label});
}
