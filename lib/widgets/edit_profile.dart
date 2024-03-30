import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/api/api_key.dart';
import 'package:thedogs/models/user_interface.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return Consumer<UserInterface>(
      builder: (context, ui, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Chỉnh sửa thông tin cá nhân',
              style:
                  TextStyle(color: ui.isDarkMode ? Colors.white : Colors.black),
            ),
            backgroundColor:
                ui.isDarkMode ? const Color(0xff8b8b8b) : Colors.white,
            iconTheme: IconThemeData(
                color: ui.isDarkMode ? Colors.white : Colors.black),
          ),
          body: Container(
              height: double.infinity,
              color: ui.isDarkMode ? const Color(0xff8b8b8b) : Colors.white,
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _auth.currentUser!.photoURL != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: ui.isDarkMode
                                        ? Colors.white
                                        : const Color(0xff8b8b8b),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    _auth.currentUser!.photoURL!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 120,
                                color: ui.isDarkMode
                                    ? Colors.white
                                    : Colors.grey[300],
                              ),
                        Positioned(
                          right: -10,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt_outlined),
                            color: Colors.white,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[300]),
                            ),
                            onPressed: () async {
                              // Navigator.of(context).pushNamed('/edit_profile');
                              final storage = FirebaseStorage.instanceFor(
                                  bucket: linkFirebase);
                              final ImagePicker _picker = ImagePicker();
                              final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              //   print(pickedFile!.path);
                              if (pickedFile != null) {
                                final File file = File(pickedFile.path);
                                print('222, ${file.path}');
                                final Reference ref = storage.ref().child(
                                    'users/${_auth.currentUser!.uid}.png');
                                await ref.putFile(file);
                                final String url = await ref.getDownloadURL();
                                _auth.currentUser!.updatePhotoURL(url);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                          color: ui.isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        // labelText: 'Tên',
                        hintText: _auth.currentUser!.displayName == ''
                            ? 'Nhập tên của bạn'
                            : '${_auth.currentUser!.displayName}',
                        hintStyle: TextStyle(
                            color: ui.isDarkMode ? Colors.white : Colors.black),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: ui.isDarkMode ? Colors.white : Colors.black,
                          width: 1.0,
                        )),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                          color: ui.isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                          // labelText: 'Email',
                          hintText: '${_auth.currentUser!.email}',
                          hintStyle: TextStyle(
                              color:
                                  ui.isDarkMode ? Colors.white : Colors.black),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  ui.isDarkMode ? Colors.white : Colors.black,
                              width: 1.0,
                            ),
                          )),
                      keyboardType: TextInputType.emailAddress,
                      // autofillHints: [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(
                          color: ui.isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        //   labelText: 'Mật khẩu',
                        hintText: 'Nhập mật khẩu hiện tại',
                        hintStyle: TextStyle(
                            color: ui.isDarkMode ? Colors.white : Colors.black),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: ui.isDarkMode ? Colors.white : Colors.black,
                          width: 1.0,
                        )),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      // autofillHints: [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
                      obscureText: !_isPasswordVisible,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _newPasswordController,
                      style: TextStyle(
                          color: ui.isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        //   labelText: 'Mật khẩu mới',
                        hintText: 'Nhập mật khẩu mới',
                        hintStyle: TextStyle(
                            color: ui.isDarkMode ? Colors.white : Colors.black),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: ui.isDarkMode ? Colors.white : Colors.black,
                          width: 1.0,
                        )),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      // autofillHints: [AutofillHints.newPassword],
                      // autofocus: true,
                      textInputAction: TextInputAction.done,
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text != '' ||
                            _emailController.text != '' ||
                            _passwordController.text != '') {
                          if (_nameController.text !=
                                  _auth.currentUser!.displayName &&
                              _nameController.text != '') {
                            _auth.currentUser!
                                .updateDisplayName(_nameController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cập nhật tên thành công'),
                              ),
                            );
                          }
                          //   _auth.currentUser!.updateDisplayName(_nameController.text);
                          if (_emailController.text != '') {
                            _auth.currentUser!
                                .verifyBeforeUpdateEmail(_emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cập nhật email thành công'),
                              ),
                            );
                          }
                          if (_passwordController.text != '') {
                            _auth.currentUser!
                                .reauthenticateWithCredential(
                              EmailAuthProvider.credential(
                                email: _auth.currentUser!.email!,
                                password: _passwordController.text,
                              ),
                            )
                                .then((authResult) {
                              _auth.currentUser!
                                  .updatePassword(_newPasswordController.text)
                                  .then((_) {
                                _passwordController.clear();
                                _newPasswordController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Cập nhật mật khẩu thành công'),
                                  ),
                                );
                              }).catchError((error) {
                                _passwordController.clear();
                                _newPasswordController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lỗi khi cập nhật mật khẩu'),
                                  ),
                                );
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mật khẩu không chính xác'),
                                ),
                              );
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Không có thay đổi'),
                            ),
                          );
                        }
                        //   Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xff5cb85c),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
