import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Yelp%20Bussiness/SearchMap.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:google_place/google_place.dart';

part 'business_info_get_state.dart';

class BusinessInfoGetCubit extends Cubit<BusinessInfoGetState> {
  final MapServices mapServices;
  BusinessInfoGetCubit(this.mapServices) : super(BusinessInfoGetInitial());
}
