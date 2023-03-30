import 'package:flutter/material.dart';

class TabBarPage extends StatefulWidget {
  final List<Widget> pages;
  final int initialIndex;

  const TabBarPage({
    Key? key,
    required this.pages,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.pages.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: widget.pages,
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[500],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(
              iconMargin: EdgeInsets.only(bottom: 3),
              icon: Icon(Icons.home, size: 20),
              text: "Home",
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 3),
              icon: Icon(Icons.explore, size: 20),
              text: "Explore",
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 3),
              icon: Icon(Icons.favorite, size: 20),
              text: "Favorites",
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 3),
              icon: Icon(Icons.person, size: 20),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
