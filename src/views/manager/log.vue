<template>
  <div class="center">
    <a-page-header
      class="header"
      title="管理员中心 ｜ 日志"
      @back="
        () => {
          this.$router.push({ path: '../user_first/' });
        }
      "
    />
    <div class="top">
      <div class="block">
        <span class="demonstration"></span>
        <el-date-picker
          v-model="value1"
          type="datetimerange"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          :default-time="['12:00:00']"
        >
        </el-date-picker>
        <el-button type="primary" @click="dateSearch">搜索</el-button>
      </div>

      <div class="search_user">
        <el-col span="8">
          <el-input
            v-model="input_user"
            placeholder="请输入完整的用户名"
            class="input_style"
          ></el-input>
        </el-col>
        <el-button type="primary" @click="searchByUser()"
          >搜索</el-button
        >
      </div>
    </div>

    <div class="table_style">
      <el-table
        :data="
          logList.slice((currentPage - 1) * pageSize, currentPage * pageSize)
        "
        :row-style="{ height: '25px' }"
        :header-cell-style="{ 'text-align': 'center' }"
        :cell-style="{ 'text-align': 'center' }"
        stripe
        style="width: 100%"
      >
        <el-table-column type="index" label="#"></el-table-column>
        <el-table-column label="ID" prop="operId"></el-table-column>
        <el-table-column label="模式" prop="operModul"></el-table-column>
        <el-table-column label="类型" prop="operType"></el-table-column>
        <el-table-column label="详情" prop="operDesc"></el-table-column>
        <el-table-column label="用户" prop="operUserName"></el-table-column>
        <el-table-column label="IP" prop="operIp"></el-table-column>
        <el-table-column label="时间" prop="operCreateTime"></el-table-column>
      </el-table>
    </div>
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="currentPage"
      :page-sizes="[6]"
      :page-size="pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="logList.length"
      class="fy"
    >
    </el-pagination>
  </div>
</template>

<script>
import store from '../../store'
export default {
  name: "log",
  mounted() {
    this.queryuser();
  },
  data() {
    return {
      // 当前页
      currentPage: 1,
      // 每页多少条
      pageSize: 6,
      date: "",
     
      search: "",
      //   options: [],
      value: "",
      list: "",
      componentlist: [],
      statuslist: [],

      typeInput: "",
      input_user: "",
      logList: [],
      value1: "",
      currentPage1: 1,
      currentPage2: 5,
      currentPage3: 5,
      cuurentPage4: 4,
      page_index: 1,
    };
  },
  methods: {

    handleSizeChange(val) {
      this.pageSize = val;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
    },

    queryuser() {
      this.axios({
        method: "get",
        url: store.state.Baseurl+":8080/operlog ",
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
        // params:{
        //   startTime:,
        //   endTime:nowDate.getFullYear()+'-'+nowDate.getMonth() + 1+'-'+nowDate.getDate()+''+new Date().getHours()+':'+new Date().getMinutes()<10 ? '0'+new Date().getMinutes() : new Date().getMinutes()+':'+ new Date().getSeconds()<10 ? '0'+new Date().getSeconds() : new Date().getSeconds(),
        // }
      }).then((res) => {
        console.log(res);
        this.logList = res.data.result;
      });
    },

    dateSearch() {
      let time1 = new Date(
        +new Date(new Date(this.value1[0]).toJSON()) + 8 * 3600 * 1000
      )
        .toISOString()
        .replace(/T/g, " ")
        .replace(/\.[\d]{3}Z/, "");
      let time2 = new Date(
        +new Date(new Date(this.value1[1]).toJSON()) + 8 * 3600 * 1000
      )
        .toISOString()
        .replace(/T/g, " ")
        .replace(/\.[\d]{3}Z/, "");
      // alert(time1);
      // alert(time2);

      // alert(time);
      this.axios({
        method: "get",
        url: store.state.Baseurl+":8080/operlog",
        params: {
          startTime: time1,
          endTime: time2,
        },
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
      }).then((res) => {
        console.log(res);
        this.logList = res.data.result;
      });
    },
    

    searchByUser() {
      alert(this.input_user);
      this.axios({
        method: "get",
        url:
          store.state.Baseurl+":8080/operlog",
        params: {
          startTime: "2020-12-01 00:00:00",
          endTime: "2020-12-31 23:59:59",
          username:this.input_user,
        },
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
      }).then((res) => {
        console.log(res);
        this.logList = res.data.result;
      });
    },
  },
};
</script>
<style scoped>
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

.block {
  padding-bottom: 5px;
}

.search_user {
  /* border: 1px solid black; */
  /* padding-bottom: 5px; */
  width: 55%;
  float: left;
}

.top {
  /* border: 1px solid black; */
  width: 100%;
  height: 10%;
}

.block {
  /* border: 1px solid black; */
  float: right;
}

.table_style {
  /* border: 1px solid black; */
  height: 70%;
  width: 100%;
}

.page {
  position: absolute;
  margin-top: 95%;
}
.el-table {
  font-size: 12px;
}
</style>