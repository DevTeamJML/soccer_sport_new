import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
import 'package:soccer_sport/products/presentation/page/add_to_cart_page.dart';

import '../../../core/constant/constants.dart';
import '../../domain/entities/product.dart';
import '../widget/product_list_tile.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _controller = TextEditingController();

  List<String> filterItems = [
    'Latest',
    'Price: Low to High',
    'Price: High to Low',
  ];
  String searchValue = '';

  List<Product> products = [];
  String selectedValue = '';
  List<Product> searchedList = [];
  List<Product> searchedFilteredList = [];

  List<DropdownMenuItem<String>> filterList = [];
  List<Product> lowToHighProducts = [];
  List<Product> highToLowProducts = [];
  List<Product> filteredList = [];
  List<Product> searchLowToHighProducts = [];
  List<Product> searchHighToLowProducts = [];
  final ProductBloc _productBloc = serviceLocator<ProductBloc>();

  void sortPriceList() {}

  @override
  void initState() {
    selectedValue = filterItems[0];
    _productBloc.add(GetAllProductsRequest());
    filterItems.forEach((item) {
      filterList.addAll([
        DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item,
              style: TextStyle(
                color: selectedValue == item ? Constant.color1 : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
        //If it's last item, we will not add Divider after it.
        if (item != filterItems.last)
          const DropdownMenuItem<String>(
            enabled: false,
            child: Divider(),
          ),
      ]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: OutlineSearchBar(
              margin: EdgeInsets.all(8),
              // padding: EdgeInsets.all(8),
              hintText: 'Search....',
              hintStyle: TextStyle(),
              textEditingController: _controller,
              onClearButtonPressed: (v) {
                setState(() {
                  searchedList.clear();
                  searchValue = '';
                });
              },
              onSearchButtonPressed: (value) {
                List<String> text = [
                  'imac',
                  '14',
                ];
                setState(() {
                  searchedList.clear();

                  for (var element in products) {
                    if (element.name
                        .split(' ')
                        .map((e) => e.toLowerCase())
                        .toList()
                        .any(
                            (string) => string.contains(value.toLowerCase()))) {
                      searchedList.add(element);
                    }
                  }
                  searchedFilteredList = searchedList;
                  searchLowToHighProducts = List<Product>.from(searchedList);
                  searchHighToLowProducts = List<Product>.from(searchedList);
                  sortPriceList();
                  searchLowToHighProducts.sort((a, b) =>
                      int.parse(a.price).compareTo(int.parse(b.price)));
                  searchHighToLowProducts.sort((a, b) =>
                      int.parse(b.price).compareTo(int.parse(a.price)));
                  searchValue = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: Icon(
                  FontAwesomeIcons.filter,
                  color: Colors.white,
                ),
                menuItemStyleData: MenuItemStyleData(
                  // customHeights: [48, 48, 48],
                  height: 48,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
                // customItemsHeight: 4,
                dropdownStyleData: DropdownStyleData(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  elevation: 8,
                  offset: const Offset(0, 8),
                ),
                items: filterItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: selectedValue == item
                                    ? Constant.color1
                                    : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    if (filterItems.indexOf(value) == 0) {
                      searchedFilteredList = searchedList;
                      filteredList = products;
                    } else if (filterItems.indexOf(value) == 1) {
                      filteredList = lowToHighProducts;
                      searchedFilteredList = searchLowToHighProducts;
                    } else if (filterItems.indexOf(value) == 2) {
                      filteredList = highToLowProducts;
                      searchedFilteredList = searchHighToLowProducts;
                    }
                  });
                },
                // itemHeight: 48,
                // itemPadding: const EdgeInsets.only(left: 16, right: 16),
                // dropdownWidth: 160,
                // dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                // dropdownDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(4),
                //   color: Colors.white,
                // ),
                // dropdownElevation: 8,
                // offset: const Offset(0, 8),
              ),
            ),
          )
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     FontAwesomeIcons.filter,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      body: BlocProvider<ProductBloc>(
        create: (context) => _productBloc,
        child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is AllProductsLoaded) {
              setState(() {
                products = state.products;
                Constant.allProduct = products;
                filteredList = state.products;
                lowToHighProducts = List<Product>.from(products);
                highToLowProducts = List<Product>.from(products);
                lowToHighProducts.sort(
                    (a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
                highToLowProducts.sort(
                    (a, b) => int.parse(b.price).compareTo(int.parse(a.price)));
              });
            }
          },
          child: searchValue == ''
              ? AlignedGridView.count(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 4,
                  // crossAxisSpacing: 4,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Product product = filteredList[index];
                    return ProductListTile(
                      product: product,
                    );
                  },
                )
              : AlignedGridView.count(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 4,
                  // crossAxisSpacing: 4,
                  itemCount: searchedFilteredList.length,
                  itemBuilder: (context, index) {
                    Product product = searchedFilteredList[index];
                    return ProductListTile(
                      product: product,
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constant.color1,
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          if (Constant.auth != null) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddToCartPage(),
            ));
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
      ),
    );
  }
}
