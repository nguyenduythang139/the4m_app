import 'package:flutter/material.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/screens/contact_screen.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {},
                child: Image.asset('lib/assets/images/facebook.png', width: 20),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () => {},
                  child: Image.asset(
                    'lib/assets/images/instagram_5.png',
                    width: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: Image.asset('lib/assets/images/youtube.png', width: 20),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Devider(),
          const SizedBox(height: 30),
          Column(
            children: const [
              Text(
                'support@4M.design',
                style: TextStyle(color: Color(0xff333333)),
              ),
              Text('+ 84 369 7105', style: TextStyle(color: Color(0xff333333))),
              Text(
                '07:00 - 20:00 - Mỗi Ngày',
                style: TextStyle(color: Color(0xff333333)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Devider(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OurStoryScreen(),
                      ),
                    );
                  },
                  child: const Text('Thông tin'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactScreen(),
                      ),
                    );
                  },
                  child: const Text('Liên Lạc'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlogScreen(),
                      ),
                    );
                  },
                  child: const Text('Blog'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(child: Text('Copyright© 4M All Rights Reserved.')),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
