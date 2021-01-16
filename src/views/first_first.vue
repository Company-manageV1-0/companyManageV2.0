<template>

<div class="big">
    <div class="top">
        <h1>welcome to our company</h1>
        <div class="top_button">
        <el-button class="button" type='text' @click="login">登录</el-button>
        <el-button class="button" type='text' @click="register">免费注册</el-button>
    </div>
    </div>
    
    <div class="one">

    <div class="one_center" id="zhuzhuangtu"></div>

    <div class="one_center">
        <div class="one_center_div" id="user"> 
            <div class="position">
                <h2>注册用户数</h2>
                <h2>18.7万</h2>
            </div>
        </div>
        <div class="one_center_div" id="manager">
             <div class="position">
                 <h2>管理员数量</h2>
                <h2>2万</h2>
             </div>
        </div>
        <div class="one_center_div" id="programmer">
             <div class="position">
                 <h2>技术人员数量</h2>
                <h2>1万</h2>
             </div>
        </div>
        <div class="one_center_div" id="all">
             <div class="position">
                  <h2>总人数</h2>
                <h2>21.7万</h2>
             </div>
        </div>
    </div>
     <div class="one_right">
         <div class="right_title"><h2>在线咨询</h2></div>
         <div class="tec_phone">

        <el-table :data="tableData"  height="100%" style="width:100%" >
          <el-table-column prop="title" label="咨询" width="">
          </el-table-column>
            <el-table-column
            prop="comment"
            label="联系方式"
            width="">
    </el-table-column>

        </el-table>
         </div>
     </div>

    </div>

    <div class="one">
        <div class="bottom_left"> 
            <div class="circle" id="circle1"></div>
            <div class="circle" id="circle2"></div>
            <div class="circle" id="circle3"></div>
        </div>
         <div class="bottom_right"> 
              <div class="right_title"><h2>版本更新日志</h2></div>
                <div class="tec_phone">
         <el-table :data="tableDataone"  height="100%" style="width:100%" >
          <el-table-column prop="time" label="更新时间" width="">
          </el-table-column>
            <el-table-column
            prop="version"
            label="版本号"
            width="">
    </el-table-column>
        </el-table>
                </div>
         </div>
    </div>

</div>
</template>


