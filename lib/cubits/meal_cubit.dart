import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/meal_model.dart';

class MealCubit extends Cubit<Meal> {
  MealCubit(super.initialState);

  void update(Meal meal) {
    emit(meal);
  }
}
