import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/auth/services/auth.dart';
import 'package:ninecoin/features/auth/ui/signup_page.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/features/home/ui/home_view.dart';
import 'package:ninecoin/features/profile/services/profile_service.dart';
import 'package:ninecoin/model/auth/register/user_edit.dart';
import 'package:ninecoin/features/profile/services/profile_imagemodel.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:ninecoin/utilities/dialogs/update_details_dialog.dart';
import 'package:ninecoin/utilities/dialogs/updated_successful_dialog.dart';
import 'package:ninecoin/widgets/text_field_with_title.dart';
import '../../../utilities/dialogs/error_dialoge.dart';
import '../components/profile_circular_picture.dart';
import 'package:image_picker/image_picker.dart';
import '../services/get_image.dart';
import '../services/upload_image.dart';
import 'profile_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class EditProfilePage extends StatefulWidget {
  static Route<EditProfilePage> route() {
    return MaterialPageRoute(builder: (context) => EditProfilePage());
  }

  EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController username = TextEditingController();
  late TextEditingController contactnumber = TextEditingController();
  late TextEditingController address = TextEditingController();

  late String genderglobal;
  File? _image;
  final picker = ImagePicker();
  late String userid;
  bool showSpinner = false;
  final ValueNotifier<int> _notifier = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ImageGet profileImageModel = ImageGet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Edit Profile"),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: localUser(),
              builder: (_, AsyncSnapshot<Map?> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        height: 20,
                      ),
                      ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            imagePickerFromBottom(context);
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: CoinColors.black,
                                image: _image != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          _image!,
                                        ),
                                        fit: BoxFit.fill)
                                    : null),
                            child: _image == null
                                ? ProfileCircularPicture(
                                    imageUrl: 'null',
                                    onTap: () => imagePickerFromBottom(context),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      TextFieldWithTitle(
                        title: "Name",
                        hintText: "",
                        value: snapshot.data!['name'],
                        inputbar: username,
                      ),
                      TextFieldWithTitle(
                        title: "Contact Number",
                        hintText: "",
                        value: snapshot.data!['phonenumber'],
                        inputbar: contactnumber,
                      ),
                      _InputGender(
                        gender: snapshot.data!['gender'],
                      ),
                      TextFieldWithTitle(
                        title: "Address",
                        hintText: "",
                        value: snapshot.data!['address'],
                        inputbar: address,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            _InputCountry(),
                          ],
                        ),
                      ),
                      Container(
                        width: 380,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_image != null) {
                                Map<dynamic, dynamic>? data;
                                ImageGet? image;
                                String? imageUrl;
                                uploadImage(_image!.path).then((value) {
                                  setState(() async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    UserEdit user = UserEdit(
                                        name: username.text,
                                        phonenumber: contactnumber.text,
                                        address: address.text,
                                        gender: prefs.getString('gender'));

                                    userid = snapshot.data!['id'].toString();

                                    if (await showUpdateDetailsDialog(
                                        context)) {
                                      edituser(
                                              registerUser: user,
                                              userid: userid)
                                          .then((value) async {
                                        await showUpdatedSuccessfulDialog(
                                                context, value)
                                            .then((value) {
                                          localUser().then((value) {
                                            data = value;
                                            getUserImage().then((value) {
                                              image = value;
                                              imageUrl = image!.profilePic;

                                              Navigator.push(
                                                  context,
                                                  ProfileDetailsPage.route(
                                                      data, imageUrl));
                                            });
                                          });
                                        });
                                      }).catchError((err) async {
                                        await showErrorDialog(
                                            context, "Error", "$err");
                                      });
                                    }
                                  });
                                });
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                UserEdit user = UserEdit(
                                    name: username.text,
                                    phonenumber: contactnumber.text,
                                    address: address.text,
                                    gender: prefs.getString('gender'));

                                userid = snapshot.data!['id'].toString();

                                if (await showUpdateDetailsDialog(context)) {
                                  edituser(registerUser: user, userid: userid)
                                      .then((value) async {
                                    await showUpdatedSuccessfulDialog(
                                            context, value)
                                        .then((value) {
                                      /*   Navigator.push(context,
                                          ProfileDetailsPage.route());*/
                                    });
                                  }).catchError((err) async {
                                    await showErrorDialog(
                                        context, "Error", "$err");
                                  });
                                }
                              }
                            },
                            child: const Text("Update")),
                      )
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  imagePickerFromBottom(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: CoinColors.transparent,
      constraints: const BoxConstraints.expand(height: 68),
      context: context,
      builder: (contex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: const BoxDecoration(
              color: CoinColors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              )),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 42,
                height: 3.1,
                decoration: BoxDecoration(
                  color: CoinColors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await pickImageFromGallery();
                },
                child: Text("Choose from Photo Album",
                    style: CoinTextStyle.title2),
              ),
            ],
          ),
        );
      },
    );
  }

  String gender() {
    return 'test';
  }

  Future pickImageFromGallery() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('no image picked');
    }
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
    });
  }
}

class _InputCountry extends StatefulWidget {
  const _InputCountry({
    Key? key,
  }) : super(key: key);

  @override
  State<_InputCountry> createState() => _InputCountryState();
}

class _InputCountryState extends State<_InputCountry> {
  List<String> countries = ["Malaysia"];

