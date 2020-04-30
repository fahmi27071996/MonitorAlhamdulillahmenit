import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

var data_tinggi = 100, min_data = 0;
var dataecharts = [10];
var red = "#db0202";
List<int> dataDisplay = List<int>();

class drawrEcharts extends StatefulWidget {
  drawrEcharts(this.start);
  int start;
  @override
  _drawrEchartsState createState() => _drawrEchartsState(start);
}

void add(int banyak) {
  dataecharts.clear();
  for (var i = 0; i < banyak; i++) {
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    dataecharts.add(randomNumber);
  }

  // display(5);

  
}

void display (int start,int end){
  // dataDisplay.add(100);
  // dataDisplay.add(banyak);
  dataDisplay.clear();
  for (int i = 0; i < dataecharts.length; i++) {
    dataDisplay.add(dataecharts[i]);
    
  }


dataDisplay =  dataDisplay.getRange(start, end).toList();
}



class _drawrEchartsState extends State<drawrEcharts>{
  _drawrEchartsState(this.start);
  int start;

    @override
  void initState() {
    super.initState();
    add(100);
    display(start,85);
    //getOtherJson();
    //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  }
  
  @override
  Widget build(BuildContext context) {

   // add(100);

     display(start,85);
    

    return Container(
      height: 100,
      width: double.infinity,
      child: Echarts(option: '''
                  {
                    animation:false,
                    height:'$data_tinggi',
                   
              
                grid: {
                        left: '0px',
                        right: '0px',
                        top:'0px'
                      },
               
                xAxis: {
                        type: 'category',

                       
                       
                        show: false,                         
                        },
                yAxis: {
                    type: 'value',
                    show: false,  
                    min:'$min_data',
                   
                   
                        },

                series: [{
                    
                    data: $dataDisplay,
                    type: 'bar',
                    itemStyle: {color: '$red'},
                    showBackground: true,
                    backgroundStyle: {
                        color: '#ffffff'
                    }
                    
                }]

              }
              
              '''),
    );
  }
}
