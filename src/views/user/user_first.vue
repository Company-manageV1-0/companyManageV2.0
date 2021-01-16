
<template>
  <div class="big">
    <div class="top">
      <div class="logo">软件售后服务系统</div>
      <div class="header-right">
        <div class="touxiang">
          <div class="pic">
            <img :src="picsrc" id='img1'/>
          </div>

          <div>
            <span class="username">{{juese}}&nbsp;欢迎您</span>
          </div>
          <el-button class="exit" @click="exit" type="text">EXIT</el-button>  
        </div>
      </div>
    </div>

    <div class="bottom">
      <div class="left">
         <el-col class="width">
    <el-menu
      default-active="2"
      class="el-menu-vertical-demo"
      @open="handleOpen"
      @close="handleClose">
      <router-link  to="../user_first/first">
      <el-menu-item index="1">
        <i class="el-icon-location"></i>
        <span slot="title">首页</span>
      </el-menu-item>
      </router-link>
      <el-submenu index="2" v-if="usercenter">
        <template slot="title">
          <i class="el-icon-user-solid"></i>
          <span >用户中心</span>
        </template>
        <router-link to="../user_first/my_feedback">
          <el-menu-item index="2-1" class="color">我的反馈</el-menu-item>
        </router-link>
        <router-link to="../user_first/my_inform">
          <el-menu-item index="2-2" class="color">我的资料</el-menu-item>
         </router-link>
         <!-- <router-link to="../user_first/apply">
          <el-menu-item index="2-3" class="color">申请界面</el-menu-item>
         </router-link> -->
      </el-submenu>
      <el-submenu index="3" v-if="questionfeedback">
        <template slot="title">
          <i class="el-icon-s-claim"></i>
          <span>问题反馈</span>
        </template>
        <router-link to="../user_first/feedback_form">
          <el-menu-item index="3-1" class="color">我要反馈</el-menu-item>
        </router-link>
        <router-link to="../user_first/common_question">
          <el-menu-item index="3-2" class="color">知识库</el-menu-item>
        </router-link>
      </el-submenu>
      <el-submenu index="4" v-if="managercenter">
        <template slot="title">
          <i class="el-icon-s-custom"></i>
          <span>管理员中心</span>
        </template>
        <router-link to='../user_first/my_worksheet'>
          <el-menu-item index="4-1" class="color">分配工单</el-menu-item>
        </router-link>
        <router-link to='../user_first/authorization'>
          <el-menu-item index="4-2" class="color">权限管理</el-menu-item>
        </router-link>
        <!-- <router-link  to='../user_first/handle_apply' >
          <el-menu-item index="4-3" class="color">处理申请</el-menu-item>
        </router-link> -->
        <router-link to='../user_first/log'>
          <el-menu-item index="4-4" class="color">日志</el-menu-item>
        </router-link>
        <router-link to='../user_first/manage_users'>
          <el-menu-item index="4-5" class="color" >管理用户</el-menu-item>
        </router-link>
      </el-submenu>

      <el-submenu index="5" v-if="jishucenter">
        <template slot="title">
          <i class="el-icon-s-platform"></i>
          <span>技术人员中心</span>
        </template>
        <router-link  to='../user_first/handle_feedback'>
          <el-menu-item index="5-1" class="color">处理反馈</el-menu-item>
        </router-link>
        <router-link to='../user_first/alter_common_ques'>
          <el-menu-item index="5-2" class="color">增加版本库信息</el-menu-item>
        </router-link>
      </el-submenu>

    </el-menu>
  </el-col>
     

      </div>  
      <div id="center">
       <router-view></router-view>
       
      </div>
    </div>
  </div>
</template>

<script>
 import store from '../../store'
// console.log(store.state.showfirst)  
// const showfirst;

