import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  final String? name;
  final String? username;
  final String? email;

  const profile({
    Key? key,
    required this.name,
    required this.email,
    required this.username,
  }) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Stack(alignment: Alignment.topCenter, children: [
            Column(children: [
              Image.asset('images/profilebg.jpg'),
              const SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  )
                ],
              ),
              Text(
                '${widget.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.mail,
                    size: 30,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  )
                ],
              ),
              Text(
                '${widget.email}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.man,
                    size: 30,
                  ),
                  Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  )
                ],
              ),
              Text(
                '${widget.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
            ]),
            const Padding(
              padding: EdgeInsets.only(top: 150),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/prifile.jpg'),
                radius: 90,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
