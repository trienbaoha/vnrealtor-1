import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/model/friendship.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/repo/user_repo.dart';
import 'package:vnrealtor/share/import.dart';

class UserBloc extends ChangeNotifier {
  UserBloc._privateConstructor() {
    init();
  }
  static final UserBloc instance = UserBloc._privateConstructor();

  List<FriendshipModel> friendRequestFromOtherUsers = [];
  List<UserModel> followersIn7Days = [];

  Future init() async {
    final token = await SPref.instance.get('token');
    final id = await SPref.instance.get('id');
    if (token != null && id != null) {
      getFriendRequestFromOtherUsers();
      getFollowerIn7d();
    }
  }

  Future<BaseResponse> getFriendRequestFromOtherUsers() async {
    try {
      final res = await UserRepo().friendRequestFromOtherUsers();
      final List listRaw = res;
      final list = listRaw.map((e) => FriendshipModel.fromJson(e)).toList();
      list.removeWhere((element) => element.status != FriendShipStatus.PENDING);
      friendRequestFromOtherUsers = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListUser({GraphqlFilter filter}) async {
    try {
      final res = await UserRepo().getListUser(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      list.removeWhere(
          (element) => element.id == AuthBloc.instance.userModel.id);
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future getFollowerIn7d() async {
    try {
      final userId = await SPref.instance.get('id');
      final res = await UserRepo().getFollowerIn7d(userId);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      list.removeWhere(
          (element) => element.id == AuthBloc.instance.userModel.id);
      followersIn7Days = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getMyFriendShipWith(String userId) async {
    try {
      final res = await UserRepo().getMyFriendShipWith(userId);
      return BaseResponse.success(FriendshipModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> sendFriendInvite(String userId) async {
    try {
      final res = await UserRepo().sendFriendInvite(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> unfollowUser(String userId) async {
    try {
      final res = await UserRepo().unfollowUser(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> followUser(String userId) async {
    try {
      final res = await UserRepo().followUser(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> acceptFriendInvite(String friendShipId) async {
    try {
      final res = await UserRepo().acceptFriend(friendShipId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> declineFriendInvite(String friendShipId) async {
    try {
      final res = await UserRepo().declineFriend(friendShipId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final res = await UserRepo().changePassword(oldPassword, newPassword);
      final val = UserModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }
}
