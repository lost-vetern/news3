import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class appdrawr extends StatefulWidget{
  appdrawr_state createState()=>appdrawr_state();
}
class appdrawr_state extends State<appdrawr>{
  var name,email,subject,phone,review;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ///header
          DrawerHeader(child: Image.asset('assets/icon.png',),decoration:BoxDecoration(color: Colors.grey),padding: EdgeInsets.only(top: 30),),
          ///////////signin // signup
          ListTile(title: Text((auth.login)?auth.name:'Sign In / Sign Up',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
            onTap: (){auth.login?{}:Navigator.pushNamed(context, '/login');},),
          ///////////Contact us
          ListTile(title: Text('Contact Us',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            onTap: (){showDialog(context: context,
                builder: (context)=>AlertDialog(
                  title: Text('Contact us',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Container(
                    child: ListView(//mainAxisSize: MainAxisSize.min,
                      shrinkWrap: true,
                      children: <Widget>[
                        /////////////////////name
                        TextField(onChanged: (input){name=input;},
                          decoration: InputDecoration(
                              hintText: "Name", labelText: "Name", labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,20.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),),
                        SizedBox(height: 10),
                        /////////////////////email
                        TextField(onChanged: (input){email=input;},
                          decoration: InputDecoration(
                              hintText: "Email", labelText: "Email", labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,20.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),),
                        SizedBox(height: 10),
                        /////////////////////name
                        TextField(onChanged: (input){subject=input;},
                          decoration: InputDecoration(
                              hintText: "Subject", labelText: "Subject", labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,20.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),),
                        SizedBox(height: 10),
                        /////////////////////name
                        TextField(onChanged: (input){phone=input;},
                          decoration: InputDecoration(
                              hintText: "Phone", labelText: "Phone", labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,20.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),),
                        SizedBox(height: 10),
                        /////////review
                        TextField(onChanged: (input){review=input;},
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              hintText: "Review", labelText: "Review", labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,20.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),),
                        SizedBox(height: 20),
                        ///////////////Submit
                        Material(borderRadius: BorderRadius.circular(20.0), shadowColor: Colors.blue, color: Color(0xff4268D3), elevation: 7.0,
                          child: MaterialButton(onPressed:() {
                              if(_contactUs(name,email,subject,phone,review))
                              Navigator.pop(context);
                              },
                            child: Center(
                              child: Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                              ),),),)
                      ],),
                  ),
                )
            );},),
          /////////////About
          ListTile(title: Text('About Us',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            onTap: (){showDialog(context: context,
                builder: (context)=>AlertDialog(
                  title: Text('About us',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                  content: Text("Newshunt.io is a website that aggregate all Pakistan news to one platform www.newshunt.io. \n "
                      "You need great content to be better at what you do, and understand your world – whether you’re a parent or political leader, obsessed with pandas or space travel. News Hunt collects quality content on your favorite topics from the Pakistan’s most trusted sources, and presents them in a beautiful magazine format. See for yourself: try News Hunt on your smartphone, tablet, or desktop."
                  ,textAlign: TextAlign.start,style: TextStyle(fontFamily: 'Montserrat'),),
                )
            );},),
          
          ////Sign out

          ListTile(onTap: (){_signOut();},title: Visibility(visible: auth.login,child: Text("Sign out!",textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),)),)
        ],
      ),
    );
  }

  bool _contactUs(String name,String email, String subject, String phone,String review){
    if(name==null||email==null||subject==null||phone==null||review==null){
      Toast.show("Fill all the required infromation", context);
      return false;
    }
    http.post('https://newshunt.io/mobile/newshunt_contact.php',body: {
      'name':name,'subject':subject,'email':email,'phone':phone,'body':review
    })
        .then((response){
          Toast.show(response.body.toString(), context);
    })
        .catchError((error){Toast.show('Error', context);});
    //https://newshunt.io/mobile/newshunt_contact.php
    return true;
  }

  _signOut()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove('oauth_uid');
        sharedPreferences.remove('oauth_provider');
        sharedPreferences.remove('name');
        Toast.show("Signed out!", context);
        Navigator.pushReplacementNamed(context, '/home');
  }

}