import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:balloon_widget/balloon_widget.dart';
import 'package:d_chart/d_chart.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/diaryView/diaryController.dart';
import 'package:super_tooltip/super_tooltip.dart';


class DiaryView extends GetView<DiaryController> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => DiaryController());
    final _controller = SuperTooltipController();
    GlobalKey _targetKey = GlobalKey();
    GlobalKey _targetKey2 = GlobalKey();
    GlobalKey _targetKey3 = GlobalKey();
    return RefreshIndicator(
      onRefresh: () async {
        controller.init();
      },
      child: SingleChildScrollView(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
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
                                Text('${myName}의 기록', style: TextStyle(fontSize: 17, color: subColor, fontWeight: FontWeight.w700),),

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
                                      Get.toNamed('/diaryDetailView', arguments: false);
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
                  const SizedBox(height: 13,),
                  GestureDetector(
                    onHorizontalDragEnd: (details){
                      if(details.primaryVelocity! > 0){
                        controller.week.value++;
                        controller.init();
                      }
                      else if(details.primaryVelocity! < 0){
                        if(controller.week.value > 0){
                          controller.week.value--;
                          controller.init();
                        }
                      }
                      // print(controller.week.value);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
                      height: 450,
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
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // TODO: 여기 만들어야함.
                                    Icon(Icons.circle, size: 7, color: subColor,),
                                    Text('  한 주간의 나', style: TextStyle(fontSize: 15, color: subColor,fontWeight: FontWeight.w700),),
                                    const SizedBox(width: 3,),
                                    GetBuilder<GlobalController>(
                                        builder: (globalController){
                                          return GestureDetector(
                                            onTap: (){globalController.aa(
                                                context,_targetKey ,
                                                '- 일주일 동안의 요일별 내가 계획한 할 일과 수행 완료한 양을 한눈에 볼 수 있어요 !',
                                                text2 : '- 일주일 동안의 요일별 나의 점수 (기분) 변화를 한눈에 볼 수 있어요 !');
                                            },
                                            child: Icon(
                                              key: _targetKey,
                                              Icons.info_outline,
                                              color: subColor,
                                              size: 14,
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                ),
                                Obx(() => Container(alignment: Alignment.centerRight,child: Text(
                                  '${controller.weeklyDate['sun']}~${controller.weeklyDate['sat']}'
                                  , style: const TextStyle(fontSize: 8.5, color: Color(0xff767676), fontWeight: FontWeight.w500),)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          Container(
                            height: 170,
                            child: Obx(() => BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,

                                  maxY: controller.maxY.value,
                                  barGroups: [
                                    makeGroupData(0, controller.weeklyTodoList[1][0], controller.weeklyTodoList[0][0]), // x축, 끝낸 일, y축, 전체 일
                                    makeGroupData(1, controller.weeklyTodoList[1][1], controller.weeklyTodoList[0][1]),
                                    makeGroupData(2, controller.weeklyTodoList[1][2], controller.weeklyTodoList[0][2]),
                                    makeGroupData(3, controller.weeklyTodoList[1][3], controller.weeklyTodoList[0][3]),
                                    makeGroupData(4, controller.weeklyTodoList[1][4], controller.weeklyTodoList[0][4]),
                                    makeGroupData(5, controller.weeklyTodoList[1][5], controller.weeklyTodoList[0][5]),
                                    makeGroupData(6, controller.weeklyTodoList[1][6], controller.weeklyTodoList[0][6]),
                                  ],
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          reservedSize: 30,
                                          interval: 1,
                                          showTitles: true,
                                          getTitlesWidget: (double value, TitleMeta meta) {
                                            // print('밸류 : ${value}');

                                            const style = TextStyle(
                                              color: Color(0xff767676),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            );
                                            if(value == 0){
                                              return Text('0개', style: style, textAlign: TextAlign.center,);
                                            }
                                            else if(value == controller.maxY.value / 2){
                                              return Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 0.58,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffBEBEBE),
                                                    ),
                                                  ),
                                                  Text('할일수', style: TextStyle(
                                                    color: Color(0xff767676),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 9,
                                                  )),
                                                  Container(
                                                    width: 0.58,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffBEBEBE),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            else if(value == controller.maxY.value){
                                              return Text('${controller.maxY.value.toInt()}개', style: style, textAlign: TextAlign.center,);
                                            }
                                            else{
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
                                            color: Color(0xff767676),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          );
                                          switch (value) {
                                            case 0:
                                              return Container(
                                                padding: EdgeInsets.only(top: 3),
                                                child: Text('S', style: TextStyle(
                                                  color: Color(0xffD65050),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                )),
                                              );
                                            case 1:
                                              return Container(
                                                padding: EdgeInsets.only(top: 3),
                                                  child: Text('M', style: style));
                                            case 2:
                                              return Container(
                                                  padding: EdgeInsets.only(top: 3),
                                                  child: Text('T', style: style));
                                            case 3:
                                              return Container(
                                                padding: EdgeInsets.only(top: 3),
                                                  child: Text('W', style: style));
                                            case 4:
                                              return Container(
                                                  padding: EdgeInsets.only(top: 3),
                                                  child: Text('T', style: style));
                                            case 5:
                                              return Container(
                                                  padding: EdgeInsets.only(top: 3),
                                                  child: Text('F', style: style));
                                            case 6:
                                              return Container(
                                                padding: EdgeInsets.only(top: 3),
                                                child: Text('S', style: TextStyle(
                                                  color: Color(0xff78B7FF),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                )),
                                              );
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
                                        left: BorderSide(color: Color(0xff595959), width: 1.17),
                                        bottom: BorderSide(color: Color(0xff595959), width: 1.17),
                                      )
                                  ),
                                  gridData: FlGridData(
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: const Color(0xff37434d),
                                          strokeWidth: 0.2,
                                          dashArray: [5, 2],
                                        );
                                      },
                                      horizontalInterval: 1,
                                      drawHorizontalLine: true,
                                      drawVerticalLine: false
                                  ),
                                  barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(

                                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                          return BarTooltipItem(
                                            controller.weeklyTodoList[0][groupIndex].toString(),
                                            TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 20,
                            padding: EdgeInsets.only(left: 30),
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
                                    Text('완료', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),)
                                  ],
                                ),
                                SizedBox(width: 30,),
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
                                    Text('미완료', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),)
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 160,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 15.5,
                                  top: 8,
                                  child: Container(
                                    width: 0.58,
                                    height: 120,
                                    color: Color(0xffBEBEBE),
                                  ),
                                ),
                                // Positioned(
                                //   left: 0,
                                //   top: 57,
                                //   child: Image(image: AssetImage('assets/images/score/selectSoso.png'), width: 32, height: 32, fit: BoxFit.fitWidth,),
                                // ),
                                Obx(() => LineChart(

                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        touchTooltipData: LineTouchTooltipData(
                                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                            return touchedBarSpots.map((barSpot) {
                                              final flSpot = barSpot;
                                              if(flSpot.y == -1){
                                                return LineTooltipItem('none', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),);
                                              }
                                                return LineTooltipItem(
                                                  '${flSpot.y.toInt()}',
                                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                      minX: -0.5,  // X 축의 최소값을 낮춰 패딩 효과 추가
                                      maxX: 6.5,   // X 축의 최대값을 높여 패딩 효과 추가
                                      minY: 0,    // Y 축의 최소값을 낮춰 패딩 효과 추가
                                      maxY: 7.5,     // Y 축의 최대값을 높여 패딩 효과 추가
                                      // minX: 0,
                                      // maxX: 6,
                                      // minY: 0,
                                      // maxY: 6,
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        drawHorizontalLine: true,
                                        horizontalInterval: 1,
                                        verticalInterval: 1,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: const Color(0xff37434d),
                                            strokeWidth: 0.2,
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
                                                reservedSize: 30,
                                                  showTitles: true,
                                                  interval: 1,
                                                  getTitlesWidget: (double value, TitleMeta meta) {
                                                    const style = TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    );
                                                    switch (value) {
                                                      case 1:
                                                        return Image(image: AssetImage('assets/images/score/selectTT.png'), width: 30, height: 30, fit: BoxFit.fitWidth,);
                                                      case 4:
                                                        return Image(image: AssetImage('assets/images/score/selectSoso.png'), width: 30, height: 30, fit: BoxFit.fitWidth,);
                                                      case 7:
                                                        return Image(image: AssetImage('assets/images/score/selectHappy.png'), width: 30, height: 30, fit: BoxFit.fitWidth,);
                                                      default:
                                                        return Column(
                                                          children: [
                                                          ],
                                                        );
                                                    }
                                                  }
                                              )
                                          ),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (double value, TitleMeta meta) {
                                                  const style = TextStyle(
                                                    color: Color(0xff767676),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  );
                                                  switch (value) {
                                                    case 0:
                                                      return Container(
                                                        padding: EdgeInsets.only(top: 3),
                                                        child: Text('S', style: TextStyle(
                                                          color: Color(0xffD65050),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10,
                                                        )),
                                                      );
                                                    case 1:
                                                      return Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text('M', style: style));
                                                    case 2:
                                                      return Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text('T', style: style));
                                                    case 3:
                                                      return Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text('W', style: style));
                                                    case 4:
                                                      return Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text('T', style: style));
                                                    case 5:
                                                      return Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text('F', style: style));
                                                    case 6:
                                                      return Container(
                                                        padding: EdgeInsets.only(top: 3),
                                                        child: Text('S', style: TextStyle(
                                                          color: Color(0xff78B7FF),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10,
                                                        )),
                                                      );
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
                                          left: BorderSide(color: Color(0xff595959), width: 1.17),
                                          bottom: BorderSide(color: Color(0xff595959), width: 1.17),
                                        ),
                                      ),

                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: [
                                            if(controller.weeklyFeelingScore['sun'] != 0) FlSpot(0, controller.weeklyFeelingScore['sun']!),
                                            if(controller.weeklyFeelingScore['mon'] != 0) FlSpot(1, controller.weeklyFeelingScore['mon']!),
                                            if(controller.weeklyFeelingScore['tue'] != 0) FlSpot(2, controller.weeklyFeelingScore['tue']!),
                                            if(controller.weeklyFeelingScore['wed'] != 0) FlSpot(3, controller.weeklyFeelingScore['wed']!),
                                            if(controller.weeklyFeelingScore['thu'] != 0) FlSpot(4, controller.weeklyFeelingScore['thu']!),
                                            if(controller.weeklyFeelingScore['fri'] != 0) FlSpot(5, controller.weeklyFeelingScore['fri']!),
                                            if(controller.weeklyFeelingScore['sat'] != 0) FlSpot(6, controller.weeklyFeelingScore['sat']!),
                                          ],
                                          gradient: LinearGradient(
                                            colors: [Color(0xffC4C3BA), Color(0xff8DCECA), Color(0xff57B7FF)],
                                            stops: [0.35, 1, 1],
                                          ),
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
                                                  color: spot.y == 1 ? const Color(0xffC4C3BA)
                                                      : spot.y == 2 ? const Color(0xffB5C7BF)
                                                      : spot.y == 3 ? const Color(0xffA1CBC5)
                                                      : spot.y == 4 ? const Color(0xff94CEC9)
                                                      : spot.y == 5 ? const Color(0xff80C9D8)
                                                      : spot.y == 6 ? const Color(0xff6FC2E9)
                                                      : spot.y == 7 ? const Color(0xff57B7FF)
                                                      : Colors.transparent,
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
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    // height: 140,
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
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // TODO: 여기 만들어야함.
                            Icon(Icons.circle, size: 7, color: subColor,),
                            Text('  목표별 평균 달성률', style: TextStyle(
                                fontSize: 15,
                                color: subColor,
                                fontWeight: FontWeight.w700),),
                            const SizedBox(width: 3,),
                            GetBuilder<GlobalController>(
                                builder: (globalController){
                                  return GestureDetector(
                                    onTap: (){globalController.aa(
                                        context,_targetKey2 ,
                                        '- 내가 목표로 설정한 카테고리 속 할 일의 평균 달성률을 한눈에 볼 수 있어요 !');
                                    },
                                    child: Icon(
                                      key: _targetKey2,
                                      Icons.info_outline,
                                      color: subColor,
                                      size: 14,
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Obx(() => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.todoListGroup.length,
                              itemBuilder: (context, index) {
                                double avg = 0;
                                for(int i = 0; i < controller.todoListGroup[index].todoList.length; i++) {
                                  if(controller.todoListGroup[index].todoList.isEmpty){
                                    avg = 0;
                                    break;
                                  }
                                  if (controller.todoListGroup[index]
                                      .todoList[i].complete == 0) {
                                    avg = avg + 0;
                                  }
                                  else if (controller.todoListGroup[index]
                                      .todoList[i].complete == 1) {
                                    avg = avg + 50;
                                  }
                                  else if (controller.todoListGroup[index]
                                      .todoList[i].complete == 2) {
                                    avg = avg + 100;
                                  }
                                }
                                avg = controller.todoListGroup[index].todoList.isEmpty ? 0 : avg / controller.todoListGroup[index].todoList.length;
                                // print('평균 : ${avg / controller.todoListGroup[index].todoList.length}');
                                Color color = Color(controller.todoListGroup[index].color);

                                // 각 RGB 성분을 연하게 조절
                                int r = color.red + ((255 - color.red) * (70 / 100)).round();
                                int g = color.green + ((255 - color.green) * (70 / 100)).round();
                                int b = color.blue + ((255 - color.blue) * (70 / 100)).round();
                                Color startColor = Color.fromARGB(color.alpha, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle, size: 3, color: subColor,),
                                        Text('  ${controller.todoListGroup[index].content}', style: TextStyle(
                                            fontSize: 10,
                                            color: subColor,
                                            fontWeight: FontWeight.w600),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    singleBar(
                                        avg,
                                        Color(controller.todoListGroup[index].color),
                                        LinearGradient(
                                          colors: [
                                            startColor,
                                            Color(controller.todoListGroup[index].color)
                                          ],
                                          stops: [0.01, 1],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        context
                                    ),
                                    SizedBox(height: 8,),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.circle, size: 3, color: subColor,),
                                    //     Text('  릴렉스루틴', style: TextStyle(
                                    //         fontSize: 10,
                                    //         color: subColor,
                                    //         fontWeight: FontWeight.w600),),
                                    //   ],
                                    // ),
                                    // SizedBox(height: 5,),
                                    //
                                    // singleBar(
                                    //     75,
                                    //     Color(0xff68B64D),
                                    //     LinearGradient(
                                    //       colors: [
                                    //         Color(0xffA5F18B),
                                    //         Color(0xff68B64D)
                                    //       ],
                                    //       stops: [0.01, 1],
                                    //       begin: Alignment.bottomCenter,
                                    //       end: Alignment.topCenter,
                                    //     ),
                                    //     context
                                    // ),
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 135,
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
                                    GetBuilder<GlobalController>(
                                        builder: (globalController){
                                          return GestureDetector(
                                            onTap: (){globalController.aa(
                                                context,_targetKey3 ,
                                                '- 내가 긍정적인 점수를 기록한 날들의 한 일 키워드 TOP 8을 듀디가 추려보았어요 !', text2: '- [ 긍정 일기 보기 ] 를 누르면 긍정적인 점수의 날에 기록한 일기를 볼 수 있어요 !');
                                            },
                                            child: Icon(
                                              key: _targetKey3,
                                              Icons.info_outline,
                                              color: subColor,
                                              size: 14,
                                            ),
                                          );
                                        }
                                    ),
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
                                      Get.toNamed('/diaryDetailView', arguments: true);
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
                                  for(int i = 0; i < textList.length; i++)
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Color(0xffD6EEFB),
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
                                          child: Text(textList[i], style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /*--------------------------위젯------------------------------*/
  singleBar(double y, Color color, Gradient gradient, BuildContext context, ) {
    Size size = MediaQuery.of(context).size;
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
                barTouchData: BarTouchData(enabled: false),
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
            bottom: y == 0 ? 10 : y != 100 ?  y*3 + 5 - 10 : null, // 차트의 위치에 맞추어 텍스트 배치
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

  BarChartGroupData makeGroupData(int x, double completeCount, double maxY) {
    return BarChartGroupData(
      barsSpace: -22,
      x: x,
      barRods: [
        BarChartRodData(
          toY: maxY, // 전체 높이를 설정하여 두 값을 합쳐줌
          width: 22,
          color: Color(0xff32A8EB).withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
        BarChartRodData(
          toY: completeCount,
          width: 22,
          color: Colors.transparent,
          borderRadius: completeCount == maxY ?  BorderRadius.only(
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