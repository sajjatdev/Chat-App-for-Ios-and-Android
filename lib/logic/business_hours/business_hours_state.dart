part of 'business_hours_cubit.dart';

abstract class BusinessHoursState extends Equatable {
  const BusinessHoursState();

  @override
  List<Object> get props => [];
}

class BusinessHoursInitial extends BusinessHoursState {}

class Business_open extends BusinessHoursState {
  final String time_open;

  Business_open({this.time_open});
}

class Business_cls extends BusinessHoursState {
  final String time_cls;

  Business_cls({this.time_cls});
}