<script>
// import $ from  'jquery'
import * as echarts from 'echarts'
export default {
    name :'first_first',
    data(){
        return{
             tableData:[{
                 title:'小王',
                 comment:'19950742457'
             },
             {
                 title:'小王',
                 comment:'19950742457'
             },
             {
                 title:'小王',
                 comment:'19950742457'
             },
             ],

            tableDataone:[{
                time:'2020-01-02',
                version:'王者荣耀2.0v',
            },
            {
                time:'2020-01-03',
                version:'川师一卡通2.0v',
            },
            {
                time:'2020-01-02',
                version:'王者荣耀2.0v',
            },
             {
                time:'2020-01-02',
                version:'原神2.0v',
            },

            ],




                //饼状图1
                echartsOption: {	// echarts选项，所有绘图数据和样式都在这里设置
                legend: {
                     orient: 'vertical',
                    left: 'right',
                    //图表上方的图例
                    data: ['已处理反馈数','未处理反馈数']
                },
                tooltip: {   //鼠标放到图上的数据展示样式
                    trigger: 'axis'
                },
                series: [{
                  name: '处理反馈占比',
                  type: 'pie',
                  barWidth: '60%',
                   
                  data: [	// 扇形图数据格式： {value, name}
                    {value: 0.8, name: '已处理反馈数'},		// value不一定是比例，echarts会自动转换
                    {value: 0.2, name: '未处理反馈数'},
                    
                  ],
                }
               
                ],
                 color:['rgb(187,199,239)','rgb(241,230,216)']
             },

                //病状图2
                echartsOption_2: {	// echarts选项，所有绘图数据和样式都在这里设置
                legend: {
                     orient: 'vertical',
                     left: 'right',
                    //图表上方的图例
                    data: ['游戏软件下载量','办公软件下载量','开发软件下载量']
                },
                tooltip: {   //鼠标放到图上的数据展示样式
                    trigger: 'axis'
                },
                series: [{
                  name: '软件下载量占比',
                  type: 'pie',
                  barWidth: '60%',
                //    radius: '50%', 
                  data: [	// 扇形图数据格式： {value, name}
                    {value: 0.6, name:'游戏软件下载量'},		// value不一定是比例，echarts会自动转换
                    {value: 0.1, name:'办公软件下载量'},
                    {value: 0.3, name:'开发软件下载量'},
                    
                  ],
                }
                ],
                 color:['rgb(167,191,209)','rgb(240,197,194)','rgb(248,220,173)']
             },
              //病状图3
                echartsOption_3: {	// echarts选项，所有绘图数据和样式都在这里设置
                legend: {
                     orient: 'vertical',
                    left: 'right',
                    //图表上方的图例
                    data: ['游戏软件反馈数','办公软件反馈数','开发软件反馈数']
                },
                tooltip: {   //鼠标放到图上的数据展示样式
                    trigger: 'axis'
                },
                series: [{
                  name: '软件反馈数占比',
                  type: 'pie',
                  barWidth: '60%',
                   
                  data: [	// 扇形图数据格式： {value, name}
                    {value: 0.8, name:'游戏软件反馈数'},		// value不一定是比例，echarts会自动转换
                    {value: 0.2, name:'办公软件反馈数'},
                    {value: 0.2, name:'开发软件反馈数'},
                    
                  ],
                }
               
                ],
                 color:['rgb(178,179,202)','rgb(219,112,147)','rgb(247,206,212)']
             },

        }
    },
   


     methods: {
         login(){
             this.$router.push({ path:'/Login' });
         },
         register(){
            this.$router.push({ path:'/register' });
         }
         
    },

   mounted(){
       //反馈饼状图
        let myChart1 = echarts.init(document.getElementById('circle1'), 'light')	// 初始化echarts, theme为light
        myChart1.setOption(this.echartsOption)	// echarts设置选项

        //软件下载量饼状图
        let myChart2 = echarts.init(document.getElementById('circle2'), 'light')	// 初始化echarts, theme为light
        myChart2.setOption(this. echartsOption_2)
    
    
        //对不同软件的反馈量饼状图
        let myChart3 = echarts.init(document.getElementById('circle3'), 'light')	// 初始化echarts, theme为light
        myChart3.setOption(this. echartsOption_3)


        //树状图
        var myChart = echarts.init(document.getElementById('zhuzhuangtu'));
        // 指定图表的配置项和数据
        var option = {
        title: {
            text: '公司处理反馈数量（2020）'
        },

        

        grid:{
             x:25,
             y:45,
             x2:5,
            y2:20,
        },
        tooltip: {},
        legend: {
            data:['反馈数量']
        },
        xAxis: {
            data: ["王者荣耀","原神","英雄联盟","皇室战争","骑马与砍杀","川师一卡通"]
        },
        yAxis: {},
        series: [{
            name: '反馈数量',
            type: 'bar',
            data: [5, 20, 36, 10, 10, 20]
        }],

          color:['rgb(171,179,222)']
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    
   }
}



</script>


<style scoped>

.tec_phone{
    /* border: 1px solid black; */
    height: 80%;
}

.right_title{
    width: 80%;
    height: 20%;
    margin-left: 10%;
    border-radius: 10px;
    background-color:burlywood;
    color: white;
    text-align: center;
    line-height:60px;
    /* border: 1px solid black; */
}
.position{
    /* border: 1px solid black; */
    width: 80%;
    height: 80%;
    margin-left: 10%;
    margin-top: 5%;
    text-align: center;
}


#user{
    background-color:rgb(253,195,194);
}
#manager{
    background-color: thistle;
}
#programmer{
     background-color:#FFA07A;
}
#all{
    background-color:#66CDAA;
}


.button{
    color: white;
}

.button :hover{
    color:black
}

.top_button{
    float:right;
    margin-top: 1%;
    margin-right: 2%;
}

h1{
    float: left;
    margin-left: 30%;
    font-family:helvetica;
    /* margin-top: 1%; */
    color: white;
      font-size: 50px;
}
h2{
      font-family:cursive;
       color: white;
       /* margin-top: 5%; */
}

.circle{
    height: 100%;
    width: 32%;
    float: left;
    margin-left: 1%;
    /* border: 1px solid black; */
    box-shadow: 5px 5px whitesmoke;
}
.bottom_left{
    float: left;
    height: 100%;
    width: 80%;
    /* border: 1px solid black; */
    /* margin-left: 2%; */
}

.bottom_right{
    float: right;
    height: 100%;
    width: 18%;
    /* border: 1px solid black; */
    margin-right: 1%;
    box-shadow: 5px 5px whitesmoke;
}

.one_center_div{
    height: 40%;
    width: 40%;
    /* border: 1px solid black; */
    float: left;
    margin-left: 7%;
    margin-top: 3%;
}
.one_right{
    margin-right: 20px;
    float:right;
    height: 100%;
    width: 20%;
    /* border: 1px solid black; */
    box-shadow: 5px 5px whitesmoke;
}
.one_center{
    height: 100%;
    width:35%;
    /* border: 1px solid black; */
    margin-left:2.5%;
    float:left;
     box-shadow: 5px 5px whitesmoke;
}
.top{
    text-align: center;
    /* line-height: 20%; */
    height: 10%;
    width: 100%;
    border: 1px solid white;
    background-color:#5470C6;
}


 .big{
     height: 100%;
     width: 100%;
     /* border: 1px solid red; */
 }

 .one{
     height:40%;
     width: 100%;
     margin-top:2%;
     /* border: 1px solid red; */
 }



</style>