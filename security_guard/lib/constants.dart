import 'package:flutter/material.dart';


const String signalRHubUrl = '$apiBaseUrl/chatHub';
// const String apiBaseUrl = "https://security-guard-api-container-app.blueocean-cf790c41.australiaeast.azurecontainerapps.io/";
const String apiBaseUrl ="https://localhost:32769";

const kSendButtonTextStyle = TextStyle(
  // color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(width: 2.0),
  ),
);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kArticleCardTitleStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
);

const Icon kHomeOut = Icon(
  Icons.home_outlined,
);
const Icon kHomeFilled = Icon(
  Icons.home,
);

const Icon kLinkOut = Icon(
  Icons.link_outlined,
);

const Icon kLinkFilled = Icon(
  Icons.link,
);
const Icon kScanOut = Icon(
  Icons.document_scanner_outlined,
);

const Icon kScanFilled = Icon(
  Icons.document_scanner,
);
const Icon kFileOut = Icon(
  Icons.file_present_outlined,
);

const Icon kFileFilled = Icon(
  Icons.file_present_rounded,
);
const Icon kChatOut = Icon(
  Icons.chat_outlined,
);

const Icon kChatFilled = Icon(
  Icons.chat,
);

const Icon kNotificationFilled = Icon(
  Icons.notifications,
);

const Icon kNotificationOut = Icon(
  Icons.notifications_outlined,
);
