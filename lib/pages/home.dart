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
              const _TaskTable(),
              const _Menu(),
              const _Notice(),
              const _TaskList(),
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
  const _TaskTable();

  Widget buildItem(BuildContext context, Map data) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipOval(
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.network(
                  "https://backend.drgxb.com${data["owner"]?["avatar"]}",
                  fit: BoxFit.cover,
                  errorBuilder: (a, b, c) {
                    return Container(
                      child: Icon(Icons.broken_image, color: Colors.white),
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["owner"]?["username"] ?? "",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  data["category"]?["name"] ?? "",
                  style: TextStyle(color: Color(0xff888888),fontSize: 14),
                ),
                Text(
                  'id:${data["id"]}',
                  style: TextStyle(color: Color(0xff888888),fontSize: 14),
                ),
                Text(
                  '+${data["price"]}元',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
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
      child: FutureBuilder<List>(
        future: get("/api/tasks", query: {
          "order[bidPosition]": "desc",
          "bidPosition[gt]": "0",
          "page": "1",
        }),
        initialData: [],
        builder: (context, snapshot) {
          return Table(
            border: TableBorder.symmetric(
              inside: BorderSide(
                width: 1,
                color: Color(0xffe6e6e6),
              ),
            ),
            children: [
              for (var i = 0; i < snapshot.data!.length; i += 2)
                TableRow(
                  children: [
                    TableCell(
                      child: buildItem(context, snapshot.data![i]),
                    ),
                    TableCell(
                      child: buildItem(context, snapshot.data![i + 1]),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

/// 菜单
class _Menu extends StatelessWidget {
  const _Menu();

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
  const _Notice();

  @override
  __NoticeState createState() => __NoticeState();
}

class __NoticeState extends State<_Notice> {
  final controller = PageController();
  Timer? timer;
  final _future = get<List>("/api/nodes", query: {
    "page": "1",
    "itemsPerPage": "3",
    "type.id": "3",
  });

  @override
  void initState() {
    super.initState();
    // createTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void createTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (controller.page == 4) {
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

  Widget buildNotice(List data) {
    return GestureDetector(
      child: PageView.builder(
        controller: controller,
        itemBuilder: (ctx, index) {
          return Center(
            child: Container(
              width: double.infinity,
              child: Text(
                data[index]['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        itemCount: data.length,
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
              future: _future,
              initialData: [],
              builder: (_, snapshot) {
                return buildNotice(snapshot.data!);
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
  const _TaskList();

  Widget buildItem(Map data) {
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
          borderRadius: BorderRadius.circular(3),
        ),
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
                  child: SizedBox(
                    width: 46,
                    height: 46,
                    child: Image.network(
                      "https://backend.drgxb.com${data["owner"]?["avatar"]}",
                      fit: BoxFit.cover,
                      errorBuilder: (a, b, c) {
                        return Container(
                          child: Icon(Icons.broken_image, color: Colors.white),
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    data["owner"]?["username"] ?? "用户名",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
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
                  Text(data["title"] ?? "标题"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${data["countApplies"]}人已赚 | 剩余：${data["remain"]}",
                      style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                    ),
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
                '${data["price"]}元',
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
      child: FutureBuilder<List>(
        initialData: [],
        future: get<List>("/api/tasks", query: {
          "page": "1",
          "sticky": "true",
          "recommended": "true",
          "order[sticky]": "desc",
        }),
        builder: (context, snapshot) {
          return Column(
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
              for (var i = 0; i < snapshot.data!.length; i++)
                buildItem(snapshot.data![i])
            ],
          );
        },
      ),
    );
  }
}
