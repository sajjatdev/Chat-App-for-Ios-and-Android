List SearchKeyGenerator({String item}) {
  List itemkeyList = [];
  String key = '';

  for (var i = 0; i < item.length; i++) {
    key += item[i];
    itemkeyList.add(key);
  }
  return itemkeyList;
}
