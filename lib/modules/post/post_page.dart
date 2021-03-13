import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/share/widget/load_more.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/create_post_page.dart';
import 'package:datcao/modules/post/search_post_page.dart';
import 'package:datcao/share/import.dart';

import 'post_widget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool showAppBar = true;
  PostBloc _postBloc;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(appBarControll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _postBloc.feedScrollController = _controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.removeListener(appBarControll);
    super.dispose();
  }

  void appBarControll() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward ||
        _controller.offset == 0) {
      if (!showAppBar)
        setState(() {
          showAppBar = !showAppBar;
        });
    } else {
      if (showAppBar) if (_controller.offset > kToolbarHeight)
        setState(() {
          showAppBar = !showAppBar;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _postBloc.pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0)
            return Scaffold(
              backgroundColor: ptBackgroundColor(context),
              appBar: showAppBar ? PostPageAppBar() : null,
              body: LoadMoreScrollView(
                scrollController: _controller,
                onLoadMore: () {
                  _postBloc.loadMoreNewFeed();
                },
                list: RefreshIndicator(
                  color: ptPrimaryColor(context),
                  onRefresh: () async {
                    await Future.wait([
                      _postBloc.getNewFeed(
                          filter: GraphqlFilter(
                              limit: 10, order: "{updatedAt: -1}")),
                      _postBloc.getStoryFollowing()
                    ]);
                    return;
                  },
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        SizedBox(
                          height: (!showAppBar)
                              ? MediaQuery.of(context).padding.top +
                                  kToolbarHeight
                              : 0,
                        ),
                        CreatePostCard(
                          postBloc: _postBloc,
                          pageController: _postBloc.pageController,
                        ),
                        if (_postBloc.isReloadFeed) PostSkeleton(),
                        if (_postBloc.hasTags != null &&
                            _postBloc.hasTags.length > 0)
                          Container(
                            width: deviceWidth(context),
                            height: 30,
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.separated(
                              // shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 10,
                                );
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    SearchPostPage.navigate(
                                        hashTag: _postBloc.hasTags[index]
                                            ['value']);
                                  },
                                  child: Container(
                                    height: 30,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: ptSecondaryColor(context),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        _postBloc.hasTags[index]['value']
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _postBloc.hasTags.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _postBloc.feed.length,
                          itemBuilder: (context, index) {
                            final item = _postBloc.feed[index];
                            return PostWidget(item);
                          },
                        ),
                        if (_postBloc.isLoadMoreFeed && !_postBloc.isEndFeed)
                          PostSkeleton(
                            count: 1,
                          ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          else
            return CreatePostPage(_postBloc.pageController);
        });
  }
}

class CreatePostCard extends StatelessWidget {
  final PostBloc postBloc;
  final PageController pageController;

  const CreatePostCard({Key key, this.postBloc, this.pageController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      //elevation: 5,
      child: Container(
        width: deviceWidth(context),
        padding: EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(0),
                  //elevation: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      children: [
                        Text(
                          'Đăng tin của bạn',
                          style: ptTitle(),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.location_pin,
                              size: 21,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              MdiIcons.image,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if ((postBloc.stories?.length ?? 0) > 0 || postBloc.isLoadStory)
              Divider(
                height: 10,
              ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: 6,
            //       ),
            //       Image.asset('assets/image/map_icon.png'),
            //       SizedBox(
            //         width: 6,
            //       ),
            //       Text(
            //         // 'Bài viết nổi bật',
            //         '',
            //         style: ptBody().copyWith(
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            postBloc.isLoadStory
                ? StorySkeleton()
                : postBloc.stories.length == 0
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            itemCount: postBloc.stories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return _buildStoryWidget(postBloc.stories[index]);
                            }),
                      ),
          ],
        ),
      ),
    );
  }

  _buildStoryWidget(PostModel postModel) {
    return Center(
      child: GestureDetector(
        onTap: () {
          PostDetail.navigate(postModel);
        },
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 144,
            width: 109,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        postModel.storyImages[0] ??
                            postModel.mediaPosts[0].url))),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.white),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.white,
                          backgroundImage: postModel.user.avatar != null
                              ? CachedNetworkImageProvider(
                                  postModel.user.avatar)
                              : AssetImage('assets/image/default_avatar.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Text(
                        postModel.user.name,
                        overflow: TextOverflow.fade,
                        style: ptTiny().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              if (postModel.district != null && postModel.district.trim() != "")
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_pin, size: 16),
                      SizedBox(width: 1),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 95),
                        child: Text(
                          postModel.district,
                          style: ptTiny(),
                        ),
                      ),
                    ],
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}

class PostPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  PostPageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            GestureDetector(
              onTap: () {
                SearchPostPage.navigate().then((value) =>
                    FocusScope.of(context).requestFocus(FocusNode()));
              },
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.search,
                  size: 26,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                InboxList.navigate();
              },
              child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    MdiIcons.chatProcessing,
                    size: 26,
                  )),
            )
          ],
        ),
      ),
      color: ptSecondaryColor(context),
    );
  }
}
