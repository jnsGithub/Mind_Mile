import 'package:d_chart/d_chart.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/diaryView/diaryController.dart';

class DiaryView extends GetView<DiaryController> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => DiaryController());
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.only(left: 60, right: 10),
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xffEAF6FF),
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('선희의 기록', style: TextStyle(fontSize: 17, color: subColor, fontWeight: FontWeight.w700),),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: subColor,
                                minimumSize: const Size(80, 23),
                                maximumSize: const Size(80, 23),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: (){

                              },
                              child: Text('전체 기록 보기', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff707070), width: 1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profileex.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 13,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
              height: 429,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TODO: 여기 만들어야함.
                        Icon(Icons.circle, size: 7, color: subColor,),
                        Text('  한 주간의 나', style: TextStyle(fontSize: 15, color: subColor,fontWeight: FontWeight.w700),),
                        const SizedBox(width: 3,),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Icon(Icons.info_outline, size: 14, color: subColor),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(alignment: Alignment.centerRight,child: Text('2024.10.06~2024.10.12', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w400),)),
                  Container(
                    height: 170,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,

                          maxY: 7,
                          barGroups: [
                            makeGroupData(0, 2, 7, 7),
                            makeGroupData(1, 5, 7, 7),
                            makeGroupData(2, 0.5, 7, 2),
                            makeGroupData(3, 4, 7, 4),
                            makeGroupData(4, 3, 7, 6),
                            makeGroupData(5, 2, 7, 4),
                            makeGroupData(6, 3, 7, 4),
                          ],
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    );
                                    switch (value) {
                                      case 0:
                                        return Text('0', style: style);
                                      case 3:
                                        return Text('할일수', style: style);
                                      case 7:
                                        return Text('7', style: style);
                                      default:
                                        return Container();
                                    }
                                  }
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  );
                                  switch (value) {
                                    case 0:
                                      return Text('S', style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ));
                                    case 1:
                                      return Text('M', style: style);
                                    case 2:
                                      return Text('T', style: style);
                                    case 3:
                                      return Text('W', style: style);
                                    case 4:
                                      return Text('T', style: style);
                                    case 5:
                                      return Text('F', style: style);
                                    case 6:
                                      return Text('S', style: TextStyle(
                                        color: Color(0xff78B7FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ));
                                    default:
                                      return Text('', style: style);
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(color: Colors.black, width: 1),
                                bottom: BorderSide(color: Colors.black, width: 1),
                              )
                          ),
                          gridData: FlGridData(
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xff37434d),
                                  strokeWidth: 0.001,
                                  dashArray: [5, 2],
                                );
                              },
                              horizontalInterval: 1,
                              drawHorizontalLine: true,
                              drawVerticalLine: false
                          ),
                          barTouchData: BarTouchData(enabled: false),
                        ),
                      ),
                  ),
                  Container(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.0154,
                              height: size.width * 0.0154,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color(0xffABE0FF), Color(0xff32A8EB)],
                                  stops: [0, 1],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text('끝낸 일', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600),)
                          ],
                        ),
                        SizedBox(width: 10,),
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.0154,
                              height: size.width * 0.0154,
                              decoration: BoxDecoration(
                                color: Color(0xffABE0FF),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text('미룬 일', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600),)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: const Color(0xff37434d),
                              strokeWidth: 0.001,
                            );
                          },
                          // getDrawingVerticalLine: (value) {
                          //   return FlLine(
                          //     color: const Color(0xff37434d),
                          //     strokeWidth: 0.001,
                          //     dashArray: [5, 2],
                          //   );
                          // },
                        ),
                        titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      const style = TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      );
                                      switch (value) {
                                        case 0:
                                          return Image(image: AssetImage('assets/images/score/selectTT.png'), width: 40, height: 40, fit: BoxFit.fitWidth,);
                                        case 3:
                                          return Image(image: AssetImage('assets/images/score/selectSoso.png'), width: 40, height: 40, fit: BoxFit.fitWidth,);
                                        case 6:
                                          return Image(image: AssetImage('assets/images/score/selectHappy.png'), width: 40, height: 40, fit: BoxFit.fitWidth,);
                                        default:
                                          return Column(
                                            children: [
                                            ],
                                          );
                                      }
                                    }
                                )
                            ),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                switch (value) {
                                  case 1:
                                    return Text('S', style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ));
                                  case 2:
                                    return Text('M', style: style);
                                  case 3:
                                    return Text('T', style: style);
                                  case 4:
                                    return Text('W', style: style);
                                  case 5:
                                    return Text('T', style: style);
                                  case 6:
                                    return Text('F', style: style);
                                  case 7:
                                    return Text('S', style: TextStyle(
                                      color: Color(0xff78B7FF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ));
                                  default:
                                    return Text('', style: style);
                                }
                              },
                            )
                            )
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(color: Colors.black, width: 1),
                            bottom: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        minX: 0,
                        maxX: 8,
                        minY: 0,
                        maxY: 7,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(1, 2),
                              FlSpot(2, 1),
                              FlSpot(3, 3),
                              FlSpot(4, 6),
                              FlSpot(5, 4),
                              FlSpot(6, 3),
                              FlSpot(7, 6),
                            ],
                            // gradient: LinearGradient(
                            //   colors: [Color(0xffC4C3BA), Color(0xff8DCECA), Color(0xff57B7FF)],
                            //   stops: [0.35, 1, 1],
                            // ),
                            isCurved: false,
                            color: Color(0xff49A09F),
                            barWidth: 1,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                                show: true,
                                // checkToShowDot: (spot, barData) {
                                //   return spot.x != 0 && spot.x != 6;
                                // },
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Color(0xff32A8EB),
                                    strokeWidth: 0,
                                    strokeColor: Colors.white,
                                  );
                                }
                                ),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child:
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TODO: 여기 만들어야함.
                      Icon(Icons.circle, size: 7, color: subColor,),
                      Text('  목표별 평균 달성률', style: TextStyle(fontSize: 15, color: subColor,fontWeight: FontWeight.w700),),
                      const SizedBox(width: 3,),
                      GestureDetector(
                        onTap: (){

                        },
                        child: Icon(Icons.info_outline, size: 14, color: subColor),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, size: 3, color: subColor,),
                            Text('  MindMILE', style: TextStyle(fontSize: 10, color: subColor,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        singleBar(
                            35,
                            Color(0xff32A8EB),
                            LinearGradient(
                              colors: [Color(0xffABE0FF), Color(0xff32A8EB)],
                              stops: [0.01, 1],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          context
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 3, color: subColor,),
                            Text('  릴렉스루틴', style: TextStyle(fontSize: 10, color: subColor,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 5,),

                        singleBar(
                            75,
                            Color(0xff68B64D),
                            LinearGradient(
                              colors: [Color(0xffA5F18B), Color(0xff68B64D)],
                              stops: [0.01, 1],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          context
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            SizedBox(height: 20,),
            Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // TODO: 여기 만들어야함.
                            Icon(Icons.circle, size: 7, color: subColor,),
                            Text('  의미 있는 날의 기록 키워드', style: TextStyle(fontSize: 15, color: subColor,fontWeight: FontWeight.w700),),
                            const SizedBox(width: 3,),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.info_outline, size: 14, color: subColor),
                            )
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: subColor,
                              minimumSize: const Size(80, 23),
                              maximumSize: const Size(80, 23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: (){

                            },
                            child: Text('긍정 일기 보기', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500),))
                      ],
                    ),
                    Expanded(
                      child: GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        children: [
                          for(int i = 0; i < controller.diaryList.length; i++)
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: mainColor,
                                ),
                                height: 30,
                                width: 50,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  strokeWidth: 1.5,
                                  dashPattern: [5, 3],
                                  color: subColor,
                                  radius: const Radius.circular(60),
                                  child: Center(
                                    child: Text(controller.diaryList[i], style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w700),),
                                  ),
                              ),
                              )
                        ],
                      ),
                    )
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


   /*--------------------------위젯------------------------------*/
  singleBar(double y, Color color, Gradient gradient, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(y*3);
    return RotatedBox(
      quarterTurns: 1,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 20,
            child: BarChart(
              BarChartData(

                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return Text('Progress', style: style);
                      },
                      reservedSize: 60,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                    show: false
                ),

                barGroups: [
                  BarChartGroupData(
                    barsSpace: -20,
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 100, // 바의 길이
                        width: 20, // 바의 두께
                        borderRadius: BorderRadius.circular(5),
                        color: color.withOpacity(0.2),
                      ),
                      BarChartRodData(
                        // backDrawRodData: BackgroundBarChartRodData(
                        //   fromY: 100,
                        //   show: true,
                        //   color: Color(0xff32A8EB).withOpacity(0.2),
                        // ),
                        toY: y, // 바의 길이
                        width: 20, // 바의 두께
                        borderRadius: y == 100 ? BorderRadius.circular(5) : BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                        gradient: gradient,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 4,
            bottom: y != 100 ?  y*3 : null, // 차트의 위치에 맞추어 텍스트 배치
            top: y == 100 ?  0 : null,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                '${y.toInt()}%', // 비율 표시 텍스트
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: -22,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y3, // 전체 높이를 설정하여 두 값을 합쳐줌
          width: 22,
          color: Color(0xff32A8EB).withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
        BarChartRodData(
          toY: y1,
          width: 22,
          color: Colors.transparent,
          borderRadius: y1 == y3 ?  BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ) : BorderRadius.zero,
          gradient: LinearGradient(
            colors: [Color(0xffABE0FF), Color(0xff32A8EB)],
            stops: [0.35, 1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: true,
          //   toY: y3,
          //   color: Color(0xff32A8EB).withOpacity(0.2),
          // ),
        ),
      ],
    );
  }
}