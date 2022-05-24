import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/User.dart';
import 'package:marka_app/Data/Repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository authRepository;
  late User user;
  UserCubit(this.authRepository) : super(UserInitial());

  updateUserInfo(dynamic request) {
    emit(UserLoging());
    authRepository.update(request).then((responce) => {
          if (responce.status == Status.completed)
            {emit(UserUpdated())}
          else if (responce.status == Status.error)
            {emit(UserFailToUpdate("فشل حفظ البيانات"))}
        });
  }

  getUser(int id) {
    authRepository.getUser(id).then((responce) => {
          if (responce.status == Status.completed)
            {user = User.fromJson(responce.data), emit(UserLoaded(user))}
          else if (responce.status == Status.error)
            {emit(UserFailToUpdate("فشل حفظ البيانات"))}
        });

    // return user;
  }
}
