import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var data = parseData(lines);
  var ingAl = ingAlMap(data);

  int safeIngCount = 0;
  for (var food in data.foods) {
    for (var ing in food.ingredients) {
      if (!ingAl.containsKey(ing)) safeIngCount++;
    }
  }

  print('$safeIngCount ingredients without allergens');
  print((ingAl.keys.toList()..sort((a, b) => ingAl[a]!.compareTo(ingAl[b]!)))
      .join(','));
}

Map<String, String> ingAlMap(Data data) {
  Map<String, String>? test(Map<String, String> candidate, int foodIndex) {
    if (foodIndex == data.foods.length) return candidate;

    for (var food in data.foods) {
      for (var al in food.allergens) {
        if (candidate.values.contains(al)) {
          var ing = candidate.keys.firstWhere((e) => candidate[e] == al);
          if (!food.ingredients.contains(ing)) return null;
        }
      }
    }

    var food = data.foods[foodIndex];

    var otherIngs = List.of(food.ingredients);
    otherIngs.retainWhere((e) => !candidate.keys.contains(e));

    var otherAls = List.of(food.allergens);
    otherAls.retainWhere((e) => !candidate.values.contains(e));

    if (otherIngs.isEmpty) return test(candidate, foodIndex + 1);

    var perm = Permutation(otherIngs.length, otherAls.length);
    for (var p in perm) {
      var recCandidate = Map.of(candidate);
      for (int i = 0; i < p.length; i++) {
        if (p[i] > -1) recCandidate[otherIngs[i]] = otherAls[p[i]];
      }
      var result = test(recCandidate, foodIndex + 1);
      if (result != null) return result;
    }

    return null;
  }

  return test({}, 0)!;
}

class Permutation extends Iterable implements Iterator {
  final int places;
  final int items;

  int _index = 0;
  List<int> _current = [];

  Permutation(this.places, this.items);

  @override
  bool moveNext() {
    if (_index == total) return false;

    _current = _perm(places, items, _index++);
    return true;
  }

  @override
  List<int> get current => _current;

  @override
  Iterator get iterator => Permutation(places, items);

  @override
  List<int> get last => _perm(places, items, total - 1);

  int get total => calcTotal(places, items);

  static int calcTotal(int tPlaces, int tItems) {
    var result = 1;
    for (var i = 0; i < tItems; i++) {
      result *= (tPlaces - i);
    }
    return result;
  }

  List<int> _perm(int rPlaces, int rItems, int rIndex) {
    if (rItems == 0) return List.filled(rPlaces, -1);

    var subTotal = calcTotal(rPlaces, rItems);
    var pos = (rIndex * rPlaces) ~/ subTotal;
    var sub = _perm(rPlaces - 1, rItems - 1, rIndex % (subTotal ~/ rPlaces));
    var result = <int>[];
    result.addAll(sub.getRange(0, pos));
    result.add(rItems - 1);
    result.addAll(sub.getRange(pos, sub.length));

    return result;
  }
}

class Food {
  final List<String> ingredients;
  final List<String> allergens;
  Food(this.ingredients, this.allergens);

  @override
  String toString() => '$ingredients ($allergens)';
}

class Data {
  final List<String> ingredients;
  final List<String> allergens;
  final List<Food> foods;
  Data(this.ingredients, this.allergens, this.foods);
}

Data parseData(List<String> lines) {
  var ingredients = <String>{};
  var allergens = <String>{};
  var foods = <Food>[];

  for (var line in lines) {
    var parts = line.split('(contains ');
    var foodIn = parts[0].trim().split(' ');
    var foodAl = parts[1].substring(0, parts[1].length - 1).split(', ');

    foodIn.sort();
    foodAl.sort();

    ingredients.addAll(foodIn);
    allergens.addAll(foodAl);
    foods.add(Food(foodIn, foodAl));
  }

  foods.sort((a, b) {
    if (a.allergens.length != b.allergens.length) {
      return a.allergens.length - b.allergens.length;
    }

    for (int i = 0; i < a.allergens.length; i++) {
      if (a.allergens[i] != b.allergens[i]) {
        return a.allergens[i].compareTo(b.allergens[i]);
      }
    }

    return a.ingredients.length - b.ingredients.length;
  });

  return Data(ingredients.toList(), allergens.toList(), foods);
}
