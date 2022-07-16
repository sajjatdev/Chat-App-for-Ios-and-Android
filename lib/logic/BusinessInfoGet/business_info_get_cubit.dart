import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Google%20Map/SearchMap.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:google_place/google_place.dart';

part 'business_info_get_state.dart';

class BusinessInfoGetCubit extends Cubit<BusinessInfoGetState> {
  final MapServices mapServices;
  BusinessInfoGetCubit(this.mapServices) : super(BusinessInfoGetInitial());

  Future<void> BusinessDataGet({List<SearchResult> id}) async {
    print(id);
    List<DetailsResult> Businessdata =
        await mapServices.googleMapBusinessInfo(id: id);

    if (Businessdata != null) {
      emit(GetBusinessData(Businessdata: Businessdata));
    } else {
      emit(DataGetError());
    }
  }
}
