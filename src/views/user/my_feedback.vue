<template>
  <div class="center">
    <!--面包屑导航区域-->
   <a-page-header
      class="header"
      title="用户中心 ｜ 我的反馈"
      @back=" () => { this.$router.push({ path: '../user_first/first' }); } "
    />

    <el-card >
        <!--搜索与添加区域-->
        <el-row :gutter="100" >
            <el-col :span='10'>
                <el-input placeholder="请输入内容"  v-model="id">
                    <el-button slot="append" icon="el-icon-search"></el-button>
                </el-input>
            </el-col>
            <el-col :span='10'>
                <router-link class='router' to='../user_first/feedback_form'>
                        <el-button type="primary" @click="addDialogVisible = true" icon="el-icon-plus">添加反馈</el-button>
                        </router-link>
                
            </el-col>
        </el-row>
    <el-table 
    :data="showTableData" stripe style="width: 100%" border class="biaodan"
      :header-cell-style="{ 'text-align': 'center' }"
        :cell-style="{ 'text-align': 'center' }">
      <el-table-column prop="questionType" label="反馈问题类型" ></el-table-column>
      <el-table-column prop="softwareName" label="软件名称" ></el-table-column>
      <!-- <el-table-column prop="briefDescribe" label="问题简述" ></el-table-column> -->
      <el-table-column prop="time" label="反馈时间" width="180px"></el-table-column>
      <el-table-column prop="isdeal" label="状态" width="150px">
        <template slot-scope="scope">
          <a-badge v-if="scope.row.isdeal === 1" status="error"  />
          <a-badge v-if="scope.row.isdeal === 2" status="warning"  />
          <a-badge v-if="scope.row.isdeal === 3" status="success"  />
          <font v-if="scope.row.isdeal === 1" color="red">暂未处理</font>
          <font v-else-if="scope.row.isdeal === 2" color="orange">正在处理</font>
          <font v-else-if="scope.row.isdeal === 3" color="green">已处理</font>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="问题ID" ></el-table-column>
       <el-table-column prop="solution" label="解决办法" ></el-table-column>
      <el-table-column fixed="right" label="操作" >
        <template slot-scope="scope">
          <a-popover placement="left">
              <template slot="content" >
                <a-descriptions  title="用户反馈详情" size="small" bordered>
                  <a-descriptions-item label="反馈问题类型" :span="1">
                    {{showTableData[scope.$index].questionType}}
                  </a-descriptions-item>
                  <a-descriptions-item label="软件名称" :span="2">
                    {{showTableData[scope.$index].softwareName}}
                  </a-descriptions-item>
                  
                  <a-descriptions-item label="反馈时间" :span="1">
                    {{showTableData[scope.$index].time}}
                  </a-descriptions-item>
                  <a-descriptions-item label="用户ID" :span="2">
                    {{showTableData[scope.$index].userId}}
                  </a-descriptions-item>
                  <a-descriptions-item label="事件状态" :span="3">
                    <a-badge v-if="scope.row.isdeal === 1" status="error"  />
                    <a-badge v-if="scope.row.isdeal === 2" status="warning"  />
                    <a-badge v-if="scope.row.isdeal === 3" status="success"  />
                    <font v-if="scope.row.isdeal === 1" color="red">暂未处理</font>
                    <font v-else-if="scope.row.isdeal === 2" color="orange">正在处理</font>
                    <font v-else-if="scope.row.isdeal === 3" color="green">已处理</font>
                  </a-descriptions-item>
                  <a-descriptions-item label="问题简述" :span="3">
                    {{showTableData[scope.$index].briefDescribe}}
                  </a-descriptions-item>
                  <a-descriptions-item label="详细反馈" :span="3">
                    {{showTableData[scope.$index].declareDescribe}}
                  </a-descriptions-item>
                </a-descriptions>
              </template >
              <el-button type="text" icon="el-icon-view" circle></el-button>
              
              <el-button @click="removeById(scope.row.id)" type="text" icon="el-icon-delete" circle></el-button>
              
              
              
                         
          </a-popover>
          <!-- <a-button type="primary" style="height: 30px;line-width: 50px;line-height: 30px;display: inline;margin-left: 10px;" @click="showDrawer">
            编辑
          </a-button> -->
          
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      class="pagination"
      background
      layout="prev, pager, next"
      :pager-count="5"
      :page-count="pagecount"
      @current-change="getTable"
    ></el-pagination>
    </el-card>
  </div>
</template>
        
