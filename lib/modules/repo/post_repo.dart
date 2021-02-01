import 'package:vnrealtor/modules/services/comment_srv.dart';
import 'package:vnrealtor/modules/services/graphql_helper.dart';
import 'package:vnrealtor/modules/services/post_srv.dart';
import 'package:vnrealtor/utils/spref.dart';

import 'filter.dart';

class PostRepo {
  Future getNewFeed({GraphqlFilter filter}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data =
        'q:{limit: ${filter?.limit}, page: ${filter?.page ?? 1}, offset: ${filter?.offset}, filter: ${filter?.filter}, search: "${filter?.search}" , order: ${filter?.order} }';
    final res = await PostSrv().query('getNewsFeed', data, fragment: '''
    data {
id
content
mediaPostIds
commentIds
userId
like
userLikeIds
share
userShareIds
locationLat
locationLong
expirationDate
publicity
user {
  id 
  uid 
  name 
  email 
  phone 
  role 
  reputationScore 
  createdAt 
  updatedAt 
  friendIds
}
mediaPosts {
id
userId
type
like
userLikeIds
commentIds
description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
}
createdAt
updatedAt
}
    ''');
    return res['getNewsFeed'];
  }

  Future getMyPost({GraphqlFilter filter}) async {
    final id = await SPref.instance.get('id');
    final res = await PostSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: '{createdAt: -1}',
        filter: 'userId: "$id"');
    return res;
  }

  Future createComment(
      {String postId, String mediaPostId, String content}) async {
    String data = '''
content: "$content"
like: 0
    ''';
    if (mediaPostId != null) {
      data += '\nmediaPostId: "$mediaPostId"';
    } else {
      data += '\npostId: "$postId"';
    }
    final res = await CommentSrv().add(data, fragment: '''
    id
    userId
    postId
    mediaPostId
    like
    content
    ''');
    return res;
  }

  Future createPost(String content, String expirationDate, bool publicity,
      double lat, double long, List<String> images, List<String> videos) async {
    String data = '''
content: "$content"
publicity: $publicity
videos: ${GraphqlHelper.listStringToGraphqlString(videos)}
images: ${GraphqlHelper.listStringToGraphqlString(images)}
    ''';

    if (expirationDate != null) {
      data += '\nexpirationDate: "$expirationDate"';
    }
    if (lat != null && long != null) {
      data += '\nlocationLat: $lat\nlocationLong: $long';
    }
    final res =
        await PostSrv().mutate('createPost', 'data: {$data}', fragment: '''
id
content
mediaPostIds
commentIds
userId
like
userLikeIds
share
userShareIds
locationLat
locationLong
expirationDate
publicity
user {
  id 
  uid 
  name 
  email 
  phone 
  role 
  reputationScore 
  createdAt 
  updatedAt
  friendIds
}
mediaPosts {
id
userId
type
like
userLikeIds
commentIds
description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
}
createdAt
updatedAt
    ''');
    return res["createPost"];
  }

  Future getAllCommentByPostId({String postId}) async {
    final res =
        await CommentSrv().getList(limit: 20, filter: "{postId: \"$postId\"}");
    return res;
  }

  Future getAllCommentByMediaPostId({String postMediaId}) async {
    final res = await CommentSrv()
        .getList(limit: 20, filter: "{mediaPostId: \"$postMediaId\"}");
    return res;
  }

  Future increaseLikePost({String postId}) async {
    final res = await PostSrv()
        .mutate('increaseLikePost', 'postId: "$postId"', fragment: 'id');
    return res;
  }

  Future decreaseLikePost({String postId}) async {
    final res = await PostSrv()
        .mutate('decreaseLikePost', 'postId: "$postId"', fragment: 'id');
    return res;
  }

  Future increaseLikeMediaPost({String postMediaId}) async {
    final res = await PostSrv().mutate(
        'increaseMediaLikePost', 'mediaPostId: "$postMediaId"',
        fragment: 'id');
    return res;
  }

  Future decreaseLikeMediaPost({String postMediaId}) async {
    final res = await PostSrv().mutate(
        'decreaseMediLikePost', 'mediaPostId: "$postMediaId"',
        fragment: 'id');
    return res;
  }
}
