import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/meal_model.dart';

class MealsCubit extends Cubit<List<Meal>> {
  MealsCubit() : super([]);

  void update(List<Meal> meal) {
    emit(meal);
  }
}