<script>
import store from '../../store'
//存放获取到的数据数组
let showTableData = [
  {
    briefDescribe: "",
    dealUserId: "",
    declareDescribe: "",
    id: "",
    isdeal: "",
    questionType: "",
    softwareName: "",
    solution: "",
    time: "",
    uploadFile: "",
    userId: "",
  },
];
//用来代指页数
let pagecount = Number;
export default {
  methods: {
      //根据问题id删除反馈信息

    async removeById(id){
        //弹框询问是否删除反馈数据
        const confirmResult =await this.$confirm('此操作将永久删除该反馈, 是否继续?', 
        '提示', 
            {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }
        ).catch(err => err)
        //如果用户确认删除则返回为字符串confirm
        //如果用户取消删除则返回为字符串cancel
        //console.log(confirmResult)
        if(confirmResult !=='confirm'){
            return this.$message.info('已取消删除')
        }
        console.log(id)
        // const {data:res} = await this.$http.get('http://121.36.57.122:8080/feedBack/delete?id='+id)
        // console.log(res.code)
        // if(res.code != 200){
        //   return this.$message.error('删除用户失败!');
        // }

        // this.$message.success('删除用户成功!')
        // this.getAllData()

        this.axios({
            method:"DELETE",
            url:store.state.Baseurl+':8080/feedback/'+id,
            headers: {
          Authorization:
            sessionStorage.getItem("token")
        },
      }).then(
          
          this.$message.info('成功删除'),
          this.getAllData()
      )
        
    },
    //控制显示的方法
    showDrawer() {
      this.maskVisible = true;
    },
    onClose() {
      this.maskVisible = false;
    },
    postAllData(){
      this.axios({
        
      }).then((res)=>{
        console.log(res);
      })
    },
    //获取数据
    getAllData() {
      this.axios({
        method: "GET",
        url: this.getUrl(1, 100),
        headers: {
          Authorization:
           sessionStorage.getItem("token")
        },
      }).then((res) => {
        //实现反馈长度超出限制时用...表示 和 修改日期表现形式
        this.testTableData = res.data.result.records;
        for (let TableData of this.testTableData) {
          TableData.briefDescribe = TableData.briefDescribe
            .toString()
            .substr(0, [11])
            .concat("...");
          TableData.time = TableData.time.replace(/T/g, "-");
          TableData.questionType = "    ".concat(TableData.questionType);
          // for(let i = 0;i<TableData.declareDescribe.length/20;i++){
              // TableData.declareDescribe.substr(i,[(i+1)*20]).concat("<br />")
          // }
          console.log(TableData.softwareName + TableData.id)
        }
        //按照日期对反馈进行排序
        this.arrSortByTime(this.testTableData);
        console.log(this.testTableData.length);
        //计算page总数，定义每页放8个反馈
        this.pagecount =
          this.testTableData.length % 5=== 0
            ? this.testTableData.length / 5
            : (this.testTableData.length - (this.testTableData.length % 5)) /
                5 +
              1;
        console.log(this.pagecount);
    this.getTable(1);
      });
    },
    //排序方法
    arrSortByTime(arr) {
      //降序排序
      arr.sort(function (a, b) {
        if (a.time < b.time) {
          return 1;
        } else if (a.time > b.time) {
          return -1;
        } else {
          if (a.time < b.time) {
            return -1;
          } else if (a.time > b.time) {
            return 1;
          }
          return 0;
        }
      });
    },
    getTable(currentPage) {
      this.pagesize = 5;
      //通过当前页数和每页限制条数 从总数组上分割要显示的数组
      this.showTableData = this.testTableData.slice(
        (currentPage - 1) * this.pagesize,
        currentPage * this.pagesize
      );
      console.log(this.showTableData);
    },
    //获取数据参数的方法定义
    getUrl(currentPage, size) {
        //后端接口路径
      let url = store.state.Baseurl+":8080/feedback";
      url = url.concat(
        "?pageIndex=" + currentPage.toString() + "&size=" + size
      );
      console.log(url);

      return url;
    },
    
  },
  mounted() {
    //页面加载完成调用方法获取数据
    this.getAllData();
    // console.log(this.testTableData)
  },
  data() {
    return {
    
      showTableData,
      //根据数据进行page页数分页
      pagecount,
      id:'',
     
      formLabelWidth: "120px",
      visible: true,
      maskVisible: false,
      //获取反馈列表的参数对象
    };
  },
};
</script>
<style scoped>
.el-table{
  font-size: 12px;
}
.header {
  margin-left: -15px;
}
】 span {
  font-size: 12px;
  font-family: sans-serif;
  color: grey;
}
.center {
  width: 90%;
  margin-top: 10px;
  margin-left: 5%;
  height: 100%;
}
.pagination {
  text-align: center;
  /* position: absolute; */
  /* left: 50%; */
  /* bottom: 45px; */
  margin-top: 15px;
}
.el-breadcrumb{
    margin-bottom: 10px;
}
.biaodan{
    margin-top: 10px;
}
</style>
