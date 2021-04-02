import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/http.dart';
import 'package:flutter_app/config/router.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 1;
  final bg = DecorationImage(
    image: AssetImage("images/bg/bg.png"),
    alignment: Alignment.topCenter,
    fit: BoxFit.fitWidth,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          for (var i = 0; i < Tabs.length; i++)
            BottomNavigationBarItem(
              label: Tabs[i].label,
              icon: Tabs[i].icon,
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: bg,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _SearchBar(),
              _TaskTable(),
              _Menu(),
              _Notice(),
              _TaskList(),
            ],
          ),
        ),
      ),
    );
  }
}

var decoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
);

/// 搜索栏
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                hintText: '任务标题、编号、用户ID、昵称',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.only(bottom: 28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.headset_mic_outlined,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

/// 任务
class _TaskTable extends StatelessWidget {
  Widget buildItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'username',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'task',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  'id:666',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  '+2.5元',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: decoration,
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(
            width: 1,
            color: Color(0xffe6e6e6),
          ),
        ),
        children: [
          TableRow(
            children: [
              TableCell(child: buildItem(context)),
              TableCell(child: buildItem(context)),
            ],
          ),
          TableRow(
            children: [
              TableCell(child: buildItem(context)),
              TableCell(child: buildItem(context)),
            ],
          ),
        ],
      ),
    );
  }
}

/// 菜单
class _Menu extends StatelessWidget {
  Widget buildMenu(String icon, String name) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Image.asset(
              'images/icon/$icon',
              height: 38,
              width: 38,
            ),
            Text(name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      padding: const EdgeInsets.only(top: 12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Table(
        children: [
          TableRow(children: [
            buildMenu('bag.png', '悬赏管理'),
            buildMenu('flag.png', '发布悬赏'),
            buildMenu('note.png', '发布管理'),
          ]),
          TableRow(children: [
            buildMenu('wallet.png', '全民分红'),
            buildMenu('land.png', '我的领地'),
            buildMenu('equity.png', '股权'),
          ]),
        ],
      ),
    );
  }
}

/// 通知
class _Notice extends StatefulWidget {
  @override
  __NoticeState createState() => __NoticeState();
}

class __NoticeState extends State<_Notice> {
  final controller = PageController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    createTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void createTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (controller.page == 3) {
        controller.animateToPage(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      } else {
        controller.nextPage(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Widget buildNotice() {
    return GestureDetector(
      child: PageView.builder(
        controller: controller,
        itemBuilder: (ctx, index) {
          return Center(
            child: Container(
              width: double.infinity,
              child: Text(
                "some text $index",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        itemCount: 5,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: get("/api/nodes", query: {
                "page": "1",
                "itemsPerPage": "3",
                "type.id": "3",
              }),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                }
                if (snapshot.hasError) {
                  throw snapshot.error ?? "获取通知数据未知错误";
                }
                return buildNotice();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 任务列表
class _TaskList extends StatelessWidget {
  Widget buildItem(int index) {
    var createTab = (String text, int type) {
      Color color;
      switch (type) {
        case 1:
          color = Colors.blue;
          break;
        case 2:
          color = Colors.green;
          break;
        case 3:
          color = Colors.red;
          break;
        default:
          color = Colors.blue;
      }
      return Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3)),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        margin: const EdgeInsets.only(right: 5),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      );
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffe6e6e6))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 40,
                    height: 40,
                  ),
                ),
                Text(
                  'username',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('task name'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text('description'),
                  ),
                  Wrap(
                    children: [
                      createTab('tag1', 1),
                      createTab('tag2', 2),
                      createTab('tag3', 3),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(
                '1元',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe6e6e6))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '推荐任务',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  children: [
                    Text('更多'),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ],
            ),
          ),
          for (var i = 0; i < 10; i++) buildItem(i)
        ],
      ),
    );
  }
}
