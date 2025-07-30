import 'package:flutter/material.dart';
import 'package:the4m_app/screens/product_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';

class HomeBanner extends StatefulWidget {
  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = new PageController();
  int _currentPage = 0;

  final List<String> imagesBanner = [
    'lib/assets/images/banner_01.png',
    'lib/assets/images/banner_02.png',
    'lib/assets/images/banner_03.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imagesBanner.length,
            itemBuilder: (context, index) {
              return Image.asset(
                imagesBanner[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            top: 170,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LUXURY',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bodoni_Italic',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    'FASHION',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bodoni_Italic',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 3),
                  child: Text(
                    '& ACCESSORIES',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bodoni_Italic',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 40),
                    width: 240,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      child: GestureDetector(
                        onTap:
                            () => smoothPushReplacementLikePush(
                              context,
                              ProductScreen(),
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, color: Colors.white, size: 35),
                            SizedBox(width: 10),
                            Text(
                              'KHÁM PHÁ NGAY',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imagesBanner.length, (index) {
                    bool isActive = _currentPage == index;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      width: isActive ? 12 : 10,
                      height: isActive ? 12 : 10,
                      child: Transform.rotate(
                        angle: 0.785398,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
