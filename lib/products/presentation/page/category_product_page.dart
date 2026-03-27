// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:outline_search_bar/outline_search_bar.dart';
// import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
// import 'package:ubuy/products/presentation%20/bloc/product_bloc.dart';

// import '../../../core/constant/constants.dart';
// import '../../../core/widgets/loading_widget.dart';
// import '../../../injection_container.dart';
// import '../../domain/entities/category.dart';
// import '../../domain/entities/product.dart';
// import '../widget/product_list_tile.dart';

// class CategoryProductPage extends StatefulWidget {
//   final Category category;
//   CategoryProductPage({required this.category});

//   @override
//   State<CategoryProductPage> createState() => _CategoryProductPageState();
// }

// class _CategoryProductPageState extends State<CategoryProductPage> {
//   final TextEditingController _controller = TextEditingController();
//   final ProductBloc _productBloc = serviceLocator<ProductBloc>();
//   List<String> filterItems = [
//     'Latest',
//     'Price: Low to High',
//     'Price: High to Low',
//   ];
//   String searchValue = '';

//   List<Product> products = [];
//   String selectedValue = '';
//   List<Product> searchedList = [];
//   List<Product> searchedFilteredList = [];

//   List<DropdownMenuItem<String>> filterList = [];
//   List<Product> lowToHighProducts = [];
//   List<Product> highToLowProducts = [];
//   List<Product> filteredList = [];
//   List<Product> searchLowToHighProducts = [];
//   List<Product> searchHighToLowProducts = [];

//   @override
//   void initState() {
//     _productBloc.add(GetCategoryProductsResquest(id: widget.category.id));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _productBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//           Expanded(
//             child: OutlineSearchBar(
//               margin: EdgeInsets.all(8),
//               // padding: EdgeInsets.all(8),
//               hintText: 'Search....',
//               hintStyle: TextStyle(),
//               textEditingController: _controller,
//               onClearButtonPressed: (v) {
//                 setState(() {
//                   searchedList.clear();
//                   searchValue = '';
//                 });
//               },
//               onSearchButtonPressed: (value) {
//                 List<String> text = [
//                   'imac',
//                   '14',
//                 ];
//                 setState(() {
//                   searchedList.clear();

//                   print(text.contains(value));

//                   for (var element in products) {
//                     if (element.name
//                         .split(' ')
//                         .map((e) => e.toLowerCase())
//                         .toList()
//                         .any(
//                             (string) => string.contains(value.toLowerCase()))) {
//                       searchedList.add(element);
//                     }
//                   }
//                   searchedFilteredList = searchedList;
//                   searchLowToHighProducts = List<Product>.from(searchedList);
//                   searchHighToLowProducts = List<Product>.from(searchedList);
//                   searchLowToHighProducts.sort((a, b) =>
//                       int.parse(a.price).compareTo(int.parse(b.price)));
//                   searchHighToLowProducts.sort((a, b) =>
//                       int.parse(b.price).compareTo(int.parse(a.price)));
//                   searchValue = value;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton2(
//                 customButton: Icon(
//                   FontAwesomeIcons.filter,
//                   color: Colors.white,
//                 ),
//                 customItemsHeight: 4,
//                 items: filterItems
//                     .map((item) => DropdownMenuItem<String>(
//                           value: item,
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               item,
//                               style: TextStyle(
//                                 color: selectedValue == item
//                                     ? Constant.color1
//                                     : Colors.black,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedValue = value as String;
//                     print(filterItems.indexOf(value));
//                     if (filterItems.indexOf(value) == 0) {
//                       searchedFilteredList = searchedList;
//                       filteredList = products;
//                     } else if (filterItems.indexOf(value) == 1) {
//                       filteredList = lowToHighProducts;
//                       searchedFilteredList = searchLowToHighProducts;
//                     } else if (filterItems.indexOf(value) == 2) {
//                       filteredList = highToLowProducts;
//                       searchedFilteredList = searchHighToLowProducts;
//                     }
//                   });
//                 },
//                 itemHeight: 48,
//                 itemPadding: const EdgeInsets.only(left: 16, right: 16),
//                 dropdownWidth: 160,
//                 dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
//                 dropdownDecoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4),
//                   color: Colors.white,
//                 ),
//                 dropdownElevation: 8,
//                 offset: const Offset(0, 8),
//               ),
//             ),
//           )
//           // IconButton(
//           //   onPressed: () {},
//           //   icon: Icon(
//           //     FontAwesomeIcons.filter,
//           //     color: Colors.white,
//           //   ),
//           // ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => _productBloc,
//         child: BlocListener<ProductBloc, ProductState>(
//           bloc: _productBloc,
//           listener: (context, state) {
//             if (state is CategoryProductsLoaded) {
//               setState(() {
//                 selectedValue = filterItems[0];
//                 products = state.products;
//                 filteredList = products;
//                 filterItems.forEach((item) {
//                   filterList.addAll([
//                     DropdownMenuItem<String>(
//                       value: item,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(
//                           item,
//                           style: TextStyle(
//                             color: selectedValue == item
//                                 ? Constant.color1
//                                 : Colors.black,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     //If it's last item, we will not add Divider after it.
//                     if (item != filterItems.last)
//                       const DropdownMenuItem<String>(
//                         enabled: false,
//                         child: Divider(),
//                       ),
//                   ]);
//                 });
//                 lowToHighProducts = List<Product>.from(products);
//                 highToLowProducts = List<Product>.from(products);
//                 lowToHighProducts.sort(
//                     (a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
//                 highToLowProducts.sort(
//                     (a, b) => int.parse(b.price).compareTo(int.parse(a.price)));
//               });
//             }
//           },
//           child: BlocBuilder<ProductBloc, ProductState>(
//             bloc: _productBloc,
//             builder: (context, state) {
//               if (state is CategoryProductsLoaded) {
//                 return searchValue == ''
//                     ? AlignedGridView.count(
//                         crossAxisCount: 2,
//                         // mainAxisSpacing: 4,
//                         // crossAxisSpacing: 4,
//                         itemCount: filteredList.length,
//                         itemBuilder: (context, index) {
//                           Product product = filteredList[index];
//                           return ProductListTile(
//                             product: product,
//                           );
//                         },
//                       )
//                     : AlignedGridView.count(
//                         crossAxisCount: 2,
//                         // mainAxisSpacing: 4,
//                         // crossAxisSpacing: 4,
//                         itemCount: searchedFilteredList.length,
//                         itemBuilder: (context, index) {
//                           Product product = searchedFilteredList[index];
//                           return ProductListTile(
//                             product: product,
//                           );
//                         },
//                       );
//               } else if (state is ProductError) {
//                 return Center(
//                   child: Text('Server Exception'),
//                 );
//               } else {
//                 return LoadingWidget();
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Constant.color1,
//         child: Icon(
//           Icons.shopping_cart,
//           color: Colors.white,
//           size: 20,
//         ),
//         onPressed: () {
//           // showDialog(
//           //   context: context,
//           //   builder: (BuildContext context) {
//           //     return FavouriteTeam();
//           //   },
//           // );
//         },
//       ),
//     );
//   }
// }
