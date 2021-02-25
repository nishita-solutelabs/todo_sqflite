class Task {
  int _id;
  String _title;
  String _description;
  String _date;

  Task(this._title, this._date, [this._description]);

  // All the getters.
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  // All the Setters.
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (_description.length <= 255) {
      _description = newDescription;
    }
    _description = newDescription;
  }

  set date(String newDate) {
    _date = newDate;
  }

  //Storing in db as map.
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;

    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
