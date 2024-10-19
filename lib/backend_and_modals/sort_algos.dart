import 'key_data.dart';

class Sortalgos {
  List<key_data> bn;
  Sortalgos({required this.bn});

  void sortByName() {
    bn.sort((a, b) => a.batch.name.compareTo(b.batch.name));
  }

  void sortByClass() {
    bn.sort((a, b) => a.batch.clasS.compareTo(b.batch.clasS));
  }

  void sortByTime() {
    bn.sort((a, b) {
      int hourComparison =
          a.batch.classDateTime.hour.compareTo(b.batch.classDateTime.hour);
      if (hourComparison != 0) {
        return hourComparison;
      } else {
        return a.batch.classDateTime.minute
            .compareTo(b.batch.classDateTime.minute);
      }
    });
  }

  void sortByWeek() {
    int day = DateTime.now().weekday;
    day += (day > 5 ? -5 : 2);
    Set<int> deleted = {};
    List<key_data> ret = [];
    for (int i = day; i <= 7; i++) {
      for (int n = 0; n < bn.length; n++) {
        if (deleted.contains(n)) continue;
        if (bn[n].batch.days.contains(i)) {
          ret.add(bn[n]);
          deleted.add(n);
        }
      }
    }
    for (int i = 1; i < day; i++) {
      for (int n = 0; n < bn.length; n++) {
        if (deleted.contains(n)) continue;
        if (bn[n].batch.days.contains(i)) {
          ret.add(bn[n]);
          deleted.add(n);
        }
      }
    }
    for (int i = 0; i < ret.length; i++) {
      bn[i] = ret[i];
    }
  }

  List<key_data> priorityMode() {
    DateTime hm = DateTime.now();
    int day = DateTime.now().weekday;
    day += (day > 5 ? -5 : 2);
    List<key_data> priority = [];
    List<index_key_data> ikd = [];
    for (int i = 0; i < bn.length; i++) {
      if (bn[i].batch.days.contains(day)) {
        ikd.add(index_key_data(index: i, batchKD: bn[i]));
      }
    }
    ikd.sort((a, b) {
      int hourComparison = a.batchKD.batch.classDateTime.hour
          .compareTo(b.batchKD.batch.classDateTime.hour);
      if (hourComparison != 0) {
        return hourComparison;
      } else {
        return a.batchKD.batch.classDateTime.minute
            .compareTo(b.batchKD.batch.classDateTime.minute);
      }
    });
    int i = ikd.length - 1;
    while (i > -1) {
      if (ikd[i].batchKD.batch.classDateTime.hour < hm.hour ||
          (ikd[i].batchKD.batch.classDateTime.hour == hm.hour &&
              ikd[i].batchKD.batch.classDateTime.minute <= hm.minute)) {
        int m1 = ikd[i].batchKD.batch.classDateTime.hour * 60 +
                ikd[i].batchKD.batch.classDateTime.minute,
            m2 = (hm.hour - 2) * 60 + hm.minute;
        i += (m2 - m1 > 0 ? 1 : 0);
        break;
      }
      i--;
    }

    if (i == ikd.length) {
      return [];
    }
    if (i == -1) {
      i = 0;
    }

    for (int l = ikd.length - 1; l >= i; l--) {
      priority.add(ikd[l].batchKD);
      ikd[l].remove = true;
    }
    ikd.sort(
      (a, b) => a.index.compareTo(b.index),
    );
    ikd = ikd.reversed.toList();
    for (index_key_data x in ikd) {
      if (x.remove) bn.removeAt(x.index);
    }
    return priority.reversed.toList();
  }
}

class index_key_data {
  int index;
  bool remove = false;
  key_data batchKD;
  index_key_data({required this.index, required this.batchKD});
}
