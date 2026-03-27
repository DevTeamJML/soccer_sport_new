import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:wordpress_api/wordpress_api.dart';

class SscFab extends Equatable {
  final int id;
  final String icon;
  final String callback;
  final bool showDialog;
  final String? dialogDescription;
  final String? dialogBanner;
  final String? dialogTitle;

  final String? button;
  final bool isAuth;
  final bool showAuth;
  final bool showNoAuth;
  final bool isDialog;

  SscFab({
    required this.id,
    required this.icon,
    required this.callback,
    required this.showDialog,
    this.dialogBanner,
    this.dialogDescription,
    this.dialogTitle,
    this.button,
    required this.isDialog,
    required this.isAuth,
    required this.showAuth,
    required this.showNoAuth,
  });

  // Article({@required this.url, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory SscFab.fromJson(
    Map<String, dynamic> json,
  ) {
    return SscFab(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      icon: json['icon'],
      callback: json['callback'],
      showDialog: json['show_dialog'] == "1" ? true : false,
      dialogBanner:
          json['dialog_banner'] != null ? json['dialog_banner'] : null,
      dialogDescription: json['dialog_description'] != null
          ? json['dialog_description']
          : null,
      dialogTitle: json['dialog_title'] != null ? json['dialog_title'] : null,
      button: json['button'] != null ? json['button'] : null,
      isAuth: json['is_auth'] == "1" ? true : false,
      showAuth: json['auth_show'] == "1" ? true : false,
      showNoAuth: json['no_auth_show'] == "1" ? true : false,
      isDialog: json['is_dialog'] == "1" ? true : false,
    );
  }

  // Map<String, List<href>> toJson() {
  //   return {url: href};
  // }

  @override
  List<Object?> get props =>
      [id, icon, callback, showDialog, dialogBanner, dialogDescription, button];
}
