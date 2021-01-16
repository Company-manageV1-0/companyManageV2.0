<template>
  <div class="center">
    <!-- <el-Icon type="arrow-left" /> -->
    <a-page-header
      class="header"
      title="用户中心 ｜ 我的资料"
      @back="
        () => {
          this.$router.push({ path: '../user_first/first' });
        }
      "
    />
    <div class="container">
      <div class="form-box">

        <el-form ref="form" :model="form" label-width="20%">
          <el-form-item label="头像">
            <div class="absolute">
              <div class="user_pic">
                <img :src="picsrc" class="img1" />
              </div>
              <input type="file" class="file" name="file" @change="changepic" />
            </div>
          </el-form-item>

          <el-form-item label="昵称">
            <el-input v-model="form.nicheng" class="input" ></el-input>
          </el-form-item>

          <!-- <el-form-item label="姓名">
                        <el-input v-model="form.name" class="input"></el-input>
                    </el-form-item> -->

          <el-form-item label="常用邮箱">
            <el-input v-model="form.email" class="input" disabled></el-input>
          </el-form-item>

          <el-form-item label="手机号">
            <el-input v-model="form.phonenum" class="input"></el-input>
          </el-form-item>

          <el-form-item label="性别">
            <el-radio-group v-model="form.resource">
              <el-radio label="男"></el-radio>
              <el-radio label="女"></el-radio>
              <el-radio label="其它"></el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="onSubmit" class="btn"
              >提交</el-button
            >
            &emsp;
            <el-button class="btn">取消</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
import store from '../../store'
export default {
     name: 'my_inform',
    data() {
        return {
            
            picsrc:'',
            pic_url:'',
            img:'',
            form: {
                nicheng:'',
                email:'',
                phonenum:'',
            }
        };
    },
    methods: {

        //修改信息
        onSubmit() {
          console.log(this.form)      
          console.log(this.picsrc)
            this.axios({
                url:store.state.Baseurl+':8080/user/own',
                 headers: {
                 Authorization:sessionStorage.getItem("token"),
                    },
                method:'put',
                params:{
                    username:this.form.nicheng,
                    phone:this.form.phonenum,
                    email:this.form.email,
                    sex:this.form.resource,
                    img:this.picsrc,
                  }
                }).then(res=>{
                  console.log(res)
                  this.$message.success('修改信息成功!');
                }).catch(err=>{
                  console.log(err)
                  this.$router.push({ path:'/user_first/four'})
                })
        },


        changepic(e){
        let file = e.target.files[0];
        let param = new FormData(); //创建form对象
        param.append('file',file);//通过append向form对象添加数据
        console.log(param.get('file')); //FormData私有类对象，访问不到，可以通过get判断值是否传进去
        let config = {
          headers:{'Content-Type':'multipart/form-data',
                    'Authorization':sessionStorage.getItem("token")
          }
        }; //添加请求头
        this.$http.post(store.state.Baseurl+':8080/file/upload',param,config)
          .then(response=>{
            console.log(response.data);
            console.log(response.data.result)
            this.picsrc = response.data.result;
          })
         },
    },

    mounted(){
        
        this.axios({
            url:store.state.Baseurl+':8080/user/own',
             headers: {
                Authorization: sessionStorage.getItem("token"),
            },
            method:'get',
        }).then(res=>{
            console.log(res)
            console.log(res.data.result.username)
            this.form.resource = res.data.result.sex
            this.form.nicheng = res.data.result.username
            this.form.email = res.data.result.email
            this.form.phonenum = res.data.result.phone
            
            this.pic_url = res.data.result.img
            console.log(this.pic_url)
            // var img = document.getElementsByClassName('.img1');
            // console.log(img)
            // console.log(img);
            this.picsrc = this.pic_url;
                // img.src = '../../assets/img.jpg';
            //  console.log(img.src)
        }).catch(err=>{
            console.log(err)
        })
    }
}
</script>

<style scoped>
.container {
  width: 80%;
  padding: 5%;
  background: #fff;
  /* border: 1px solid black; */
  border-radius: 5px;
  margin-left: 10%;
  margin-top: 2%;
  height: 80%;
}
.btn {
  width: 120px;
}

.input {
  width: 70%;
}
span {
  font-size: 2px;
  color: #409eff;
  cursor: pointer;
}

.user_pic {
  /* border: 1px solid black; */
  height: 100px;
  width: 100px;
  /* position: relative; */
  /* margin-top:-50px;
    margin-left:50px; */
  /* border-radius: 50rem; */
  /* background-image:url(../../assets/img.jpg); */
}

.center {
  height: 100%;
  /* border: 1px solid black; */
  width: 90%;
  margin-left: 5%;
}

span {
  font-size: 12px;
  font-family: sans-serif;
  color: grey;
}

.img1 {
  height: 100%;
  width: 100%;
  border-radius: 50rem;
}

.file {
  position: absolute;
  margin-top: -100px;
  width: 100px;
  height: 100px;
  border-radius: 50rem;
  /* border: 1px solid red; */
  opacity: 0;
}
</style>