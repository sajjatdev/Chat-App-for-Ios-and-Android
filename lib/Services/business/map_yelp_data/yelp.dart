import 'package:chatting/Helper/config.dart';
import 'package:chatting/model/yelp/yelp_model.dart';
import 'package:dio/dio.dart';
import 'package:yelp_fusion_client/yelp_fusion_client.dart';

class yelp_api_services {
  final Dio dio;

  yelp_api_services(
    this.dio,
  );
  Future<List<yelp_model>> YelpApidata({
    String Location,
    String lat,
    String lng,
    String category,
  }) async {
    print("Yelp call process");

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "token ${yelpapi}";
    final response = await dio.get(urls,
        queryParameters: {"location": "canada", "categories": "coffee"});
    print(response.statusCode);
  }
}
