import 'package:test_flutter/network/BaseApi.dart';

class PatientProvider extends BaseApi{

  Future<dynamic> sendData(Map body) async {
    var responseJson;
    try{
      responseJson = await postHttp("DUMMY URL",body: body);
    }catch(e){
    }
    return responseJson;
  }

}