  String? selectCountry = "Malaysia";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
            child: Text("Country", style: CoinTextStyle.orangeTitle3),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: CoinColors.black12,
                border: Border.all(color: CoinColors.black12),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: CoinColors.black12,
                borderRadius: BorderRadius.circular(12),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                ),
                hint: Text(
                  "Select Country",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
                isExpanded: true,
                iconSize: 36,
                value: selectCountry,
                underline: const SizedBox(),
                onChanged: (String? state) {
                  setState(() {
                    selectCountry = state;
                  });
                },
                items: List.generate(
                  countries.length,
                  (index) {
                    return DropdownMenuItem(
                        value: countries[index], child: Text(countries[index]));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputPostCode extends StatefulWidget {
  const _InputPostCode({
    Key? key,
  }) : super(key: key);

  @override
  State<_InputPostCode> createState() => _InputPostCodeState();
}

class _InputPostCodeState extends State<_InputPostCode> {
  final List<int> postalCodes = [1111, 2222, 33335, 555];
  int? selectedPostCode = 1111;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
            child: Text("Post Code", style: CoinTextStyle.orangeTitle3),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: CoinColors.black12,
                border: Border.all(color: CoinColors.black12),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: CoinColors.black12,
                borderRadius: BorderRadius.circular(12),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                ),
                hint: Text(
                  "Select Post Code",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
                isExpanded: true,
                iconSize: 36,
                value: selectedPostCode,
                underline: const SizedBox(),
                onChanged: (int? state) {
                  setState(() {
                    selectedPostCode = state;
                  });
                },
                items: List.generate(
                  postalCodes.length,
                  (index) {
                    return DropdownMenuItem(
                        value: postalCodes[index],
                        child: Text("${postalCodes[index]}"));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputState extends StatefulWidget {
  const _InputState({
    Key? key,
  }) : super(key: key);

  @override
  State<_InputState> createState() => _InputStateState();
}

class _InputStateState extends State<_InputState> {
  List<String> states = ["Sabah", "Sarawak	", "Selangor"];

  String? selectState = "Sabah";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
            child: Text("Post Code", style: CoinTextStyle.orangeTitle3),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: CoinColors.black12,
                border: Border.all(color: CoinColors.black12),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: CoinColors.black12,
                borderRadius: BorderRadius.circular(12),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                ),
                hint: Text(
                  "Select State",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
                isExpanded: true,
                iconSize: 36,
                value: selectState,
                underline: const SizedBox(),
                onChanged: (String? state) {
                  setState(() {
                    selectState = state;
                  });
                },
                items: List.generate(
                  states.length,
                  (index) {
                    return DropdownMenuItem(
                        value: states[index], child: Text(states[index]));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCity extends StatefulWidget {
  const _InputCity({
    Key? key,
  }) : super(key: key);

  @override
  State<_InputCity> createState() => _InputCityState();
}

class _InputCityState extends State<_InputCity> {
  List<String> cities = ["Paris", "London", "New York"];

  String? selectCity = "New York";
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
            child: Text("Post Code", style: CoinTextStyle.orangeTitle3),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: CoinColors.black12,
                border: Border.all(color: CoinColors.black12),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: CoinColors.black12,
                borderRadius: BorderRadius.circular(12),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                ),
                hint: Text(
                  "Select City",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
                isExpanded: true,
                iconSize: 36,
                value: selectCity,
                underline: const SizedBox(),
                onChanged: (String? state) {
                  setState(() {
                    selectCity = state;
                  });
                },
                items: List.generate(
                  cities.length,
                  (index) {
                    return DropdownMenuItem(
                        value: cities[index], child: Text(cities[index]));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputGender extends StatefulWidget {
  final String gender;
  const _InputGender({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  State<_InputGender> createState() => _InputGenderState();
}

class _InputGenderState extends State<_InputGender> {
  final List<String> genders = ["Male", "Female"];

  String? selectGender;
  String? gender;
  @override
  void initState() {
    // TODO: implement initState
    selectGender = widget.gender;
    getgender(selectGender!);
    super.initState();
  }

  void getgender(String getgender) async {
    SharedPreferences gender = await SharedPreferences.getInstance();
    gender.setString('gender', getgender);
  }

  @override
  Widget build(BuildContext context) {
    //selectGender = widget.gender;
    //gender = widget.gender;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 16, 0),
      child: Row(
        children: [
          Text("Gender", style: CoinTextStyle.orangeTitle3),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Radio(
                    activeColor: CoinColors.orange,
                    value: "Male",
                    groupValue: selectGender,
                    onChanged: (String? state) async {
                      SharedPreferences gender =
                          await SharedPreferences.getInstance();
                      gender.setString('gender', state!);
                      setState(() {
                        selectGender = state;
                      });
                    },
                  ),
                ),
                Text(
                  "Male",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Radio(
                    activeColor: CoinColors.orange,
                    focusColor: CoinColors.orange,
                    value: "Female",
                    groupValue: selectGender,
                    onChanged: (String? state) async {
                      SharedPreferences gender =
                          await SharedPreferences.getInstance();
                      gender.setString('gender', state!);
                      setState(() {
                        selectGender = state;
                      });
                    },
                  ),
                ),
                Text(
                  "Female",
                  style:
                      CoinTextStyle.title3.copyWith(color: CoinColors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
