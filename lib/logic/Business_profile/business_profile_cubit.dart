import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/business_profile.dart';
import 'package:chatting/model/business_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

part 'business_profile_state.dart';

class BusinessProfileCubit extends Cubit<BusinessProfileState> {
  final Business_Profile_Services business_profile_services;
  StreamSubscription streamSubscription;
  BusinessProfileCubit(this.business_profile_services)
      : super(BusinessProfileInitial());

  Future<void> get_Business_Profile({String room_id}) {
    streamSubscription = business_profile_services
        .get_business_profile_data(Room_ID: room_id)
        .listen((event) {
      if (event.businessId != null) {
        emit(HasData_Business_Profile(business: event));
      } else {
        emit(Has_Error_Business_profile(message: "Business Not Found"));
      }
    });
  }
}
