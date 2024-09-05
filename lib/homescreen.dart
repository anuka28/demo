import 'package:Anyquire/call_logs.dart';
import 'package:Anyquire/terms.dart';
import 'package:Anyquire/user_wallet.dart';

import 'package:Anyquire/main.dart';

import 'package:Anyquire/usersearch.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(
    BuildContext context,
  ) {
    final bodies = [
      // ExpertSignUpStepper(),
      // HomeController(),
      //  SearchPage(),
      UserSearch(),
      CallLogsPage(),
      ConsumerTranaction(),
      ConsumerProfilePage()
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Buttoncolor,
        unselectedLabelStyle: TextStyle(color: Buttoncolor),
        unselectedIconTheme: IconThemeData(color: Buttoncolor),
        selectedIconTheme: IconThemeData(color: Buttoncolor),
        selectedItemColor: Buttoncolor,
        selectedLabelStyle: TextStyle(color: Buttoncolor),
        showUnselectedLabels: true,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
              ),
              label: 'Call Logs'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: bodies[index],
    );
  }
}
