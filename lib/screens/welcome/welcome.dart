import 'package:flutter/material.dart';
import '../../models/slide_model.dart';
import '../../styles.dart';
import '../../wigets/page_view_slide.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _isActiveIndex = 0;

  final List<Slide> slides = [
    Slide(
      svgUrl: 'assets/SVGs/slide1.svg',
      title: 'Welcome to Any Ride',
      subTitle: 'Your journey starts here!',
    ),
    Slide(
      svgUrl: 'assets/SVGs/slide2.svg',
      title: 'Earn with Rides',
      subTitle: 'Drive & earn on your schedule',
    ),
    Slide(
      svgUrl: 'assets/SVGs/slide3.svg',
      title: 'Let’s Go!',
      subTitle: 'Get started in a few steps',
    ),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  void _handlePageChange(int index) {
    setState(() {
      _isActiveIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        color: AppColor.backgroundColorDark,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: _handlePageChange,
                      itemCount: slides.length,
                      itemBuilder: (context, index) {
                        return PageViewSlide(slide: slides[index]);
                      },
                    ),
                    Positioned(
                      bottom: 80.0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(slides.length, (i) {
                          return Container(
                            margin: EdgeInsets.only(right: 10.0),
                            width: _isActiveIndex == i ? 15.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color:
                                  _isActiveIndex == i
                                      ? AppColor.buttonColor
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: _size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Colors.green,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
