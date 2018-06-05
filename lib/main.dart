import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
  new MaterialApp(
    home: new MyApp()
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
class _MyAppState extends State<MyApp> {
  HeroStatus hero;
  double expValue = 1.0;
  @override 
  void initState(){
    super.initState();
    setState(() {
     hero = new HeroStatus(id: "王大錘",level: 0,exp: 0.0);
    });
  }

  void _onpressexp(){
    setState((){
      hero.levelup(expValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: new Text(hero.id),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 10.0,right: 5.0),
                child: new Text(
                  "等級",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ),
              new Container(
                width: 40.0,
                height: 40.0,
                child: new CustomPaint(
                  painter: LevelChart(exp: hero.exp,explevel: hero.expbylevel),
                  child: new Center(
                    child: new Text(
                      hero.level.toString(),
                      style: new TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                  ),
                ),
              ),
              new SizedBox(width: 10.0,),
              new Text(
                "現在經驗值${hero.exp} 所需經驗值 ${hero.expbylevel-hero.exp} "
              )
            ],
          ),
          
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: _onpressexp,
      ),
    );
  }
}

class LevelChart extends CustomPainter {
  LevelChart({this.explevel,this.exp});
  double explevel;
  double exp;
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  @override
  void paint(Canvas canvas, Size size){
    double startAngle = - pi * 1 /4 ;
    double endAngle = (pi*exp/explevel*2)*3/4 ;
    Offset offset1 = new Offset(size.width/2, size.height/2);
    Rect rect = new Rect.fromCircle(center: offset1,radius: size.width/2);
    Rect innerrect = new Rect.fromCircle(center: offset1,radius: size.width/4);
    Paint paint = new Paint()
      ..color = Colors.blue.shade500
      ..strokeWidth = 0.0;
    Paint innerArcPaint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 0.0;
    // pi 只有180度 
    canvas.drawArc(rect, startAngle, endAngle , true, paint);
    canvas.drawArc(innerrect, 0.0, pi*2, true, innerArcPaint);
  }

}

class HeroStatus {
  int level;
  double exp;
  double expbylevel;
  final int maxLevel = 99;
  final String id;
  final double expbase = 20.0;
  HeroStatus({this.id,this.level,this.exp}){
    // 初始化
    expbylevel = level * 1.0 + expbase;
  }
  void levelup(double value) {

    // 敘述 打怪得到經驗值加到現在的經驗 當經驗值超過升級的經驗值 可能有人越級打怪
    exp += value;
    expbylevel = level * 1.0 + expbase;
    int g = (exp~/expbylevel);
    if (g > 0) {
      for (var i =0; i < g; i++ ) {
      exp -= expbylevel;
      level += 1;
      expbylevel = level * 1.0 + expbase;   		 
      }
    }else if(level == maxLevel){
      level = maxLevel;
    }
  }
  @override
  String toString() {
      return '現在等級 : $level , 現在經驗值 : $exp';
  }
}



