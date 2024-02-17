import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Container(
              height: 98,
              width: 350,
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2, color: const Color(0xffCBC0AF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 23,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Row(
                  children: [
                    //SizedBox(width: 20,),
                    Container(
                      height: 60,
                      width: 60,
                      //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                          color: const Color(0xffC4C4C4),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    //SizedBox(width: 20,),
                    const Spacer(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nguyen Huu Hung',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'dannamdinh49@gmail.com',
                          style: TextStyle(
                              color: Color(0xffB6B6B6),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    //SizedBox(width: 20,),
                    const Spacer(),
                    Image.asset('assets/Vector.png'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _buiditeam(context),
            const SizedBox(
              height: 10,
            ),
            _buiditeam(context),
            const SizedBox(
              height: 10,
            ),
            _buiditeam(context),
            const SizedBox(
              height: 10,
            ),
            _buiditeam(context),
          ],
        ),
      )),
    );
  }

  Widget _buiditeam(BuildContext context) {
    return Container(
      height: 98,
      width: 350,
      decoration: BoxDecoration(
        //color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: const Color(0xffCBC0AF)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: Row(
          children: [
            //SizedBox(width: 20,),

            Image.asset('assets/Group.png'),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'My Daily',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
