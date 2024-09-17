import 'package:flutter/material.dart';
import 'package:project2/components/bottomnav.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/components/tabitem.dart';
import 'package:project2/providers/food.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FoodMethods _restaurant = FoodMethods();
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    _tabController = TabController(length: _restaurant.foodCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        title: Text("Home".toUpperCase()),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("Restaurant Menu".toUpperCase()),
                  ),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    padding: EdgeInsets.zero,
                    controller: _tabController,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    labelColor: Colors.blue[600],
                    indicatorColor: Colors.blue[600],
                    tabs: _restaurant.allFoodKey
                        .map((food) => Tab(child: Text(food.toUpperCase())))
                        .toList(),
                  ),
                ),
              ],
              body: Consumer<FoodMethods>(
                builder: (context, value, child) => TabBarView(
                  controller: _tabController,
                  children: [
                    TabItems(menu: _restaurant.vietMenu),
                    TabItems(menu: _restaurant.koreanMenu),
                    TabItems(menu: _restaurant.spanishMenu),
                    TabItems(menu: _restaurant.italianMenu),
                    TabItems(menu: _restaurant.americanMenu),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const MyBottomNavBar(currentIndex: 0),
    );
  }
}
