import 'package:buty/Base/AllTranslation.dart';
import 'package:buty/Bolcs/signupBloc.dart';
import 'package:buty/UI/Auth/login.dart';
import 'package:buty/UI/CustomWidgets/CustomButton.dart';
import 'package:buty/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:buty/UI/CustomWidgets/ErrorDialog.dart';
import 'package:buty/UI/CustomWidgets/LoadingDialog.dart';
import 'package:buty/helpers/appEvent.dart';
import 'package:buty/helpers/appState.dart';
import 'package:buty/models/general_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'active_account.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showVisa = false;
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.contain,
              width: 150,
              height: 30,
            )),
        body: BlocListener<SignUpBloc, AppState>(
          bloc: signUpBloc,
          listener: (context, state) {
            var data = state.model as GeneralResponse;
            if (state is Loading) {
              showLoadingDialog(context);
            }
            if (state is ErrorLoading) {
              Navigator.of(context).pop();
              errorDialog(
                context: context,
                text: data.msg,
              );
              print("Dialoggg");
            }
            if (state is Done) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveAccount(),
                  ),
                  (Route<dynamic> route) => false);
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  rowItem(Icons.person, allTranslations.text("name")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.isEmpty) {
                        return "     ";
                      }
                    },
                    hint: allTranslations.text("write_name"),
                    value: (String val) {
                      signUpBloc.updateName(val);
                    },
                  ),
                  rowItem(Icons.phone, allTranslations.text("phone")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.length < 10) {
                        return "     ";
                      }
                    },
                    hint: "+966210025500",
                    inputType: TextInputType.phone,
                    value: (String val) {
                      signUpBloc.updateMobile(val);
                    },
                  ),
                  rowItem(Icons.mail, allTranslations.text("email")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.isEmpty) {
                        return "     ";
                      }
                    },
                    hint: "example@gmail.com",
                    inputType: TextInputType.emailAddress,
                    value: (String val) {
                      signUpBloc.updateEmail(val);
                    },
                  ),
                  rowItem(Icons.location_on, allTranslations.text("address")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.isEmpty) {
                        return "     ";
                      }
                    },
                    hint: allTranslations.text("write_address"),
                    value: (String val) {
                      signUpBloc.updateAddress(val);
                    },
                  ),
                  rowItem(Icons.lock, allTranslations.text("password")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.isEmpty) {
                        return "     ";
                      }
                    },
                    hint: "************",
                    secureText: true,
                    value: (String val) {
                      signUpBloc.updatePassword(val);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            allTranslations.text("add_depet_card"),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              allTranslations.text("default"),
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                      showVisa == false
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  showVisa = true;
                                });
                              },
                              child: Icon(Icons.keyboard_arrow_up))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  showVisa = false;
                                });
                              },
                              child: Icon(Icons.keyboard_arrow_down)),
                    ],
                  ),
                  showVisa == false ? Visa() : SizedBox(),
                  InkWell(
                    onTap: () {
                      if (!key.currentState.validate()) {
                        return;
                      } else {
                        signUpBloc.add(Click());
                      }
                    },
                    child: CustomButton(
                      text: allTranslations.text("register"),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Center(
                          child: Text(allTranslations.text("have_acc")))),
                ],
              ),
            ),
          ),
        ));
  }

  Widget Visa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text("card_number")),
        CustomTextField(
          hint: allTranslations.text("card_number"),
          inputType: TextInputType.number,
          value: (String val) {
            signUpBloc.updateNumber(val);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("expireDate"),
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: CustomTextField(
                      hint: "Exp Date",
                      inputType: TextInputType.number,
                      value: (String val) {
                        signUpBloc.updateExpDate(val);
                      },
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("CVV"),
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: CustomTextField(
                      hint: "CVV",
                      inputType: TextInputType.number,
                      value: (String val) {
                        signUpBloc.updateCvv(val);
                      },
                    )),
              ],
            ),
          ],
        ),
        Text(allTranslations.text("card_holder")),
        CustomTextField(
          hint: "User Name",
          value: (String val) {
            signUpBloc.updateHolderName(val);
          },
        ),
      ],
    );
  }

  Widget rowItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }
}
