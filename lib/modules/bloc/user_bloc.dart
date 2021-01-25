import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/model/friendship.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/repo/user_repo.dart';
import 'package:vnrealtor/share/import.dart';

class UserBloc extends ChangeNotifier {
  UserBloc._privateConstructor();
  static final UserBloc instance = UserBloc._privateConstructor();

  Future<BaseResponse> getListUser({GraphqlFilter filter}) async {
    try {
      final res = await UserRepo().getListUser(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      list.removeWhere(
          (element) => element.id == AuthBloc.instance.userModel.id);
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> getMyFriendShipWith(String userId) async {
    try {
      final res = await UserRepo().getMyFriendShipWith(userId);
      return BaseResponse.success(FriendshipModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
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
      return BaseResponse.fail(e.message?.toString());
    } finally {
      // notifyListeners();
    }
  }
}
