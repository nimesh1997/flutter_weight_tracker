class TrackWeight{

  TrackWeight(this.weight, this.dateTime, this.detail);

  double weight;
  DateTime dateTime;
  String detail;

  @override
  String toString() {
    return 'TrackWeight{weight: $weight, dateTime: $dateTime, detail: $detail}';
  }


}