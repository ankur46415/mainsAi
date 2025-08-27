import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/my_kitabai_view/logIn_flow/logIn_page_screen/User_Login_option.dart';
import '../../../common/colors.dart';

class IntroMainScreen extends StatefulWidget {
  const IntroMainScreen({super.key});

  @override
  State<IntroMainScreen> createState() => _IntroMainScreenState();
}

class _IntroMainScreenState extends State<IntroMainScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {"image": "assets/images/mains1.png", "title": "", "subtitle": ""},
    {"image": "assets/images/mains2.png", "title": "", "subtitle": ""},
    {"image": "assets/images/mains3.png", "title": "", "subtitle": ""},
  ];

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutQuint,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => User_Login_option(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double pageOffset = 0;
                    if (_controller.position.haveDimensions) {
                      pageOffset = _controller.page! - index;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(pages[index]["image"]),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset(
                            0.5 + (pageOffset * 0.3),
                            0.5,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Page Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  currentPage == index
                                      ? CustomColors.primaryColor
                                      : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow:
                                  currentPage == index
                                      ? [
                                        BoxShadow(
                                          color: CustomColors.primaryColor
                                              .withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skip Button
                          if (currentPage != pages.length - 1)
                            TextButton(
                              onPressed: () {
                                _controller.jumpToPage(pages.length - 1);
                              },
                              child: Text(
                                "Skip",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            SizedBox(width: 60),

                          // Next Button
                          GestureDetector(
                            onTap: _nextPage,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFC107),
                                    Color.fromARGB(255, 236, 87, 87),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  currentPage == pages.length - 1
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                  color: CustomColors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),

                          // Empty space for balance
                          SizedBox(width: 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
