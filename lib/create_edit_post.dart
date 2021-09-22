import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'Helpers/flush_bar_helper.dart';
import 'Helpers/progres_dialog_helper.dart';
import 'constants.dart';

class CreateEditPost extends StatefulWidget {
  final editPost;
  final docID;
  const CreateEditPost({Key? key, this.editPost, this.docID}) : super(key: key);

  @override
  _CreateEditPostState createState() => _CreateEditPostState();
}

class _CreateEditPostState extends State<CreateEditPost> {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');


  final _formKeyCreateEditPost = GlobalKey <FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  late String _title;
  late String _description;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Widget _titleForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      cursorColor: kPrimaryColor,
      controller: descController,
      onSaved: (value){
        setState(() {
          _title = value!;
        });
      },
      validator: (value) => (value!.isEmpty? "Enter title" : null),
    );
  }

  Widget _descriptionForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      cursorColor: kPrimaryColor,
      controller: titleController,
      onSaved: (value){
        setState(() {
          _description = value!;
        });
      },
      validator: (value) => (value!.isEmpty? "Enter description" : null),
    );
  }

  _proceed() async {
    if(_formKeyCreateEditPost.currentState!.validate()){
      _formKeyCreateEditPost.currentState!.save();
      var connectivityResult = await Connectivity().checkConnectivity();
      if (!(connectivityResult == ConnectivityResult.none)) {
        ProgressDialogHelper().showProgressDialog(context, widget.editPost == null ? "Creating post" : "Saving Changes");
        widget.editPost == null ? _createPost() : _savePost();
      }else FlushBarHelper(context).showFlushBar("No Internet Connection");
    }
  }

  _createPost(){
    posts.add({
      'title' : titleController.text,
      'description': descController.text,
    }).then((value) {
      ProgressDialogHelper().hideProgressDialog(context);
      Navigator.pop(context);
      FlushBarHelper(context).showFlushBar("Post created successfully", color: Colors.green);
    }).catchError((error) {
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar("Opps! Something went wrong, please retry", color: Colors.red);
    });
  }

  _savePost(){
    posts.doc(widget.docID).update(
      {
        'title' : titleController.text,
        'description': descController.text,
      },
    ).then((value) {
      ProgressDialogHelper().hideProgressDialog(context);
      Navigator.pop(context);
      FlushBarHelper(context).showFlushBar("Changes saved successfully", color: Colors.green);
    }).catchError((error) {
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar("Opps! Something went wrong, please retry", color: Colors.red);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: kPrimaryColor,), onPressed: (){
        Navigator.pop(context);
      },),),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,10,20,30),
          child: Form(
            key: _formKeyCreateEditPost,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.editPost == null ? "Create Post" : "Edit Post", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                SizedBox(height: 36,),
                Text("Title", style: TextStyle(color: Colors.black, fontSize: 14),),
                SizedBox(height: 5,),
                _titleForm(),
                SizedBox(height: 24,),
                Text("Description", style: TextStyle(color: Colors.black, fontSize: 14),),
                SizedBox(height: 5,),
                _descriptionForm(),
                SizedBox(height: 48,),
                Container(height: 48, width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0, onPrimary: Colors.white),
                      child: Text(widget.editPost == null ? "Create Post" : "Save",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                      onPressed: (){
                        _proceed();
                      },
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
