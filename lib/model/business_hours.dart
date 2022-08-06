class BusinessHours {
  OpeningHours openingHours;

  BusinessHours({this.openingHours});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    openingHours = json['opening_hours'] != null
        ? new OpeningHours.fromJson(json['opening_hours'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours.toJson();
    }
    return data;
  }
}

class OpeningHours {
  bool openNow;
  List<Periods> periods;
  List<String> weekdayText;

  OpeningHours({this.openNow, this.periods, this.weekdayText});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods.add(new Periods.fromJson(v));
      });
    }
    weekdayText = json['weekday_text'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_now'] = this.openNow;
    if (this.periods != null) {
      data['periods'] = this.periods.map((v) => v.toJson()).toList();
    }
    data['weekday_text'] = this.weekdayText;
    return data;
  }
}

class Periods {
  Close close;
  Close open;

  Periods({this.close, this.open});

  Periods.fromJson(Map<String, dynamic> json) {
    close = json['close'] != null ? new Close.fromJson(json['close']) : null;
    open = json['open'] != null ? new Close.fromJson(json['open']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.close != null) {
      data['close'] = this.close.toJson();
    }
    if (this.open != null) {
      data['open'] = this.open.toJson();
    }
    return data;
  }
}

class Close {
  int day;
  String time;

  Close({this.day, this.time});

  Close.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}
