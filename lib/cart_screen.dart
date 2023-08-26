import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/cart_provider.dart';
import 'package:flutter_shopping_cart/db_helper.dart';
import 'package:flutter_shopping_cart/show_total_price.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'cart.model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Product'),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              badgeAnimation: const badges.BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
              showBadge: true,
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image(
                                          height: height * 0.17,
                                          width: width * 0.20,
                                          image: NetworkImage(snapshot
                                              .data![index].image
                                              .toString()),
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        .productName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        dbHelper!.delete(snapshot
                                                            .data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .finalPrice
                                                                .toString()));
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                ],
                                              ),
                                              Text(
                                                "${snapshot.data![index].unitTag.toString()} ${r"$" + snapshot.data![index].finalPrice.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: height * 0.02),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    height: height * 0.05,
                                                    width: width * 0.3,
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .deepPurple.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              int quantity = snapshot.data![index].quantity!;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity--;
                                                              int? newPrice =  price * quantity;

                                                             if(quantity >0){
                                                               dbHelper!.updateQuantity(Cart(
                                                                   id: snapshot.data![index].id!,
                                                                   productName: snapshot.data![index].productName.toString(),
                                                                   image: snapshot.data![index].image.toString(),
                                                                   productId: snapshot.data![index].id.toString(),
                                                                   finalPrice: newPrice,
                                                                   initialPrice: snapshot.data![index].initialPrice!,
                                                                   unitTag: snapshot.data![index].unitTag.toString(),
                                                                   quantity: quantity),
                                                               ).then((value){
                                                                 newPrice = 0;
                                                                 quantity = 0;
                                                                 cart.removeTotalPrice((double.parse(snapshot.data![index].initialPrice.toString())),);
                                                               }).onError((error, stackTrace){
                                                                 print(error.toString());
                                                               });
                                                             }
                                                            },
                                                            icon: const Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Center(
                                                          child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .quantity
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price = snapshot.data![index].initialPrice!;

                                                            quantity++;
                                                            int? newPrice =  price * quantity;
                                                            dbHelper!.updateQuantity(Cart(
                                                                id: snapshot.data![index].id!,
                                                                productName: snapshot.data![index].productName.toString(),
                                                                image: snapshot.data![index].image.toString(),
                                                                productId: snapshot.data![index].id.toString(),
                                                                finalPrice: newPrice,
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                quantity: quantity),
                                                            ).then((value){
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                            }).onError((error, stackTrace){
                                                              print(error.toString());
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }));
                } else {
                  return const Text("");
                }
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                  ? false
                  : true,
              child: Column(
                children: [
                  ShowingTotalPrice(
                      title: 'Sub Total',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                  ShowingTotalPrice(
                      title: 'Discount Price 20%',
                      value: r'$' + (value.getTotalPrice() * 0.20).toStringAsFixed(2)),
                  ShowingTotalPrice(
                      title: 'Total',
                      value: r'$' + (value.getTotalPrice() -  (value.getTotalPrice() * 0.20)).toStringAsFixed(2)),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
