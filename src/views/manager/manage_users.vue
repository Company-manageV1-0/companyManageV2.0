<template>
  <div class="center">
    <a-page-header
      class="header"
      title="管理员中心 ｜ 管理用户"
      @back="
        () => {
          this.$router.push({ path: '../user_first/' });
        }
      "
    />

    <!-- 在这里写东西 -->
    <div class="search_text">
      <el-col span="7">
        <el-input
          type="text"
          id="usernameSearch"
          value="username_value"
          v-model="searchUsername"
          placeholder="请输入完整的用户名..."
        ></el-input>
      </el-col>
      <el-col span="1" class="search_bottom">
        <el-button @click="searchUser" type="primary">搜索</el-button>
      </el-col>
      <el-col span="4">
        <el-button @click="addUserVisible = true" type="primary"
          >添加</el-button
        >
      </el-col>
    </div>

    <div class="table_style">
      <el-table
        :data="
          tableData.slice((currentPage - 1) * pageSize, currentPage * pageSize)
        "
        :row-style="{ height: '25px' }"
        :header-cell-style="{ 'text-align': 'center' }"
        :cell-style="{ 'text-align': 'center' }"
        stripe
        style="width: 100%"
      >
        <el-table-column type="index" label="#"></el-table-column>
        <el-table-column label="用户名" prop="username" width="">
        </el-table-column>

        <el-table-column label="角色" prop="name" width=""> </el-table-column>
        <el-table-column label="性别" prop="sex" width=""> </el-table-column>
        <el-table-column label="联系方式" prop="phone" width="">
        </el-table-column>
        <el-table-column label="邮箱" prop="email" width="200">
        </el-table-column>
        <el-table-column label="用户ID" width="200px" prop="id">
        </el-table-column>
        <el-table-column label="操作" width="">
          <template slot-scope="scope">
            <el-button
              type="text"
              @click="
                handleCreate(
                  scope.row.username,
                  scope.row.name,
                  scope.row.sex,
                  scope.row.phone,
                  scope.row.email,
                  scope.row.id
                )
              "
              :append-to-body="true"
            >
              <i class="el-icon-edit"></i
            ></el-button>
            <el-button type="text" @click="delUser(scope.row.id)">
              <i class="el-icon-delete"></i
            ></el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="page">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[6]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="tableData.length"
        class="fy"
      >
      </el-pagination>
    </div>

    <el-dialog
      title="编辑"
      :visible.sync="dialogFormVisible"
      :data="currentUser"
    >
      <el-form :model="user_form" :rules="rules" ref="user_form">
        <el-form-item label="用户名" :label-width="formLabelWidth">
          <el-input v-model="user_form.username" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="性别" :label-width="formLabelWidth">
          <el-input
            v-model="user_form.sex"
            auto-complete="off"
            property=""
          ></el-input>
        </el-form-item>
        <el-form-item label="联系方式" :label-width="formLabelWidth">
          <el-input v-model="user_form.phone" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" :label-width="formLabelWidth">
          <el-input v-model="user_form.email" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色" :label-width="formLabelWidth">
          <el-input v-model="user_form.juese" auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="editData">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="添加用户" :visible.sync="addUserVisible">
      <el-form :model="user_form" :rules="rules" ref="user_form">
        <el-form-item label="用户名" :label-width="formLabelWidth">
          <el-input v-model="user_form.username" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="性别" :label-width="formLabelWidth">
          <el-input v-model="user_form.sex" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="联系方式" :label-width="formLabelWidth">
          <el-input v-model="user_form.phone" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" :label-width="formLabelWidth">
          <el-input v-model="user_form.email" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="密码" :label-width="formLabelWidth">
          <el-input v-model="user_form.password" auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addUserVisible = false">取 消</el-button>
        <el-button @click="addUser">确定</el-button>
      </div>
    </el-dialog>
    <el-dialog
      title="该用户的信息"
      :visible.sync="UserVisible"
      :data="currentUser"
    >
      <el-form :model="user_form" :rules="rules" ref="user_form">
        <el-form-item label="用户名" :label-width="formLabelWidth">
          <el-input
            v-model="currentUser.username"
            auto-complete="off"
          ></el-input>
        </el-form-item>

        <el-form-item label="性别" :label-width="formLabelWidth">
          <el-input
            v-model="currentUser.sex"
            auto-complete="off"
            property=""
          ></el-input>
        </el-form-item>
        <el-form-item label="联系方式" :label-width="formLabelWidth">
          <el-input v-model="currentUser.phone" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" :label-width="formLabelWidth">
          <el-input v-model="currentUser.email" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="注册时间" :label-width="formLabelWidth">
          <el-input
            v-model="currentUser.registerTime"
            auto-complete="off"
          ></el-input>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import store from '../../store'
