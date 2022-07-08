import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/map_yelp_data/yelp.dart';
import 'package:chatting/model/yelp/yelp_model.dart';
import 'package:equatable/equatable.dart';

part 'yelpapi_state.dart';

class YelpapiCubit extends Cubit<YelpapiState> {
  final yelp_api_services yelpapi;
  YelpapiCubit(this.yelpapi) : super(YelpapiInitial());

  Future<void> YelpApiGetDatafun(
      {String Location, String lat, String lng, String category}) async {
    try {
      List<yelp_model> Yelp = await yelpapi.YelpApidata(
          Location: Location, lat: lat, lng: lng, category: category);

      if (Yelp != null) {
        print("data Get Done");
        emit(YelpDataGet(yelpdata: Yelp));
      } else {
        print("data Get Error");
        emit(YelpdataEmpty());
      }
    } catch (e) {
      emit(YelpError(message: "Error"));
    }
  }
}
