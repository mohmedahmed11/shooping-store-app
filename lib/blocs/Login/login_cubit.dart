import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/User.dart';
import 'package:marka_app/Data/Repositories/login_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  late User user;
  LoginCubit(this.loginRepository) : super(LoginInitial());

  login(dynamic requets) {
    emit(LoginLoading());
    loginRepository.login(requets).then((responce) {
      if (responce.status == Status.error) {
        emit(LoginFail(responce.message));
        // emit(LoginInitial());
      } else if (responce.status == Status.completed) {
        // print("object");
        user = User.fromJson(responce.data);
        emit(LoginSuccess(user));
      } else {
        emit(LoginLoading());
      }
    });
  }
}
