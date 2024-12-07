import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/pages/activity_logs/logs_screen.dart';
import 'package:admin_dashboard/src/pages/audio_background/audio_background.dart';
import 'package:admin_dashboard/src/pages/contacts/contacts_screen.dart';
import 'package:admin_dashboard/src/pages/faqs/faqs_screen.dart';
import 'package:admin_dashboard/src/pages/logout/logout.dart';
import 'package:admin_dashboard/src/pages/media/all_media.dart';
import 'package:admin_dashboard/src/pages/promotion/promotions_screen.dart';
import 'package:admin_dashboard/src/pages/queries/queries_screen.dart';
import 'package:admin_dashboard/src/pages/ranks/ranks_screen.dart';
import 'package:admin_dashboard/src/pages/users/all_users.dart';
import 'package:admin_dashboard/src/providers/user_provider.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
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
      'assets/png/media.png',
      // 'assets/png/premium.png',
      // 'assets/png/gift.png',
      'assets/png/gif.png',
      'assets/png/promotion.png',
      'assets/png/background.png',
      'assets/png/rank.png',
      'assets/png/logs.png',
      'assets/png/contact.png',
      'assets/png/faq.png',
      'assets/png/queries.png',
      // 'assets/png/setting.png',
      'assets/png/logout.png',
    ];

    List<String> drawerTitles = [
      'Users',
      'Media',
      // 'Premium',
      // 'Gifts',
      'GIF',
      'Promotions',
      'Audio Backgrounds',
      'Ranks',
      'Acitivity Logs',
      'FAQS',
      'Queries',
      'Admin Contact',
      // 'Setting',
      'Exit',
    ];

    switch (_selectedIndex) {
      case 0:
        setState(() {
          homepageCustomWidget = FutureBuilder<List<UserModel>>(
            future: FirestoreService().getLeaderBoardData(),
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
          homepageCustomWidget = const AllMedia();
        });
        break;

      // case 2:
      //   setState(() {
      //     homepageCustomWidget = const AllPremium();
      //   });
      //   break;

      // case 3:
      //   setState(() {
      //     homepageCustomWidget = const AllGifts();
      //   });
      //   break;

      case 2:
        setState(() {
          homepageCustomWidget = const PromotionsScreen();
        });
        break;
      case 3:
        setState(() {
          homepageCustomWidget = const PromotionsScreen();
        });
        break;

      case 4:
        setState(() {
          homepageCustomWidget = const AudioBackground();
        });
        break;

      case 5:
        setState(() {
          homepageCustomWidget = const RanksScreen();
        });
        break;

      case 6:
        setState(() {
          homepageCustomWidget = const LogsScreen();
        });
        break;

      case 7:
        setState(() {
          homepageCustomWidget = const FAQScreen();
        });
        break;
      case 8:
        setState(() {
          homepageCustomWidget = const QueriesScreen();
        });
        break;
      case 9:
        setState(() {
          homepageCustomWidget = const ContactScreen();
        });
        break;

      // case 6:
      //   setState(() {
      //     homepageCustomWidget = const SettingsScreen();
      //   });
      //   break;

      case 10:
        setState(() {
          homepageCustomWidget = const LogoutScreen();
        });
        break;

      default:
    }

    return Scaffold(
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
