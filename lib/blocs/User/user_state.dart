part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserUpdated extends UserState {}

class UserLoging extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserFailToUpdate extends UserState {
  final String message;

  UserFailToUpdate(this.message);
}
