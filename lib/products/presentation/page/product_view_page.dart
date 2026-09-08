import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:collection/collection.dart';
import 'package:counter_button/counter_button.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/products/domain/entities/attributes.dart';
import 'package:soccer_sport/products/domain/entities/cart.dart';
import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
import 'package:soccer_sport/products/presentation/page/add_to_cart_page.dart';

import 'package:html/parser.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../authentication/presentation/page/login_page.dart';
import '../../../core/constant/constants.dart';
import '../../../injection_container.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_product.dart';
import '../../domain/entities/product.dart';
import '../widget/product_list_tile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;

  const ProductViewPage({required this.product});

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  List<Product> relatedProducts = [];
  int _counterValue = 1;
  bool isLoading = false;
  // final CarouselController _controller = CarouselController();
final CarouselSliderController _controller = CarouselSliderController();
  List<int> _imgList = [];
  int _current_slide = 0;
  int? size;
  int? color;
  int? variation;
  Attributes? sizes;
  Attributes? colors;
  Attributes? options;
  List<bool> attributesBool = [false, false, false];
  List<CartItem>? productVariations;
  final ProductBloc _productBloc = serviceLocator<ProductBloc>();
  final successSnackBar = AdvanceSnackBar(
      duration: Duration(seconds: 1),
      mode: Mode.ADVANCE,
      message: "Successfully added",
      bgColor: Colors.green);
  @override
  void initState() {
    super.initState();
    if (widget.product.images.length > 0 && widget.product.images.first != null)
      _imgList = Iterable<int>.generate(widget.product.images.length).toList();

    if (widget.product.images.length > 0) {
      sizes = widget.product.attributes
          .firstWhereOrNull((element) => element.name == 'Size');
      colors = widget.product.attributes
          .firstWhereOrNull((element) => element.name == 'Color');
      options = widget.product.attributes
          .firstWhereOrNull((element) => element.name == 'Option');
      attributesBool = [size != null, color != null, variation != null];
    }
    _productBloc.add(GetProductVariationsReques(id: widget.product.id));

    relatedProducts = Constant.allProduct
        .where((element) => widget.product.relatedID.contains(element.id))
        .toList();
  }

  @override
  void dispose() {
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddToCartPage(),
                  ));
                },
                icon: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    padding: EdgeInsets.all(4.0),
                    badgeColor: Colors.white,
                    elevation: 2,
                  ),
                  stackFit: StackFit.loose,
                  badgeContent: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: AutoSizeText(Constant.cartItems.length.toString(),
                        maxFontSize: 18,
                        minFontSize: 4,
                        style: TextStyle(color: Constant.color1, fontSize: 12)),
                  ),
                  child:
                      Icon(Icons.shopping_cart_outlined, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocProvider<ProductBloc>(
          create: (context) => _productBloc,
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is CartAdded) {
                setState(() {
                  isLoading = false;
                  Constant.cartItems = state.products;
                });
                successSnackBar.show(context);
              }

              if (state is ProductVariationsLoaded) {
                setState(() {
                  productVariations = state.products;
                });
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is LoadingProdutVariations) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: LoadingWidget());
                } else if (state is ProductError) {
                  return ErrorWidget(state.message);
                } else {
                  return Column(children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: widget.product.images.length > 0 &&
                                widget.product.images.first != null
                            ? CarouselSlider.builder(
                                carouselController: _controller,
                                itemCount: widget.product.images.length,
                                options: CarouselOptions(
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  // autoPlay: true,
                                  // autoPlayInterval: Duration(seconds: 8),
                                  // autoPlayAnimationDuration:
                                  //     Duration(milliseconds: 800),
                                  // autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current_slide = index;
                                    });
                                  },
                                ),
                                itemBuilder: (BuildContext context,
                                    int itemIndex, int pageViewIndex) {
                                  // if (itemIndex == 0) {
                                  //   return Container(
                                  //     child: Image.asset('assets/Slide1.JPG'),
                                  //   );
                                  // } else if (itemIndex == 1) {
                                  //   return Container(color: Colors.grey);
                                  // } else {
                                  //   return Container(color: Colors.blue);
                                  // }

                                  return Image.network(
                                    widget.product.images[itemIndex].src,
                                  );
                                },
                              )
                            : Image.asset('assets/image-loading.jpg')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _imgList.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(
                                    _current_slide == entry ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),

                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  widget.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.045,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20),
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: Row(children: [
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
                          productVariations != null &&
                                  productVariations!.length > 0 &&
                                  getVariationId() != null &&
                                  productVariations!
                                          .firstWhereOrNull((element) {
                                        return element.id == getVariationId();
                                      }) !=
                                      null
                              ? productVariations!.firstWhere((element) {
                                  return element.id == getVariationId();
                                }).price!
                              : widget.product.price,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21),
                          maxLines: 1,
                          minFontSize: 8,
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    if (widget.product.attributes.length > 0 && sizes != null)
                      Column(
                        children: [
                          Text(
                            "Size",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: DropdownButtonFormField(
                                items: sizes!.options.map((String option) {
                                  return new DropdownMenuItem(
                                    value: option,
                                    child: Text(option,
                                        style: TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (sizeValue) {
                                  // do other stuff with _category
                                  setState(() {
                                    size = sizes!.options
                                        .indexOf(sizeValue as String);
                                    attributesBool = [
                                      size != null,
                                      color != null,
                                      variation != null
                                    ];
                                  });
                                },
                                value:
                                    size != null ? sizes!.options[size!] : null,
                                decoration: InputDecoration(
                                  // labelText: 'Size',
                                  // floatingLabelStyle: TextStyle(color: Colors.black),
                                  // labelStyle: TextStyle(color: Colors.black),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Select Size',
                                )),
                          ),
                        ],
                      ),

                    if (widget.product.attributes.length > 0 && colors != null)
                      Column(
                        children: [
                          Text(
                            "Color",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: DropdownButtonFormField(
                                items: colors!.options.map((String option) {
                                  return new DropdownMenuItem(
                                    value: option,
                                    child: Text(option,
                                        style: TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (sizeValue) {
                                  // do other stuff with _category
                                  setState(() {
                                    color = colors!.options
                                        .indexOf(sizeValue as String);
                                    attributesBool = [
                                      size != null,
                                      color != null,
                                      variation != null
                                    ];

                                    _controller.animateToPage(color!);
                                  });
                                },
                                value: color != null
                                    ? colors!.options[color!]
                                    : null,
                                decoration: InputDecoration(
                                  // labelText: 'Size',
                                  // floatingLabelStyle: TextStyle(color: Colors.black),
                                  // labelStyle: TextStyle(color: Colors.black),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Select Color',
                                )),
                          ),
                        ],
                      ),

                    if (widget.product.attributes.length > 0 && options != null)
                      Column(
                        children: [
                          Text(
                            "Option",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: DropdownButtonFormField(
                                items: options!.options.map((String option) {
                                  return new DropdownMenuItem(
                                    value: option,
                                    child: Text(option,
                                        style: TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (sizeValue) {
                                  // do other stuff with _category
                                  setState(() {
                                    variation = options!.options
                                        .indexOf(sizeValue as String);

                                    _controller.animateToPage(variation!);
                                    attributesBool = [
                                      size != null,
                                      color != null,
                                      variation != null
                                    ];
                                  });
                                },
                                value: variation != null
                                    ? options!.options[variation!]
                                    : null,
                                decoration: InputDecoration(
                                  // labelText: 'Size',
                                  // floatingLabelStyle: TextStyle(color: Colors.black),
                                  // labelStyle: TextStyle(color: Colors.black),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Select Size',
                                )),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Divider(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitHeight,
                              child: CounterButton(
                                countColor: Colors.white,
                                buttonColor: Colors.white,
                                loading: false,
                                onChange: (int val) {
                                  if (val > 0) {
                                    setState(() {
                                      _counterValue = val;
                                    });
                                  }
                                },
                                count: _counterValue,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : widget.product.attributes.length > 0 &&
                                          (widget.product.attributes.length !=
                                              attributesBool
                                                  .where((element) =>
                                                      element == true)
                                                  .toList()
                                                  .length)
                                      ? null
                                      : () {
                                          // getVariationId();

                                          // print(getVariationId());
                                          if (Constant.auth != null) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            List<CartItem> list =
                                                List<CartItem>.from(
                                                    Constant.cartItems);
                                            List<CartProduct> cartProducts =
                                                list
                                                    .map((e) => (e.productId ==
                                                                widget.product
                                                                    .id &&
                                                            e.variation_id !=
                                                                null &&
                                                            e.variation_id ==
                                                                getVariationId())
                                                        ? CartProduct(
                                                            productId: widget
                                                                .product.id,
                                                            quantity:
                                                                _counterValue +
                                                                    e.quantity!,
                                                            variationsID:
                                                                e.variation_id)
                                                        : CartProduct(
                                                            productId:
                                                                e.productId,
                                                            quantity:
                                                                e.quantity!,
                                                            variationsID:
                                                                e.variation_id,
                                                          ))
                                                    .toList();

                                            if (list.firstWhereOrNull((e) => (e
                                                            .productId ==
                                                        widget.product.id &&
                                                    e.variation_id != null &&
                                                    e.variation_id ==
                                                        getVariationId())) ==
                                                null) {
                                              cartProducts.add(CartProduct(
                                                  productId: widget.product.id,
                                                  quantity: _counterValue,
                                                  variationsID:
                                                      getVariationId()));
                                            }
                                            _productBloc.add(
                                              AddToCartRequest(
                                                cart: Cart(
                                                    userId: Constant.auth!.id,
                                                    products: cartProducts),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(),
                                                ))
                                                .then((_) => setState(() {
                                                      Constant.customer =
                                                          Constant.customer;
                                                      Constant.auth =
                                                          Constant.auth;
                                                    }));
                                          }
                                        },
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: widget.product.attributes.length >
                                                0 &&
                                            (widget.product.attributes.length !=
                                                attributesBool
                                                    .where((element) =>
                                                        element == true)
                                                    .toList()
                                                    .length)
                                        ? Colors.grey
                                        : Constant.color1,
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(5.0))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Expanded(flex: 1, child: Container()),

                                        BlocBuilder<ProductBloc, ProductState>(
                                          builder: (context, state) {
                                            if (state is AddingToCart) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              );
                                            } else {
                                              return AutoSizeText(
                                                'Add To Cart',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              );
                                            }
                                          },
                                        ),
                                      ]),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Divider(),
                    ),
                    // Column(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(children: [
                    //         Text('Description',
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 18))
                    //       ]),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.all(8),
                    //       child: ExpandablePanel(
                    //         header: Text('Description',
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 18)),
                    //         collapsed: Text(
                    //           parse(widget.product.description).documentElement!.text,
                    //           softWrap: true,
                    //           maxLines: 2,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         expanded: Text(
                    //           parse(widget.product.description).documentElement!.text,
                    //           softWrap: true,
                    //         ),
                    //       ),
                    //     ),

                    //   ],
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(8),
                    //   child: ExpandablePanel(
                    //     header: Text('Description',
                    //         style:
                    //             TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    //     collapsed: Text(
                    //       parse(widget.product.description).documentElement!.text,
                    //       softWrap: true,
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     expanded: Text(
                    //       parse(widget.product.description).documentElement!.text,
                    //       softWrap: true,
                    //     ),
                    //   ),
                    // ),
                    ExpandableNotifier(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(children: [
                                          Text('Description',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                        ]),
                                      ),
                                      Text(
                                        parse(widget.product.description)
                                            .documentElement!
                                            .text,
                                        softWrap: true,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      ExpandableButton(
                                        // <-- Collapses when tapped on
                                        child: Icon(
                                          FontAwesomeIcons.chevronDown,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  expanded: Column(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(children: [
                                        Text('Description',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ]),
                                    ),
                                    Text(
                                      parse(widget.product.description)
                                          .documentElement!
                                          .text,
                                    ),
                                    ExpandableButton(
                                      // <-- Collapses when tapped on
                                      child: Icon(
                                        FontAwesomeIcons.chevronUp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ))),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AutoSizeText(
                            'Related Products',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    relatedProducts.length > 0
                        ? Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              // physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              itemBuilder: (context, index) {
                                var product = relatedProducts[index];
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ProductListTile(
                                    product: product,
                                  ),
                                );
                              },
                            ))
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            child: AutoSizeText('No related Products',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey)),
                          )
                  ]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  int? getVariationId() {
    if (widget.product.attributes.length > 0 &&
        widget.product.attributes.length ==
            attributesBool
                .where((element) => element == true)
                .toList()
                .length) {
      if (widget.product.attributes.length > 1) {
        if (colors != null) {
          int index = (size! * colors!.options.length) + (color!);
          return widget.product.variations[index];
        } else {
          int index = (size! * options!.options.length) + (variation!);
          return widget.product.variations[index];
        }
      } else {
        return widget.product.variations[variation!];
      }
    } else {
      return null;
    }
  }
}
