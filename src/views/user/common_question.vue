<template>
  <div class="center">
    <a-page-header
      class="header"
      title="用户中心 ｜ 知识库"
      @back="
        () => {
          this.$router.push({ path: '../user_first/first' });
        }
      "
    />

    <div class="pic">
      <div class="search">
        <div class="search_input">
          <el-input
            v-model="mohuinput"
            placeholder="请输入内容进行搜索"
          ></el-input>
        </div>
        <div class="search_button">
          <el-button type="primary" icon="search" @click="search"
            ><i class="el-icon-search"></i>搜索</el-button
          >
        </div>
      </div>
    </div>

    <div class="big">
      <h1>公共社区</h1>
   <el-table
    :data="tableData.slice((currentPage-1)*pageSize,currentPage*pageSize)"
    stripe
    :row-style="{height:'15px'}"
    style="width: 100%"
     >
    <el-table-column
      prop="title"
      label="版本发布"
      width="">
    </el-table-column>

    <el-table-column
      fixed="right"
      label=""
      width="">

      <template scope="scope">
        <el-button
          @click="detail(scope.row.title)"
          type="text"
          size="small">
          查看详情
        </el-button>
         </template>
    </el-table-column> 
  </el-table>
  </div>
  <div class="page">
 <el-pagination
        :hide-on-single-page="value"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="pageSize"
        :page-sizes="[7]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="tableData.length" class="fy">
</el-pagination>
 </div>
  </div>
</template>

<script>
import store from '../../store'
export default {
  data() {
    return {
         currentPage: 1,
      // 每页多少条
       pageSize: 7,
      date: '',
      // tableData: [],
      // search: '',
      // options: [],
      value:false,
      // list: '',
      componentlist: [],
      statuslist: [],
      list: [],
      tableData: [],
      mohuinput: "",
    };
  },
  methods: {
    detail(data) {
      console.log(data);
      this.$store.commit("download", data);
      this.$router.push({ path: "/user_first/download" });
    },

    //根据搜索框搜索相关信息 全部信息就不输入
    search() {
      if (this.mohuinput == "") {
        this.axios({
          url: store.state.Baseurl+":8080/edition",
          headers: {
            Authorization: sessionStorage.getItem("token"),
            //  localStorage.getItem('token')
          },
        })
          .then((res) => {
            console.log(res);
            this.list = res.data.result;
            // console.log("list" + this.list);
            this.tableData = this.list;
            //  console.log("re"+res.data.result)
            //  alert(+res.data.result[0].username)
          })
          .catch((err) => {
            console.log(err);
            this.$router.push({ path: "/user_first/four" });
          });
      } else {
        this.axios({
          url:
            store.state.Baseurl+":8080/edition/vague-select/" + this.mohuinput,
          headers: {
            Authorization: sessionStorage.getItem("token"),
            //  localStorage.getItem('token')
          },
          params: {
            title: this.mohuinput,
          },
        })
          .then((res) => {
            console.log(res);
            this.list = res.data.result;
            // console.log("list" + this.list);
            this.tableData = this.list;
            //  console.log("re"+res.data.result)
            //  alert(+res.data.result[0].username)
          })
          .catch((err) => {
            console.log(err);
            this.$message.error("err.response.message！");
            this.$router.push({ path:'/user_first/four'})
          });
      }
    },
  },

  //进入页面显示全部文章
  mounted() {
    this.axios({
      url: store.state.Baseurl+":8080/edition",
      headers: {
        Authorization: sessionStorage.getItem("token"),
        //  localStorage.getItem('token')
      },
    })
      .then((res) => {
        console.log(res);
        this.list = res.data.result;
        // console.log("list" + this.list);
        this.tableData = this.list;
        //  console.log("re"+res.data.result)
        //  alert(+res.data.result[0].username)
      })
      .catch((err) => {
        console.log(err);
        this.$router.push({ path: "/user_first/four" });
      });
  },
};
</script>

<style scoped>

.page{
  position:absolute;
  top: 95%;
}
a {
  text-decoration: none;
  color: black;
  font-size: 14px;
  /* margin-left:30%; */
}

a:hover {
  color: #409eff;
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

.big {
  width: 100%;
  height: 72%;
  /* margin-top:; */
  /* border: 1px solid black; */
  background-color: white;
}



.pic {
  /* border: 1px solid black; */
  width: 100%;
  height: 8%;
}

.search {
  float: left;
  /* border: 1px solid black; */
  height: 90%;
  width: 50%;
  margin-left: 25%;
}
.search_input {
  float: left;
  /* border: 1px solid black; */
  height: 100%;
  width: 80%;
}
.search_button {
  float: right;
  /* border: 1px solid black; */
  height: 100%;
  width: 20%;
}
.conone {
  height: 100%;
}
.el-table{
  font-size: 12px;
}
</style>