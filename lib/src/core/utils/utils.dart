import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Utils {
  static String convertYearsPlayedInvervalToString(
      List<String> yearsPlayedInterval) {
    return yearsPlayedInterval.map((elemento) {
      return '[$elemento]';
    }).join(', ');
  }

  static String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  static String hiddenName(String name, int count) {
    List<String> orderStrings = _shuffleName(name);
    orderStrings.removeWhere((e) => e.trim() == "");
    String hiddenName = name.characters
        .toList()
        .map((e) => e != " " ? "_" : e)
        .toList()
        .join('');
    int countRodadas = count ~/ 5;
    int dicas = countRodadas *
        ((name.length * 0.1).round() < 1 ? 1 : (name.length * 0.1).round());

    for (int j = 0; j < dicas; j++) {
      final characters = hiddenName.characters.toList();
      characters[name.indexOf(orderStrings.first)] = orderStrings.first;
      hiddenName = characters.join("");
      orderStrings.removeAt(0);
    }

    return hiddenName;
  }

  static List<String> _shuffleName(String name) {
    // Calcula o hash do nome usando o algoritmo SHA-256
    var bytes = utf8.encode(name);
    var hash = sha256.convert(bytes);
    var hashString = hash.toString();

    // Converte o hash em uma sequência de números
    var numbers = hashString.runes.map((rune) {
      return int.parse(String.fromCharCode(rune), radix: 16);
    }).toList();

    // Embaralha a ordem das letras usando os números gerados
    var letters = name.split('');
    var random = Random(numbers.reduce((a, b) =>
        a + b)); // Define uma semente para garantir a mesma ordem para todos
    letters.shuffle(random);

    return letters;
  }

  static String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    String formattedDuration =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedDuration;
  }
}
