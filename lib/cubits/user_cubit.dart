import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/user_model.dart';

class UserCubit extends Cubit<User> {
  UserCubit(super.initialState);

  void update(Map<String, dynamic> map) {
    User user = User.fromMap(map);
    emit(user);
  }

}