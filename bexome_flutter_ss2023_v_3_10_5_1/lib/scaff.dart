import 'pages/about.dart';
import 'pages/homepage.dart';
import 'pages/myaccount.dart';
import 'pages/study.dart';
import 'pages/stats.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class RootApp extends StatefulWidget {
  int page = 0;
  bool dataNotSend = true;

  RootApp({Key? key})
      : super(key: key); // const RootApp({Key? key}) : super(key: key);
  RootApp._privateConstructor();

  static final RootApp instance = RootApp._privateConstructor();
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (RootApp.instance.page != 0) {
      pageIndex = RootApp.instance.page;
      RootApp.instance.page = 0;
    }
    print(pageIndex);

    print("InObject?side scaff.dart - build() ...");
    return Scaffold(
      body: getBody(), // returns main page
      bottomNavigationBar: getFooter(), // returns bottomnavigationbar
    );
  }

  Widget getBody() {
    print("Inside scaff.dart - getBody() ...");

    return IndexedStack(
      // only the page on the right index is shown
      index: pageIndex,
      children: [
        HomePage(),
        StatsPage(),
        MyAccount(),
        Study(),
        About(),
      ],
    );
  }

  Widget getFooter() {
    List items = [
      Icons.home,
      Icons.bar_chart,
      Icons.person_rounded,
      Icons.info_outlined,
      Icons.article_outlined,
    ];
    return Container(
      height: 60, //defines height of the footer
      width: double.infinity,
      decoration: BoxDecoration(
        color: white, // backgroundcolor of bottomnavigationbar
        border: Border(
            top: BorderSide(
                width: 1,
                color: black.withOpacity(
                    0.06))), // edit look of the upper line of bottomnavigationbar
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
            top: 10), //manage the spacing within the bottomnavigationbar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            return InkWell(
              // rectangular area of a Material that responds to touch.
              onTap: () {
                setState(() {
                  pageIndex =
                      index; // change to the right index if tapped on icon --> manages main page
                });
              },
              child: Column(
                // column of right icon, space in between and the circle which indicates which icon/page is choosen
                children: [
                  Icon(
                    items[index],
                    size: 28,
                    color: pageIndex == index ? thirdColor : black,
                  ),
                  SizedBox(
                    height: 5,
                  ), // manages spacing
                  pageIndex == index
                      ? Container(
                          // if this icon choosen then indicate it with a circle below it
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: thirdColor, shape: BoxShape.circle),
                        )
                      : Container() //if icon not choosen display nothing
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
