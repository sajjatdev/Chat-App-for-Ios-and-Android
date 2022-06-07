part of 'contact_cubit.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class Loading extends ContactState {}

class hasContactdata extends ContactState {
  final List<GetFireContactList> data;

  hasContactdata({this.data});
  @override
  // TODO: implement props
  List<Object> get props => [data];
}

class HasError extends ContactState {
  final String message;

  HasError({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
