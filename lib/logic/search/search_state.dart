part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class Loading extends SearchState {}

class Contact_show extends SearchState {
  final List<Contact_list> contact_list;

  Contact_show({this.contact_list});
}

class Contact_error extends SearchState {
  final String Message;

  Contact_error({this.Message});
}
