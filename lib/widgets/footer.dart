import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/devider.dart';

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
                margin: EdgeInsets.symmetric(horizontal: 30),
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
          SizedBox(height: 30),
          Devider(),
          SizedBox(height: 30),
          Column(
            children: [
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
          SizedBox(height: 30),
          Devider(),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: () => {}, child: Text('Thông Tin')),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () => {},
                  child: Text('Liên Lạc'),
                ),
              ),
              GestureDetector(onTap: () => {}, child: Text('Blog')),
            ],
          ),
          SizedBox(height: 20),
          Center(child: Text('Copyright© 4M All Rights Reserved.')),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
