import 'package:buty/Base/AllTranslation.dart';
import 'package:buty/Bolcs/mycards_bloc.dart';
import 'package:buty/UI/CustomWidgets/AppLoader.dart';
import 'package:buty/UI/CustomWidgets/CustomButton.dart';
import 'package:buty/UI/CustomWidgets/EmptyItem.dart';
import 'package:buty/UI/bottom_nav_bar/main_page.dart';
import 'package:buty/UI/component/criditCard_Single_item.dart';
import 'package:buty/helpers/appEvent.dart';
import 'package:buty/helpers/appState.dart';
import 'package:buty/models/AllPaymentMethodsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'add_new_card.dart';

class MyCards extends StatefulWidget {
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  @override
  void initState() {
    allCardsBloc.add(Hydrate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              index: 0,
                            )));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          centerTitle: true,
          title: Text(
            allTranslations.text("payment_methods"),
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            BlocListener<AllCardsBloc, AppState>(
              bloc: allCardsBloc,
              listener: (context, state) {},
              child: BlocBuilder(
                bloc: allCardsBloc,
                builder: (context, state) {
                  var data = state.model as PaymentMethodsResponse;
                  return data == null
                      ? AppLoader()
                      : data.paymentMethods.isEmpty
                          ? Center(
                              child: EmptyItem(
                              text: data.msg ?? "No Added Credit Cards",
                            ))
                          : AnimationLimiter(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.paymentMethods.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  data.paymentMethods[index]
                                                              .id ==
                                                          1
                                                      ? "assets/images/master_card.png"
                                                      : data.paymentMethods[index]
                                                                  .id ==
                                                              2
                                                          ? "assets/images/apple.png"
                                                          : "assets/images/pay_hand.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    allTranslations
                                                                .currentLanguage ==
                                                            "ar"
                                                        ? data
                                                            .paymentMethods[
                                                                index]
                                                            .nameAr
                                                        : data
                                                            .paymentMethods[
                                                                index]
                                                            .nameEn,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ListView.builder(
                                                itemCount: data
                                                    .paymentMethods[index]
                                                    .card
                                                    .length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, indexx) {
                                                  return CriditCardSingleItem(
                                                    card: data
                                                        .paymentMethods[index]
                                                        .card[indexx],
                                                  );
                                                }),
                                            data.paymentMethods[index].id == 1
                                                ? CustomButton(
                                                    onBtnPress: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddNewCard()));
                                                    },
                                                    text: allTranslations
                                                        .text("add_new_card"),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                },
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: Divider(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Image.asset(
            //             "assets/images/pay_hand.png",
            //             width: 25,
            //             height: 25,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 10),
            //             child: Text(
            //               "Apple Pay",
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Icon(
            //         Icons.check_circle,
            //         color: Theme.of(context).primaryColor,
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: Divider(),
            // ),
          ]),
    );
  }

  Widget address_item() {}
}
