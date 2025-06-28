import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/features/calendar/views/calendar_view.dart';
import 'package:hidi/features/daily-song/views/daily_scong_view.dart';
import 'package:hidi/features/follow/views/follow_list_view.dart';
import 'package:hidi/features/search/views/search_view.dart';
import 'package:hidi/features/users/views/user_profile_view.dart';

class MainNavigationView extends StatefulWidget {
  static const routeName = "mainNavigation";
  static const initialTab = "daily-song";
  static const routeURL = "/";

  final dynamic tab;
  const MainNavigationView({super.key, required this.tab});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = [
      'daily-song',
      'calendar',
      'search',
      'follow',
      'mypage',
    ];

    late int _selectIndex = _tabs.indexOf(widget.tab);

    void _onDestinationSelected(int index) {
      context.go("/${_tabs[index]}");
      setState(() {
        _selectIndex = index;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Offstage(offstage: _selectIndex != 0, child: DailySongView()),
          Offstage(offstage: _selectIndex != 1, child: CalendarView()),
          Offstage(offstage: _selectIndex != 2, child: SearchView()),
          Offstage(offstage: _selectIndex != 3, child: FollowView()),
          Offstage(offstage: _selectIndex != 4, child: MyPageView()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: "오늘의 곡",
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.calendar),
            label: "날짜별 노래",
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "검색",
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.users),
            label: "팔로우 목록",
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.user),
            label: "마이페이지",
          ),
        ],
        selectedIndex: _selectIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
