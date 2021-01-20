import 'package:flutter/rendering.dart';
import 'package:vnrealtor/modules/post/create_post_page.dart';
import 'package:vnrealtor/modules/post/seach_post_page.dart';
import 'package:vnrealtor/share/import.dart';

import 'post_widget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool showAppBar = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(appBarControll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(appBarControll);
    super.dispose();
  }

  void appBarControll() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (!showAppBar)
        setState(() {
          showAppBar = !showAppBar;
        });
    } else {
      if (showAppBar) if (_controller.offset > kToolbarHeight + 10)
        setState(() {
          showAppBar = !showAppBar;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: showAppBar ? PostPageAppBar() : null,
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            SizedBox(
              height: (!showAppBar)
                  ? MediaQuery.of(context).padding.top + kToolbarHeight + 10
                  : 0,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: deviceWidth(context),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      CreatePostPage.navigate();
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(13),
                      color: ptPrimaryColor(context),
                      child: Container(
                        height: 52,
                        width: 52,
                        child: Center(
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Đăng bài viết',
                    style: ptBigBody(),
                  ),
                ],
              ),
            ),
            PostWidget(),
            PostWidget(),
            PostWidget(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class PostPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  PostPageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30, top: 12, bottom: 10, right: 30),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            SizedBox(
              width: 15,
            ),
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                style: ptBigBody(),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm dự án, địa điểm',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  SearchPostPage.navigate();
                }),
            SizedBox(
              width: 5,
            ),
          ]),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HexColor('#55e678'), HexColor('#3ad6db')],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class PostPageAppBarInvisible extends StatelessWidget
    implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  PostPageAppBarInvisible();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.transparent,
    );
  }
}
