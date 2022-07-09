import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/map_yelp_data/yelp.dart';
import 'package:chatting/model/yelp/yelp_model.dart';

import 'package:equatable/equatable.dart';

part 'yelpapi_state.dart';

class YelpapiCubit extends Cubit<YelpapiState> {
  final Repositorys yelpapi;
  YelpapiCubit(Repositorys _re)
      : yelpapi = _re ?? Repositorys.get(),
        super(YelpapiInitial());

  Future<void> YelpApiGetDatafun(
      {String Location,
      String latitude,
      String longitude,
      String categories}) async {
    try {
      List<BusinessYelp> yelpdata = await yelpapi.getBusinesses(
          Location: Location,
          categories: categories,
          latitude: latitude,
          longitude: longitude);

      if (yelpdata != null) {
        print("Welcome ");
        emit(YelpDataGet(yelpdata: yelpdata));
      }
    } catch (e) {
      emit(YelpError(message: "Error"));
    }
  }
}
