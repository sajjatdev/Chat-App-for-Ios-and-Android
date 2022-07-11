import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/map_yelp_data/yelp.dart';
import 'package:chatting/model/yelp/yelp_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';

part 'yelpapi_state.dart';

class YelpapiCubit extends Cubit<YelpapiState> {
  final Repositorys yelpapi;
  YelpapiCubit(Repositorys _re)
      : yelpapi = _re ?? Repositorys.get(),
        super(YelpapiInitial());

  Future<void> initGetBusinessdata() {
    
     // emit(YelpSearchData(yelpdata: yelpdata));
  }

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

      // Business List Update App database
      if (yelpdata != null) {
        for (var i = 0; i < yelpdata.length; i++) {
          FirebaseFirestore.instance
              .collection("business_list")
              .doc(yelpdata[i].name.replaceAll(" ", ''))
              .set({
            "Id": yelpdata[i].name.replaceAll(" ", ''),
            "rating": yelpdata[i].rating,
            "price": yelpdata[i].price,
            "phone": yelpdata[i].phone,
            "Business_Id": yelpdata[i].id,
            "name": yelpdata[i].name,
            "latitude": yelpdata[i].latitude,
            "longitude": yelpdata[i].longitude,
            "distance": yelpdata[i].distance,
            "alias": yelpdata[i].alias,
            "isClosed": yelpdata[i].isClosed,
            "reviewCount": yelpdata[i].reviewCount,
            "url": yelpdata[i].url,
            'imageUrl': yelpdata[i].imageUrl,
            "address1": yelpdata[i].address1,
            "city": yelpdata[i].city,
            "country": yelpdata[i].country,
            "zip": yelpdata[i].zip,
          });
        }
        //END
      
      }
    } catch (e) {
      emit(YelpError(message: "Error"));
    }
  }
}
