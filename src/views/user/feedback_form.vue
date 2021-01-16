<template>
  <div class="center">
    <!-- <el-Icon type="arrow-left" /> -->
    <a-page-header
      class="header"
      title="用户中心 ｜ 我的反馈"
      @back=" () => { this.$router.push({ path: '../user_first/first' }); } "
    />
    <div class="container">
      <div class="form">
        <el-form ref="form" :model="form" label-width="250px">
          <br />
          <el-form-item label="选择软件">
            <el-select v-model="form.ruanjian" placeholder="请选择" class="op">
      
              <el-option key="wz" label="王者荣耀" value="王者荣耀"></el-option>
              <el-option key="kf" label="原神" value="原神"></el-option>
               <el-option key="yx" label="英雄联盟" value="英雄联盟"></el-option>
                <el-option key="hs" label="皇室战争" value="皇室战争"></el-option>
                 <el-option key="xy" label="校园一卡通" value="校园一卡通"></el-option>
                 <el-option key="qm" label="骑马与砍杀" value="骑马与砍杀"></el-option>
               
            </el-select>
          </el-form-item>

          <el-form-item label="问题类型">
            <el-select v-model="form.type" placeholder="请选择" class="op">
              <el-option key="hp" label="黑屏" value="黑屏"></el-option>
              <el-option key="kd" label="卡顿" value="卡顿"></el-option>
              <el-option key="sj" label="升级失败" value="升级失败"></el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="请简要描述问题">
            <el-input v-model="form.jianyao" class="input"></el-input>
          </el-form-item>

          <el-form-item label="详细描述">
            <el-input
              type="textarea"
              rows="5"
              v-model="form.desc"
              class="input"
              placeholder="友善，精确的问题更快得到解答"
            ></el-input>
          </el-form-item>

          <el-form-item label="上传附件：">
            <el-button class="file_button" value="上传附件"
              >上传附件
            </el-button>
            <input
              type="file"
              @change="onSubmit"
              class=""
              name="file"
              id="notshow"
            />
            附件大小不超过3M
          </el-form-item>

          <el-form-item label="手机号">
            <el-input
              v-model="form.phonenum"
              class="input"
              placeholder="用于及时联系"
            ></el-input>
          </el-form-item>

          <el-form-item label="邮箱号">
            <el-input
              v-model="form.email"
              class="input"
              placeholder="用于及时联系"
            ></el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="Submit" class="but"
              >提交</el-button
            >
            <el-button class="but" @click="cancle">取消</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
import store from '../../store'
export default {
  name: "feedback_form",
  data() {
    return {
      
      form: {
        ruanjian: "",
        type: "",
        jianyao: "",
        desc: "",
        phonenum: "",
        email: "",
        file_url:'',
      },
      // 得到从后端传来的地址
      file_url:''
    };
  },
  methods: {
    cancle(){
        this.form.jianyao = '',
        this.form.desc = '',
        this.form.type = '',
        this.form.ruanjian = ''
        this.form.phonenum = ''
        this.form.email = ''
        this.file_url = ''
    },

    Submit() {
      console.log('上传'+this.file_url)
      // alert(sessionStorage.getItem("token"));
      // console.log(this.form)
      this.axios({
        method: "post",
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
        url:store.state.Baseurl+":8080/feedback",
        params: {
          briefDescribe: this.form.jianyao,
          declareDescribe: this.form.desc,
          questionType: this.form.type,
          softwareName: this.form.ruanjian,
          phone: this.form.phonenum,
          email: this.form.email,
          uploadFile:this.file_url,
          
        },
      })
        .then((res) => {
          console.log(res);
          this.$message.success("提交成功");
          this.form.jianyao = '',
          this.form.desc = '',
          this.form.type = '',
          this.form.ruanjian = ''
          this.form.phonenum = ''
          this.form.email = ''
          this.file_url = ''
        })
        .catch((err) => {
          console.log(err);
          this.$router.push({ path:'/user_first/four'})
          // this.$message.error("提交失败");
          
        });
    },

    onSubmit(e) {
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
            this.file_url = response.data.result;
            this.$message.success('上传文件成功！');
            // console.log('filr'+this.file_url)
          })
    },
  },
};
</script>

<style scoped>
#notshow {
  /* display: none; */
  border: 1px solid black;
  height: 30px;
  width: 100px;
  margin-left: -100px;
  opacity: 0;
}

#notshow:hover {
  cursor: pointer;
  background-color: #c6e2ff;
}

.but {
  width: 100px;
  height: 40px;
  /* line-height: 30px; */
}
input {
  height: 30px;
  width: 200px;
}

form {
  /* border: 1px solid black; */
  width: 700px;
}

.container {
  border: 1px solid white;
  /* height: 500px; */
  border-radius: 10px;
  width:90%;
  margin-left: 5%;
  background: #fff;
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

.el-form{
  width: 800px;
}

</style>