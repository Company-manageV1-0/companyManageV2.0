<template>
    <div class="back_image">
        <div class="login">
            <div class="title"><h1>软件售后服务系统</h1>
            </div>
           
            <hr/>

            <form>
                <div class="one">
                    <span>邮箱</span>
                    <input type="text" style="outline:none" v-model="email">
                </div>

                <!-- <div class="one">
                    <span>验证码</span>
                    <input class="code" type="" v-model="code"/>
                    <button @click="getcode" class="getcode1">获取验证码</button>
                </div> -->

                <div class="one">
                    <span>密码</span>
                    <input type="password" style="outline:none" v-model="pass">
                </div>


                <div >
                    <el-button @click="login1" style="outline:none" type="primary" size="medium" >Login</el-button>
                </div>

                <div class="one">
                    <a @click="register">&emsp;免费注册</a>
                    <a>&emsp;忘记密码？</a>
                </div>

            </form>
            <br/>
           
          
        </div>
    </div>
</template>

<script>
import store from '../store'

export default {
    name:'Login',
    data(){
        return{
            email:'',
            // code:'',
            // key:'',
            pass:'',
            // userToken:''
            userToken:'',
            Baseurl:'',
        }
    },


// mounted(){console.log(store.state.Baseurl)},

methods:{
    
    login1(){
        this.Baseurl = store.state.Baseurl
        // alert(sessionStorage.getItem("token"))

        this.axios({
            url:this.Baseurl+':8080/user/login-by-password',
            
            params:{
                email:this.email,
                password:this.pass,

            }
        }).then(res=>{    
                     
            console.log(res);
            // console.log('data'+res.result[0])
            // console.log('token:'+res.data.result);
            // 获取后端token
            // this.userToken = res.data.result;
            // 储存到vuex
            var userToken = '';
            console.log(userToken);
            this.userToken = res.data.result;
            console.log("userToken:" + this.userToken);
            // localStorage.setItem('Authorization',this.userToken);
            //  this.$store.commit("Authorization", this.userToken);
//根据store中set_token方法将token保存至localStorage/sessionStorage中,this.userToken,获取token的value值 
            this.$store.commit('set_token',this.userToken);
            this.$router.push({ path:'/user_first/first'}) 
            
        }).catch(err=>{
            console.log(err);

            //失败后删除token,并跳转到登录界面
                // localStorage.removeItem('token');
                
                // this.$store.commit('del_token',this.userToken); 
                this.$message.error('账号密码错误！');
                
                
        });
    },

    register(){
        this.$router.push({ path:'/register' });
    },


},


}
</script>

<style scoped>
.el-button {
    width:310px;
    position: center;
    margin-top: 30px;
    margin-left: 40px;

}
.title button{
    height: 60px;
    background-color:#00BFFF;
    color: white;
    text-align: center;

}

    .getcode1{
        height: 30px;
        width: 80px;
    }

    .code{
     height: 30px;
      width: 100px;
      background-color: #dbbbbb;
      border-color:white ;
      /* color: white; */
      margin-left: 15px;
    }
    a{
        color: black;
        margin-left:80px;
        cursor: pointer;
    }
    .one button{
        height: 30px;
        width: 260px;
        margin-left: 60px;
        background-color:#00BFFF;
        border: none;
        color: white;
    }
    span{
        color: black;
    }
    .one{
        margin-left:10%;
        margin-top: 30px;
        
    }

    input{
      height: 30px;
      width: 250px;
      background-color: white;
      border-color:white ;
      color: black;
      margin-left:30px;
    }

    .title{
        width: 100%;
        text-align: center;
        color: white
    }
    

    .login{
        height:300px;
        width: 400px;
        border:1px solid white;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        /* background-color: #dbbbbb; */
      
    }


    .back_image{
    width: 100%;
    height: 100%;
    /* background-color:beige; */
    background: url(../assets/login-7.jpg) center center no-repeat;
    background-size: 100% 100%;
    position: fixed;
    }


    
   
</style>