export default {
  name: "user_first",

  data() {
    return {
      userid:'',
      picsrc:'',
      show:'',
      juese:'',
      showfirst:true,
      usercenter:true,
      questionfeedback:true,
      jishucenter:true,
      managercenter:true
    };
  },

  methods: {

     handleOpen(key, keyPath) {
        console.log(key, keyPath);
      },
      handleClose(key, keyPath) {
        console.log(key, keyPath);
      },

      //退出返回首页 删除token
    exit() {
      this.$store.commit('del_token'); 
      this.$router.push({ path: "/login" });
    },
  },
  
  // created() {
  //   var token = sessionStorage.getItem("token");
  //   console.log(token);
  // },

  //得到当前用户的角色，根据返回角色来判断导航栏的显示与隐藏
  mounted() {

     if(sessionStorage.getItem('token') == null){
            this.$router.push({ path:'/'}) 
       }

     this.axios({
     url:store.state.Baseurl+':8080/user/own',
    headers:{
              'Authorization':sessionStorage.getItem("token")
        },
   }).then(res=>{
       console.log(res);
        this.userid = res.data.result.id;
        this.picsrc = res.data.result.img
        this.juese = res.data.result.username;
        console.log(this.userid)
         this.axios({
    url:store.state.Baseurl+':8080/user-role/'+this.userid,
    headers:{
          'Authorization':sessionStorage.getItem("token")
        },
      params:{
        id:this.userid
      }
   }).then(res=>{
       console.log(res);
        this.show = res.data.result.name;
     if(this.show == 'admin'){
      //  this.juese = this.show
      //  this.jishucenter = false
     }if(this.show == 'user'){
      this.juese = this.show
       this.jishucenter = false
       this.managercenter = false
     }
     if(this.show == 'programmer'){
        // this.juese = this.show
      //  this.usercenter = false
      //  this.questionfeedback = false
       this.managercenter = false
     }
   }).catch(err=>{
     console.log(err)
   })
   }).catch(err=>{
     console.log(err)
   })
  }
};
</script>


<style scoped>

span{
  font-family:youyuan;
}

/* .router {
  text-decoration: none;
  color: white;
}
.router:hover {
  color: #00bfff;
} */
#center {
  /* border: 1px solid black; */
  /* background-image: url(../../assets/login-bg.jpg); */
  /* background-size: 100%; */
  /* background-color: red; */
  width: 85%;
  height: 100%;
  /* margin-left:15%; */
  /* margin-top: -100%; */
  float: right;
  /* padding-right:2%; */
}

/* .second:hover {
  color: #00bfff;
}

.first:hover {
  color: #00bfff;
} */



.bottom {
  /* border: 1px solid black; */
  height: 90%;
  width: 100%;
  /* float:right; */
}

.exit {
  /* font-size: 14px;
  margin-left: 20px;
  background-color: #00bfff;
  border: none;
  color: whitesmoke;
  width: 80px; */
  cursor: pointer;
  margin-left: 10%;
  margin-top: 2%;
  color: white;
}

.exit:hover{
  color:#409EFF;
}

.username {
  font-size: 14px;
  margin-left: 10px;
}
.pic {
  margin-left: 20px;
}
.touxiang {
  display: flex;
  height: 70px;
  -webkit-box-align: center;
  -ms-flex-align: center;
  align-items: center;
}
.pic #img1 {
  /* border: 1px solid black; */
  height: 50px;
  width: 50px;
  border-radius: 50%;
}
.header-right {
  /* float: right; */
  padding-right: 50px;
  /* border: 1px solid red; */
  margin-left: 80%;
  margin-top: -70px;
}
.logo {
  width:250px;
  line-height:70px;
  padding-left:50px;
  font-family:youyuan;
  /* float: left; */
}

.top {
  /* border: 1px solid black; */
  height: 10%;
  width: 100%;
  background-color:#618cac;
  font-size: 22px;
  color: white;
}

.left {
  background-color: #a0c1d2;
  /* border: 1px solid red; */
  /* z-index: -100; */
  height: 100%;
  width: 15%;
  float: left;
}

.big {
  height: 100%;
  width: 100%;
  /* border: 1px solid white; */
  background-color: #f0f0f0;
}
.el-menu-item {
   /* border:1px solid red; */
  width:90%;
}
.el-submenu{
  /* border:1px solid red; */
  width:90%;
}
.el-menu-vertical-demo{
  margin-left:5%;
   background-color: #a0c1d2;
   border: none;
   width: 90%;
   /* z-index: 100;  */
   /* position: relative; */
   /* height:100%; */
}
.color{
  background-color:  #a0c1d2;
}

.color:hover{
   background-color:#ecf5ff;
}

/* .el-menu-item color{
  border:1px solid red;
  width: 160px;
} */

.el-menu-item.is-active {
    color: #409EFF;
     background-color: #a0c1d2;
}
</style>