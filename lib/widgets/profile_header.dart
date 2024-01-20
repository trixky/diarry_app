import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {super.key,
      required this.user,
      required this.signOut,
      required this.addNote});

  final User user;
  final void Function() signOut;
  final void Function(BuildContext context) addNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    const SizedBox(
                      height: 70,
                      width: 70,
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeAlign: -10,
                      ),
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(user.photoURL!),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(width: 8), // const SizedBox(width: 16
                  SizedBox(
                    width: 150,
                    child: Text(
                      user.displayName != null && user.displayName!.isNotEmpty
                          ? user.displayName!
                          : "No name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // const SizedBox(width: 16
              SizedBox(
                width: 200,
                child: Text(
                  user.email!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Column(
            children: [
              MaterialButton(
                elevation: 0,
                color: Colors.grey[400],
                onPressed: signOut,
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                shape: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(
                        width: 60,
                        child: Text(
                          "Sign out",
                          textAlign: TextAlign.right,
                        )),
                  ],
                ),
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.grey[400],
                onPressed: () => addNote(context),
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                shape: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(
                        width: 60,
                        child: Text(
                          "Add note",
                          textAlign: TextAlign.right,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
