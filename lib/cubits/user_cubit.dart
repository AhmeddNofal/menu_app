import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/user_model.dart';

class UserCubit extends Cubit<User> {
  UserCubit() : super(User());

  void update(User user) {
    emit(user);
  }

}