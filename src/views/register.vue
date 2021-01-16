<template>
    <div class="back_image">
        <div class="register">
            <div class="title"><h1>软件售后服务系统</h1></div>
            <hr/>

            <form>
                <div class="one">
                    <span>邮箱</span>
                    <input type="" v-model="email"/>
                </div>

                 <div class="one">
                    <span>密码</span>
                    <input type="password" v-model="password"/>
                </div>


                <div class="one">
                    <span>验证码</span>
                    <input class="code" type="" v-model="code"/>
                    <button @click="getcode" class="getcode1">获取验证码</button>
                </div>

                <div class="one">
                    <button @click="register" ><strong>Register</strong></button>
                </div>

                <div class="one">
                    <a @click="login">&emsp;登录</a>
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
            password:'',
            code:'',
            key:'',
            error:''
            
        }
    },

methods:{
     getcode(){
         this.axios({
          url:store.state.Baseurl+":8080/user/send-email/"+this.email,
          params:{
            email:this.email
          }
        }).then(res=>{
            console.log(res)
            this.key = res.data.result;
        }).catch(err=>{
          console.log(err)
        })
    },

   

    register(){
        this.axios({
          url:store.state.Baseurl+'/user/register',
          params:{
            email:this.email,
            password:this.password,
            code:this.code,
            key:this.key,
          
          },
          method:'post',
        }).then(res=>{
          console.log(res)
          this.$message.success('注册成功，为您跳转到登录界面！');
          this.$router.push({ path:'/Login'});
        }).catch(err=>{
           //这是解决报错500 axios没办法接收到后端数据的办法
             if (err.response) {
                // The request was made and the server responded with a status code
                // that falls out of the range of 2xx
                console.log(err.response.data.message);

                this.error = err.response.data.message  
                this.$message.error(this.error)
                console.log(err.response.status);
                console.log(err.response.headers);
              } else if (err.request) {
                // The request was made but no response was received
                // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
                // http.ClientRequest in node.js
                console.log(err.request);
              } else {
                // Something happened in setting up the request that triggered an Error
               alert('错误');
              }
              console.log(err);
        });

    },

    login(){
        this.$router.push({ path:'/Login' });
    }

}
}
</script>

<style scoped>

    .getcode1{
        height: 30px;
        width: 80px;
    }

    .code{
     height: 30px;
      width: 100px;
      background-color: white;
      border-color:white ;
      color: white;
      margin-left: 15px;
    }
    a{
        color: black;
        margin-left:90px;
        cursor: pointer;
    }
    button{
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
    

    .register{
        height:400px;
        width: 400px;
        border:1px solid white;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
      
    }


    .back_image{
    width: 100%;
    height: 100%;
    background: url(../assets/login-7.jpg) center center no-repeat;
    background-size: 100% 100%;
    position: fixed;
    }

    
   
</style>