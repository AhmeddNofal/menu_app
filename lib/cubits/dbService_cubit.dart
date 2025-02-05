import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/services/databaseService.dart';

class DbserviceCubit extends Cubit<DatabaseService> {
  DbserviceCubit() : super(DatabaseService());

  void update(DatabaseService dbService) {
    emit(dbService);
  }
}