import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:google_place/google_place.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

part 'business_create_state.dart';

class BusinessCreateCubit extends Cubit<BusinessCreateState> {
  final Business_Services business_services;
  BusinessCreateCubit(this.business_services) : super(BusinessCreateInitial());

  Future<void> Create_Business(
      {
      bool isowner,
      String myuid,
      BusinessDetails businessDetails,
     }) async {
    try {
      await business_services.create_business(
        isowner: isowner,
        myuid: myuid,
        businessDetails: businessDetails
      );
    } catch (e) {}
  }
}
