import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/business.dart';
import 'package:equatable/equatable.dart';

part 'business_create_state.dart';

class BusinessCreateCubit extends Cubit<BusinessCreateState> {
  final Business_Services business_services;
  BusinessCreateCubit(this.business_services) : super(BusinessCreateInitial());

  Future<void> Create_Business(
      {String address,
      var latitude,
      var longitude,
      String imageURl,
      String Business_Name,
      String Business_Id,
      String owner,
      String description,
      List customer,
      String type}) async {
    try {
      await business_services.create_business(
        address: address,
        latitude: latitude,
        longitude: longitude,
        imageURl: imageURl,
        description: description,
        Business_Id: Business_Id,
        Business_Name: Business_Name,
        owner: owner,
        customer: customer,
        type: type,
      );
    } catch (e) {}
  }
}
