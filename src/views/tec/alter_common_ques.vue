<template>
<div class="center">
    <!-- <el-Icon type="arrow-left" /> -->
    <a-page-header
      class="header"
      title="技术人员中心 ｜ 软件版本更新"
      @back=" () => { this.$router.push({ path: '../user_first/first' }); } "
    />
     <div class="text"> 
        <el-row class="warp">
            <el-col :span="24" class="warp-main">
                <el-form ref="infoForm" :model="infoForm" :rules="rules" label-width="120px">
                    <div class="input">
                    <el-form-item label="标题" prop="a_title" class='one'>
                        <el-input v-model="infoForm.a_title"></el-input>
                    </el-form-item>

                    <el-form-item label="摘要" prop="a_zhaiyao" class="one">
                        <el-input v-model="infoForm.a_zhaiyao"></el-input>
                    </el-form-item>

                     <el-form-item label="软件名称" prop="a_name" class="one">
                        <el-input v-model="infoForm.a_name"></el-input>
                    </el-form-item>

                     <el-form-item label="软件版本号" prop="a_version" class="one">
                        <el-input v-model="infoForm.a_version"></el-input>
                    </el-form-item>
                  </div>

                   
                    <el-form-item label="此版本信息">
                        <div class="edit_containerone">
                            <quill-editor v-model="infoForm.a_content" >
                            </quill-editor>
                        </div>
                    </el-form-item>
                    

                     <!-- <el-form-item label="常见问题解答">
                        <div class="edit_containertwo">
                            <quill-editor v-model="infoForm.solution">
                            </quill-editor>
                        </div>
                    </el-form-item> -->

                     <el-form-item label="上传此次版本">
                        <el-button class="button_style">点击上传文件</el-button>
                         <input type="file" name='file'  id="file" @change="uploadConfig" class="file">
                    </el-form-item>


                    <el-form-item>
                        <el-button type="primary" @click="onSubmit" class="button">提交</el-button>
                         <el-button type="primary" @click="cancle" class="button">取消</el-button>
                    </el-form-item>
                </el-form>


            </el-col>
        </el-row>
    </div>
</div>
</template>
<script>
import store from '../../store'
import { quillEditor } from 'vue-quill-editor' //调用编辑器
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
export default {
    data() {
        return {
            file_url:'',
            //      key_file:{},
            infoForm: {
                a_title: '',
                a_name:'',
                a_version:'',
                a_content:'',
                a_zhaiyao:'',
                // editorOption: {}
            },
            //表单验证
            rules: {
                a_title: [
                    {required: true, message: '请输入标题', trigger: 'blur'}
                ],
                 a_zhaiyao: [
                    {required: true, message: '请输入摘要', trigger: 'blur'}
                ],
                a_content: [
                    {required: true, message: '请输入详细内容', trigger: 'blur'}
                ],
                 a_name: [
                    {required: true, message: '输入修复的软件名称', trigger: 'blur'}
                ],
                 a_version: [
                    {required: true, message: '输入修复的软件版本号', trigger: 'blur'}
                ]
            },
        }
    },                
              
    methods: {   
        cancle(){
                this.infoForm.a_title = ''
                this.infoForm.a_content = ''
                this.infoForm.a_zhaiyao = ''
                this.infoForm.a_name = ''
                
                this.infoForm.title = ''
                this.infoForm.a_version = ''
                this.file_url = ''
        },

        //上传文件得到返回的服务器存储地址
        uploadConfig(e){
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
            this.$message.success("上传成功");
          })
        },

        onSubmit() {  
            console.log(this.infoForm)
             this.axios({
                 url:store.state.Baseurl+':8080/edition',
                 headers:{
                    'Authorization':sessionStorage.getItem("token")
                    },
                 method:'post',
                 params:{
                    eddescribe:this.infoForm.a_content,
                    remark:this.infoForm.a_zhaiyao,
                    softwareId:this.infoForm.a_name,
                   
                    title:this.infoForm.a_title,
                    versionNumber:this.infoForm.a_version,
                    fileLink:this.file_url
                 }
             }).then(res=>{
                 console.log(res)
                  this.$message.success('发布成功！');
                   this.infoForm.a_title = ''
                   this.infoForm.a_content = ''
                   this.infoForm.a_zhaiyao = ''
                   this.infoForm.a_name = ''
                  
                   this.infoForm.title = ''
                   this.infoForm.a_version = ''
                   this.file_url = ''
             }).catch(err=>{
                  console.log(err)
                  this.$router.push({ path:'/user_first/four'})
             })
            console.log(this.infoForm)
        }
    },
    components: {
        quillEditor
    }
}
</script>


<style scoped>

.file{
    opacity: 0;
    margin-left: -12%;
    cursor: pointer;
    width: 60px;
}


.one{
    position: relative;
    font-size: 14px;
    display: inline-block;
    width: 50%;
    /* border: 1px solid black; */
    /* float: left; */
}

.center{
    /* height: 100%; */
    /* border: 1px solid black; */
    width: 90%;
    margin-left:5%;
}

span{
    font-size: 12px;
    font-family: sans-serif;
    color: grey;
}
</style>