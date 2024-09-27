import 'package:admin_dashboard/src/gifts/all_gifts.dart';
import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/pages/logout/logout.dart';
import 'package:admin_dashboard/src/pages/premium/all_premium.dart';
import 'package:admin_dashboard/src/pages/users/all_users.dart';
import 'package:admin_dashboard/src/providers/user_provider.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:admin_dashboard/src/pages/settings/setings.dart';
import 'package:admin_dashboard/src/utility/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isExpanded = false;
  int? _selectedIndex;
  double textSize = 40.0;
  String? floatingActionButtonTooltipString;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Widget? homepageCustomWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user != null) {
      fetchEveryUser(userProvider);
    }
  }

  Future<void> fetchEveryUser(UserProvider userProvider) async {
    await userProvider.fetchAllUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    homepageCustomWidget = SizedBox(
      height: height,
      width: width * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: width * 0.2,
            width: width * 0.2,
            child: Image.asset(
              "assets/png/logo.png",
              filterQuality: FilterQuality.high,
            ),
          ),
          SizedBox(height: height * 0.05),
          Text(
            "Welcome to the ElTalk Admin Dashboard",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: width * 0.03, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    List<String> drawerImages = [
      'assets/png/user.png',
      'assets/png/premium.png',
      'assets/png/gift.png',
      'assets/png/setting.png',
      'assets/png/logout.png',
    ];

    List<String> drawerTitles = [
      'All Users',
      'All Premium',
      'All Gifts',
      'Setting',
      'Exit',
    ];

    switch (_selectedIndex) {
      case 0:
        setState(() {
          homepageCustomWidget = FutureBuilder<List<UserModel>>(
            future: FirestoreServices().getLeaderBoardData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Users found.'));
              } else {
                return AllUsers(
                  users: snapshot.data ?? [],
                );
              }
            },
          );
        });
        break;

      case 1:
        setState(() {
          homepageCustomWidget = const AllPremium();
        });
        break;

      case 2:
        setState(() {
          homepageCustomWidget = const AllGifts();
        });
        break;

      case 3:
        setState(() {
          homepageCustomWidget = const SettingsScreen();
        });
        break;

      case 4:
        setState(() {
          homepageCustomWidget = const LogoutScreen();
        });
        break;

      default:
    }

    return Scaffold(
      // floatingActionButton: widget.user == 'admin' &&
      //         (_selectedIndex == 1 || _selectedIndex == 2)
      //     ? IconButton(
      //         onPressed: () async {
      //           if (_selectedIndex == 1) {
      //             bool isStudentAdded = await showAddStudentDialog(context, "");
      //             // print("Is student added: $isStudentAdded");
      //             if (isStudentAdded) {
      //               refreshStudentList();
      //             }
      //           }
      //           if (_selectedIndex == 2) {
      //             bool isTeacherAdded = await showAddTeacherDialog(context);
      //             // print("Is teacher added: $isTeacherAdded");
      //             if (isTeacherAdded) {
      //               refreshTeacherList();
      //             }
      //           }
      //         },
      //         icon: const Icon(
      //           Icons.add,
      //           color: Colors.white,
      //         ),
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Theme.of(context).primaryColor,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //           ),
      //         ),
      //         tooltip: floatingActionButtonTooltipString,
      //       )
      //     : Container(),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            width: isExpanded ? 200 : 70,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: CustomColors.greyColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (!isExpanded) const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: isExpanded
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        height: MediaQuery.sizeOf(context).height * 0.009,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      const Spacer(),
                      // if (isExpanded)
                      //   Expanded(
                      //     child: IconButton(
                      //       onPressed: () {
                      //         themeNotifier.toggleTheme();
                      //       },
                      //       icon: Icon(
                      //         themeNotifier.isDarkMode
                      //             ? Icons.light_mode
                      //             : Icons.dark_mode,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: isExpanded ? 0.0 : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    height: isExpanded ? 0.0 : 50.0,
                    width: isExpanded ? 0.0 : 50.0,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                        child: Image.asset(
                          "assets/png/logo.png",
                          height: width * 0.03,
                          width: width * 0.03,
                        ),
                        // child: Text(
                        //   'IE',
                        // ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: drawerImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: isExpanded
                            ? () {
                                setState(() {
                                  _selectedIndex = index;
                                  textSize = 60.0;
                                });
                              }
                            : () {
                                setState(() {
                                  isExpanded = true;
                                  _selectedIndex = index;
                                  textSize = 60.0;
                                });
                              },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0 * 2, left: 10.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? _selectedIndex == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: width * 0.018,
                                    width: width * 0.018,
                                    child: Image.asset(
                                      drawerImages[index],
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  if (isExpanded)
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        opacity: isExpanded ? 1.0 : 0.0,
                                        child: AnimatedDefaultTextStyle(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: GoogleFonts.poppins(
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black54,
                                            fontSize:
                                                isExpanded ? width * 0.012 : 0,
                                          ),
                                          child: Text(
                                            drawerTitles[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  alignment:
                      isExpanded ? Alignment.bottomRight : Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                              textSize = 45.0;
                            });
                          },
                          icon: Icon(
                            isExpanded
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOut,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                              child: _selectedIndex == null
                                  ? Container()
                                  : Text(
                                      drawerTitles[_selectedIndex!],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      // (_selectedIndex == 1 || _selectedIndex == 2)
                      //     ? Expanded(
                      //         flex: 1,
                      //         child: Row(
                      //           children: [
                      //             const Text(
                      //               "Total: ",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             // ValueListenableBuilder(
                      //             //     valueListenable: _selectedIndex == 1
                      //             //         ? studentLength
                      //             //         : teacherLength,
                      //             //     builder: (context, value, child) {
                      //             //       return Text(
                      //             //         value.toString(),
                      //             //       );
                      //             //     })
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: homepageCustomWidget,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
