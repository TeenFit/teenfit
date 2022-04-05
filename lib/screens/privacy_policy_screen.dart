import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: _theme.secondaryHeaderColor,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: _appBarHieght * 0.35),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Container(
          height: _mediaQuery.size.height - _appBarHieght,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: _mediaQuery.size.height * 0.02,
                ),
                Container(
                  child: Image.asset(
                      'assets/images/teen_fit_logo_withtext_white.png'),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.02,
                ),
                Text(
                  '''W5rtc Inc. built the TeenFit app as an Ad Supported app. This SERVICE is provided by W5rtc Inc. at no cost and is intended for use as is. 

This page informs visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decides to use our Service.

If you choose to use our Service, you agree to the collection and use of information concerning this Policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at TeenFit unless otherwise defined in this Privacy Policy.
''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''Information Collection 
and Use''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to your email address, photo's, video's, etc. Teenfit is not liable for any damages caused during workouts. The information that we request will be retained by us and used as described in this privacy policy.
                  ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Log Data',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.
                ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Cookies',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.
This Service does not use these "cookies" explicitly. However, the app may use third-party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.
  ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Service Providers',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''Service Providers
We may employ third-party companies and individuals due to the following reasons:

1) To facilitate our Service;

2) To provide the Service on our behalf;

3) To perform Service-related services; or

4) To assist us in analyzing how our Service is used.

We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.
''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Security',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.
  ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Links to Other Sites',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''This Service contain's links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.
''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Children\'s Privacy',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''We do not knowingly collect personally identifiable information from children. We encourage all children under the age of 10 to never submit any personally identifiable information through the Application and/or Services. We encourage parents and legal guardians to monitor their children's Internet usage and to help enforce this Policy by instructing their children never to provide personally identifiable information through the Application and/or Services without their permission. If you have reason to believe that a child has provided personally identifiable information to us through the Application and/or Services, please get in touch with us. You must also be at least 16 years of age to consent to the processing of your personally identifiable information in your country (in some countries we may allow your parent or guardian to do so on your behalf).
 ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Changes to This Privacy Policy',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.
This Policy is effective as of 2021-12-01
''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  'Contact Us',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
                Text(
                  '''If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at teenfitness.fit@gmail.com.
 ''',
                  style: TextStyle(
                      fontSize: _mediaQuery.size.height * 0.03,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.025,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