// import { saveSubject } from "@/api/content";
export default {
  name: "manager_users",
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
      tableData: [],
      search: "",
      //   options: [],
      value: "",
      list: "",
      componentlist: [],
      statuslist: [],

      currentUser: [],
      total_username: null,
      total_id: null,
      total_roleId: 0,
      searchUsername: "",
      dialogTableVisible: false,
      dialogFormVisible: false,
      addUserVisible: false,
      UserVisible: false,
      // confirmDel: false,
      form: {
        name: "",
        region: "",
        date1: "",
        date2: "",
        delivery: false,
        type: [],
        resource: "",
        desc: "",
      },
      user_form: {
        user_index: "",
        username: "",
        remark: "",
        sex: "",
        phone: "",
        email: "",
        password: "",
        registerTime: "",
      },
      new_user: [],
      edit: {},
      rules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
        ],
        sex: [{ required: true, message: "请输入性别", trigger: "blur" }],
        phone: [{ required: true, message: "请输入联系方式", trigger: "blur" }],
        email: [{ required: true, message: "请输入邮箱", trigger: "blur" }],
        registerTime: [
          { required: true, message: "请输入注册时间", trigger: "blur" },
        ],
      },
      formLabelWidth: "120px",
      options: [
        {
          value: 1,
          label: "admin",
          id: 1,
        },
        {
          value: 2,
          label: "user",
          id: 2,
        },
        {
          value: 3,
          label: "programmer/校园一卡通",
          id: 3,
        },
        {
          value: 4,
          label: "programmer/王者荣耀",
          id: 4,
        },
        {
          value: 5,
          label: "programmer/原神",
          id: 5,
        },
        {
          value: 6,
          label: "programmer/英雄联盟",
          id: 6,
        },
        {
          value: 7,
          label: "programmer/皇室战争",
          id: 7,
        },
        {
          value: 8,
          label: "programmer/骑马与砍杀",
          id: 8,
        },
      ],
      role_value: "",
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
        url: store.state.Baseurl+":8080/user",
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
      }).then((res) => {
        console.log(res);
        console.log(res.data);
        this.tableData = res.data.result;
      });
    },
    // 搜索
    searchUser() {
      // alert("搜索用户")
      this.axios({
        method: "get",
        url:
          store.state.Baseurl+":8080/accurate-select/" +
          this.searchUsername,
        // params:{
        //     username: this.searchUsername
        // },
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
      }).then((res) => {
        console.log(res);
        console.log(res.data);
        this.currentUser = res.data.result;
      });
      this.UserVisible = true;
    },

    addUser() {
      this.axios({
        method: "post",
        url: store.state.Baseurl+":8080/user",
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
        params: {
          username: this.user_form.username,
          sex: this.user_form.sex,
          phone: this.user_form.phone,
          email: this.user_form.email,
          password: this.user_form.password,
        },
      })
        .then((res) => {
          console.log(res);
          alert("添加成功，请刷新界面查看");
        })
        .catch((err) => {
          console.log(err);
        });

      this.addUserVisible = false;
    },

    delUser(user_id) {
      // alert("确认删除？ \n 若不想删除，则按F5刷新此页面")

      this.axios({
        method: "delete",
        url: store.state.Baseurl+":8080/user/" + user_id,
        params: {
          id: user_id,
        },
        headers: {
          Authorization: sessionStorage.getItem("token"),
        },
      });
      this.$message.success("删除成功！");
    },

    edit_user() {
      var element = document.getElementById("user_duty");
      element.setAttribute();
    },

    handleCreate(data1, data2, data3, data4, data5,data6) {
      this.dialogFormVisible = true;
      console.log(data1);
      console.log(data2);
      console.log(data3);
      console.log(data4);
      console.log(data5);
      this.user_form.juese = data2;
      this.user_form.username = data1;
      this.user_form.phone = data4;
      this.user_form.sex = data3;
      this.user_form.email = data5;
      this.id = data6
    },

    editData() {
      this.axios({
        url: store.state.Baseurl+":8080/user",
        method: "put",
          headers: {
          Authorization: sessionStorage.getItem("token"),
        },
        params: {
        id:this.id,
        username: this.user_form.username,
        email: this.user_form.email,
        phone: this.user_form.phone,
        sex: this.user_form.sex,
        }
      }).then(res=>{
          console.log(res)
          this.$message.success('修改成功！')
              this.dialogFormVisible = false;
      }).catch(err=>{
          console.log(err)
          this.$message.error('修改失败！')
      })
    },
  },
};
</script>

<style scoped>
.el-table {
  font-size: 12px;
}
.page {
  position: absolute;
  top: 95%;
}
.table_style {
  /* border: 1px solid black; */
  height: 65%;
  /* background-color: white; */
  margin-top: 1%;
}
.center {
  height: 100%;
  /* border: 1px solid black; */
  width: 90%;
  margin-left: 5%;
}
table,
td {
  border: solid;
}
/*.user_head{*/
/*    padding-right: 50px;*/
/*}*/
.search_bottom {
  padding-right: 75px;
}
.user_data {
  padding-top: 50px;
}
.user_msg {
  padding-right: 50px;
}
.user_msg1 {
  padding-right: 10px;
}
.search_text {
  padding-top: 10px;
  padding-bottom: 60px;
}
.role_text {
  padding-left: 80px;
}
span {
  font-size: 12px;
  font-family: sans-serif;
  color: grey;
}
</style>