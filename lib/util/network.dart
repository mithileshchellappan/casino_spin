import 'dart:convert';

import 'package:dio/dio.dart';

class Network {
  var dio = Dio();
  String mainUrl = 'http://casino.pro-z.in';

  Future<String> nextShow() async {
    var res = await dio.post('$mainUrl/time/next',
        data: {'userid': '1', 'accesstoken': '123456'});
    print(res.data);
    int status = res.data['status'];

    if(status==200){
      String message = res.data['message'];
      if(message=='Next show Times'){
        print(res.data['Mins']['date']);
        DateTime dt = DateTime.parse(res.data['Mins']['date']).add(Duration(minutes: res.data['Mins']['min'],hours: res.data['Mins']['hour']));
        print(dt.toString()+'dt');
        // dt.add(Duration(minutes: res.data['Mins']['min'],hours: res.data['Mins']['hour']));
        print(dt.toString()+'dt');
        return dt.toString();
      }
      else{
        return 'No Show';
      }

    }
    else{
      return 'No Show';
    }
    
  }
}
