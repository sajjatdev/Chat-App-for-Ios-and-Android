import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

part 'business_hours_state.dart';

class BusinessHoursCubit extends Cubit<BusinessHoursState> {
  final Business_Services business_services;
  StreamSubscription subscription;
  BusinessHoursCubit(this.business_services) : super(BusinessHoursInitial());

  Future<void> get_business_hours({String RoomId}) {
    subscription = business_services
        .get_business_hours(Room_ID: "REDSHOP")
        .listen((event) {
      print(event.businessName);
    });
  }
}
