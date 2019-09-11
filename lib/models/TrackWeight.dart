import 'package:firebase_database/firebase_database.dart';

class TrackWeight {

  TrackWeight(this.weight, this.dateTime, this.detail, this.timeStamp);

  String key;
  double weight;
  String dateTime;
  String detail;
  int timeStamp;


  @override
  String toString() {
    return 'TrackWeight{key: $key, weight: $weight, dateTime: $dateTime, detail: $detail, timeStamp: $timeStamp}';
  }

  TrackWeight.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime =snapshot.value["dateTime"],
        weight = snapshot.value["weight"].toDouble(),
        detail = snapshot.value["detail"],
        timeStamp = snapshot.value["timeStamp"];

  toJson() {
    return {
      "weight": weight,
      "dateTime": dateTime,
      "detail": detail,
      "timeStamp": timeStamp
    };
  }


}