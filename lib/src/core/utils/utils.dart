import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool hasEndDicas = false;

  static List<String> patternGif = [
    "01_01",
    "01_02",
    "01_03",
    "02_01",
    "02_02",
    "02_03",
    "03_01",
    "04_01",
    "04_02",
    "05_01"
  ];

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
        ((name.length * 0.1).ceil() < 1 ? 1 : (name.length * 0.1).ceil());

    if (orderStrings.length <= dicas + 1) {
      dicas = orderStrings.length - 1;
      hasEndDicas = true;
    }
    for (int j = 0; j < dicas; j++) {
      final characters = hiddenName.characters.toList();
      int index = name.indexOf(orderStrings.first);
      characters[index] = orderStrings.first;
      var nameTemp = name.characters.toList();
      nameTemp[index] = "_";
      name = nameTemp.join("");
      hiddenName = characters.join("");
      orderStrings.removeAt(0);
    }

    return hiddenName;
  }

  static bool verifyIfDicasEnd() {
    return hasEndDicas;
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
    if (hours < 0 || minutes < 0 || seconds < 0) {
      return "";
    }
    String formattedDuration =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedDuration;
  }

  static Path drawStar(Size size) {
    try {
      double degToRad(double deg) => deg * (pi / 180.0);

      const numberOfPoints = 5;
      final halfWidth = size.width / 2;
      final externalRadius = halfWidth;
      final internalRadius = halfWidth / 2.5;
      final degreesPerStep = degToRad(360 / numberOfPoints);
      final halfDegreesPerStep = degreesPerStep / 2;
      final path = Path();
      final fullAngle = degToRad(360);
      path.moveTo(size.width, halfWidth);

      for (double step = 0; step < fullAngle; step += degreesPerStep) {
        path.lineTo(halfWidth + externalRadius * cos(step),
            halfWidth + externalRadius * sin(step));
        path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
            halfWidth + internalRadius * sin(step + halfDegreesPerStep));
      }
      path.close();
      return path;
    } catch (e) {
      return Path();
    }
  }

  static Future<void> launchMyUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static String generateGif() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyy').format(now);
    Random random = Random(int.parse(formattedDate));
    int randomIndex = random.nextInt(patternGif.length);
    String valorSorteado = patternGif[randomIndex];

    return valorSorteado;
  }

  static String generateEmojiByNumber(String number) {
    switch (number) {
      case "0":
        return "0⃣";
      case "1":
        return "1⃣";
      case "2":
        return "2⃣";
      case "3":
        return "3⃣";
      case "4":
        return "4⃣";
      case "5":
        return "5⃣";
      case "6":
        return "6⃣";
      case "7":
        return "7⃣";
      case "8":
        return "8⃣";
      case "9":
        return "9⃣";
    }
    return "";
  }

  static String generateEmojiText(Player sortedPlayer, List<Player> guessList) {
    String result = "";
    int count = 0;
    int extra = 0;
    for (Player item in guessList.reversed) {
      if (count > 5) {
        extra += 1;
        continue;
      }
      if (item.nationality == sortedPlayer.nationality) {
        result += "🟩";
      } else {
        result += "🟥";
      }
      if (item.age == sortedPlayer.age) {
        result += "🟩";
      } else if (item.age > sortedPlayer.age) {
        result += "⬇️";
      } else {
        result += "⬆️";
      }
      if (item.pos == sortedPlayer.pos) {
        result += "🟩";
      } else {
        result += "🟥";
      }
      if (listEquals(item.yearsPlayed, sortedPlayer.yearsPlayed)) {
        result += "🟩";
      } else if (sortedPlayer.yearsPlayed.any(item.yearsPlayed.contains)) {
        result += "🟧";
      } else {
        result += "🟥";
      }
      if (item.playedTeam == sortedPlayer.playedTeam) {
        result += "🟩";
      } else {
        result += "🟥";
      }
      result += "\n";
      count += 1;
    }
    if (extra > 0) {
      result += "➕";
      for (String item in extra.toString().characters) {
        result += Utils.generateEmojiByNumber(item);
      }
      result += "\n\n";
    } else {
      result += "\n";
    }

    return result;
  }
}
