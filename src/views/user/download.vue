<template>
  <div class="center">

    <!-- 文章标题 -->
    <div class="title">
      {{ title }}
    </div>

<!-- 发布时间和发布人员 -->
    <span class="time"
      ><i class="el-icon-time"></i> &emsp;{{ time }}
      <i class="el-icon-edit"></i> &emsp;{{ editor }}
    </span>

<!-- 摘要 -->
    <div class="summery">摘要： {{ summery }}</div>

    <!-- 解析后端传来的富文本问题 -->
    <div class="content">
      <div class="text">
        <span></span>
        <div class="content_text_content">
          <!-- {{ version_mesg }} -->
          <p v-html="version_mesg">{{version_mesg}}</p>
          <!-- <pre>{{version_mesg}}</pre> -->
        </div>
      </div>
<!-- 
      <div class="solution">
        <span>二、常见问题解答区</span>
        <div class="content_solution">
           <p v-html="solution">{{solution}}</p>
        </div>
      </div> -->

      <div class="version">
        <span>下载地址:</span>
        <div class="content_version">
            <!-- 版本下载地址按下按钮请求后台的版本信息 -->
          <el-table :data="tableData4"  style="width:100%">
            <el-table-column prop="system" label="适用系统" width="">
            </el-table-column>

            <el-table-column fixed="right" label="下载地址" width="">
              <template scope="">
                <el-button
                  type="text"
                  size="small"
                >
                 <a :href=" downloadurl"> 下载 </a>
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          <!-- windows64/32: <p class="upload" @click="upload">下载</p> -->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// 引入全局变量 将前面的标题信息传入后台获取文章信息
import store from "../../store";
// var data = store.state.data
console.log(store.state.data);

export default {
  name: "download",
  data() {
    return {
        tableData4:[{
            system:'window64/windows32'

        },],
      downloadurl:'',
      title:'',
      summery:'',
      time:'',
      editor:'',
      version_mesg:'',
      // solution:''
    };
  },

  methods: {


  },

  mounted(){
       console.log('title:'+store.state.data)
      this.axios({
          url:store.state.Baseurl+":8080/edition/"+store.state.data,
          headers:{
              Authorization: sessionStorage.getItem("token"),
          },
          params:{
              title:store.state.data
          }
      }).then(res=>{
          console.log(res)
          //这里不想要数组
          // console.log(res.result[0].title)
           this.title = res.data.result.title
           this.time = res.data.result.time
            this.editor = res.data.result.username
           this.summery = res.data.result.remark
          //  this.solution = res.data.result.solution
           this.version_mesg = res.data.result.eddescribe 
           this.downloadurl = res.data.result.fileLink
      }).catch(err=>{
          console.log(err)
          this.$router.push({ path:'/user_first/four'})
      })
  }
};
</script>

<style scoped>

/* pre{
     font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "\5FAE\8F6F\96C5\9ED1", Arial, sans-serif;
  line-height: 28px;
  font-size: 16px;
  white-space: pre-line;
  margin: 0;
} */
.content {
  height: 80%;
  width: 100%;
  /* border: 1px solid yellow; */
}



.content_text_content {
  /* height: 80%; */
  /* border: 1px solid green; */

  width: 90%;
  margin-left: 5%;
}



.content_version {
  /* height: 80%; */
  /* border: 1px solid green; */
    /* margin-top:15px; */
  width: 90%;
  margin-left: 5%;
}



/* .content_solution {
  height: 80%;
  border: 1px solid green;

  width: 90%;
  margin-left: 5%;
} */

.title {
  /* border:1px solid black; */
  width: 100%;
  height: 10%;
  /* text-align: center; */
  line-height: 60px;
  font-weight: 700;
}
.time {
  font-size: 12px;
}
i {
  margin-left: 10px;
}
.summery {
  height: 5%;
  width: 100%;
  background-color: WhiteSmoke;
  line-height: 30px;
}

.center {
  height: 100%;
  /* border: 1px solid black; */
  width: 60%;
  margin-left: 20%;
}
</style>