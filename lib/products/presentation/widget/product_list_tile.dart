import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../domain/entities/product.dart';
import '../page/product_view_page.dart';

class ProductListTile extends StatefulWidget {
  final Product product;
  const ProductListTile({
    required this.product,
  });

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Constant.auth != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductViewPage(
              product: widget.product,
            ),
          ));
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(

            // padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Constant.backgroundColor,
                borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 2), blurRadius: 10)
                ]),
            margin: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: widget.product.images.length > 0
                        ? Image.network(widget.product.images.first.src)
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                          )),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            widget.product.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      // AutoSizeText(
                      //   product.name,
                      //   minFontSize: 10,
                      //   textAlign: TextAlign.center,
                      //   maxLines: 2,
                      // ),
                      // AutoSizeText(
                      //   '💎 ' + product.price,
                      //   textAlign: TextAlign.center,
                      //   maxLines: 1,
                      // ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                      imageErrorBuilder: (e, o, c) {
                                        return Container();
                                      }),
                                ),
                                AutoSizeText(
                                  widget.product.price,
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
        if (widget.product.stockStatus == 'outofstock')
          Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: new BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Constant.color1,
                        // borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 10)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Out of stock",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )),
      ]),
    );
  }
}
