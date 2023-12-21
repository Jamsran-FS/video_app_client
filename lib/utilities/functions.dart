import 'package:flutter/material.dart';

String generatePostedDateTimeString(DateTime postedOn) {
  int diffInDays = DateTime.now().difference(postedOn).inDays;
  int diffInHours = DateTime.now().difference(postedOn).inHours;
  int diffInMinutes = DateTime.now().difference(postedOn).inMinutes;
  int diffInSeconds = DateTime.now().difference(postedOn).inSeconds;
  String res = '';

  if (diffInDays > 365) {
    res = '${(diffInDays / 365).floor()} жилийн өмнө';
  } else if (diffInDays > 30) {
    res = '${(diffInDays / 30).floor()} сарын өмнө';
  } else if (diffInHours > 24) {
    res = '${(diffInHours / 24).floor()} өдөрын өмнө';
  } else if (diffInMinutes > 60) {
    res = '${(diffInMinutes / 60).floor()} цагийн өмнө';
  } else if (diffInSeconds > 60) {
    res = '${(diffInSeconds / 60).floor()} минутын өмнө';
  } else {
    res = '1 минутын өмнө';
  }
  return res;
}

String generateVideoDurationFromSeconds(int sec) {
  String res = '';

  int hours = (sec / 3600).floor();
  int minutes = ((sec - (hours * 3600)) / 60).floor();
  int seconds = sec - (hours * 3600) - (minutes * 60);

  String minuteStr = minutes.toString();
  String secondStr = seconds.toString();
  if (minutes < 10) {
    minuteStr = '0$minuteStr';
  }
  if (seconds < 10) {
    secondStr = '0$secondStr';
  }

  if (hours > 0) {
    res = '$hours:$minuteStr:$secondStr';
  } else {
    res = '$minuteStr:$secondStr';
  }

  return res;
}

String summarizeNumber(int num) {
  String res = num.toString();

  if (num > 1000000000) {
    res = '${(num / 1000000000).toStringAsFixed(1)}B';
  } else if (num > 1000000) {
    res = '${(num / 1000000).toStringAsFixed(1)}M';
  } else if (num > 1000) {
    res = '${(num / 1000).toStringAsFixed(1)}k';
  }

  return res;
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'Invalid month';
  }
}

double getWatchedWidth(int duration, int watched, double width) {
  return (watched * width) / duration;
}

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
            color: Colors.lightGreen),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
      behavior: SnackBarBehavior.floating,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
