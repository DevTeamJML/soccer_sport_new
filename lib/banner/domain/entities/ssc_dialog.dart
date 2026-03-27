import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:wordpress_api/wordpress_api.dart';

class SscDialog extends Equatable {
  final int id;
  final String image;
  final String callback;
  final bool isDialog;
  final String? dialogDescription;
  final String? dialogTitle;
  final String? button;
  final bool isAuth;

  SscDialog(
      {required this.id,
      required this.image,
      required this.callback,
      required this.isDialog,
      this.dialogTitle,
      this.dialogDescription,
      this.button,
      required this.isAuth});

  // Article({@required this.url, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory SscDialog.fromJson(
    Map<String, dynamic> json,
  ) {
    return SscDialog(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      image: json['image'],
      callback: json['callback'],
      isDialog: json['isDialog'] == "1" ? true : false,
      dialogDescription: json['dialog_description'] != null
          ? json['dialog_description']
          : null,
      dialogTitle: json['dialog_title'] != null ? json['dialog_title'] : null,
      button: json['button'] != null ? json['button'] : null,
      isAuth: json['is_auth'] == "1" ? true : false,
    );
  }

  // Map<String, List<href>> toJson() {
  //   return {url: href};
  // }

  @override
  List<Object?> get props =>
      [id, image, callback, isDialog, dialogDescription, button];
}
