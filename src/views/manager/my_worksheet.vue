<template>
<div class="center">
   <a-page-header
      class="header"
      title="管理员中心 ｜ 我的工单"
      @back="
        () => {
          this.$router.push({ path: '../user_first/' });
        }
      "
    />

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
      <el-table-column prop="questionType" label="反馈问题类型" width="110"></el-table-column>
      <el-table-column prop="softwareName" label="软件名称" width="110"></el-table-column>
      <el-table-column prop="briefDescribe" label="问题简述" width="300"></el-table-column>
      <el-table-column prop="time" label="反馈时间" width="200"></el-table-column>
      <el-table-column prop="isdeal" label="状态" width="150">
         <template slot-scope="scope">
          <a-badge v-if="scope.row.isdeal === 1" status="error"  />
          <a-badge v-if="scope.row.isdeal === 2" status="warning"  />
          <a-badge v-if="scope.row.isdeal === 3" status="success"  />
          <font v-if="scope.row.isdeal === 1" color="red">暂未处理</font>
          <font v-else-if="scope.row.isdeal === 2" color="orange">正在处理</font>
          <font v-else-if="scope.row.isdeal === 3" color="green">已处理</font>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="ID" width="300"></el-table-column>
      
    <el-table-column
      fixed="right"
      label="操作"
      width="">

      <template scope="scope">
        <el-button
          @click.native.prevent="deleteRow(scope.row.id)"
          type="text"
          size="small">
        <i class="el-icon-delete"></i>
        </el-button>

        <el-button
        @click="xianshi(scope.row.id)"
          type="text"
          size="small">
         <i class="el-icon-setting"></i>
        </el-button>

      </template>
    </el-table-column>
      </el-table>
    </div>


    <div class="page">
        <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="currentPage"
      :page-sizes="[8]"
      :page-size="pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="tableData.length"
      class="fy"
    >
    </el-pagination>
    </div>

    <el-dialog class="dialog2" title="分配工单" :visible.sync="add_group">
<el-form :model="ruleForm" >

<el-form-item label="选择状态">
            <el-select v-model="ruleForm.type" placeholder="请选择" class="op">
              <el-option key="hp" label="已处理" value="已处理"></el-option>
              <el-option key="kd" label="未处理" value="未处理"></el-option>
              <el-option key="sj" label="处理中" value="处理中"></el-option>
            </el-select>
</el-form-item>

<el-form-item label="选择技术人员" prop="form.id">
            <el-select v-model="ruleForm.jishurenyuan" placeholder="请选择" class="op">
              <!-- <el-option key="hp" label="已处理" value="已处理"></el-option>
              <el-option key="kd" label="未处理" value="未处理"></el-option>
              <el-option key="sj" label="处理中" value="处理中"></el-option> -->
              <el-option
                    v-for="item in typeList"
                    :key="item.id"
                    :label="item.username"
                    :value="item.id">
             </el-option>
            </el-select>
</el-form-item>
<el-button @click="tec">点击查看当前可分配的技术人员</el-button>
</el-form>

  <div slot="footer" class="dialog-footer">
    <el-button @click="add_group_sure" class="sure">提交</el-button>
    <el-button @click="add_group = false" class="cancel">取消</el-button>
  </div>
</el-dialog>

</div>
</template>

<script>
import store from '../../store'
export default {
  data()
  {
    return{
      add_group:false,
      fankuixinxideid:'',
      dealid:'',
         // 当前页
      tableData:[],
      currentPage: 1,
      // 每页多少条
      pageSize:8,
      date: "",
     
      search: "",
      //   options: [],
      value: "",
      list: "",
      componentlist: [],
      statuslist: [],
      ruleForm:{
        jishurenyuan:'',
        type:''
      },
      typeList:[],
      // typeList:[{id:1,username:'女装'},{id:2,username:'男装'},{id:3,username:'童装'}],
    }
  },

    mounted(){
    //得到所有反馈信息
     this.axios({
      url:store.state.Baseurl+':8080/feedback/get-all',
      headers:{
                 'Authorization':sessionStorage.getItem("token")
                //  localStorage.getItem('token')
             },
     params:{
       pageIndex:1,
       size:1000,
     }
    }).then(res=>{
        console.log(res)
        this.tableData = res.data.result.records
        console.log(this,this.tableData)
    }).catch(err=>{
        console.log(err)
    })
  },


  methods:{

    // 查看当前可分配的技术人员
    tec(){
      this.axios({
      url:store.state.Baseurl+':8080/feedback/'+this.fankuixinxideid,
      headers:{
                 'Authorization':sessionStorage.getItem("token")
                //  localStorage.getItem('token')
             },
     params:{
       feedBackId:this.fankuixinxideid
     }
    }).then(res=>{
        console.log(res)
        this.typeList = res.data.result
    }).catch(err=>{
        console.log(err)
    })
    },

     handleSizeChange(val) {
      this.pageSize = val;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
    },


      deleteRow(data){
       this.axios({
            method:"DELETE",
            url:store.state.Baseurl+':8080/feedback/'+data,
            headers: {
          Authorization:
            sessionStorage.getItem("token")
        },
        params:{
          id:data
        }
      }).then(res=>{
        console.log(res)
          this.$message.success('成功删除')
      }).catch(err=>{
        console.log(err)
      })
    },

    xianshi(data){
      this.add_group = true,
      this.fankuixinxideid = data
    },



    add_group_sure(){
      if(this.ruleForm.jishurenyuan == ''){
        alert('请选择技术人员')
      }{
         var flag = 0
      if(this.ruleForm.type == '已处理'){
        flag = 3
      }
      if(this.ruleForm.type == '未处理'){
        flag = 1
      }
       if(this.ruleForm.type == '处理中'){
        flag = 2
      }

      // 得到选择的技术人员的id

       this.axios({
        url:store.state.Baseurl+":8080/feedback",
        method:'put',
        headers:{
                 'Authorization':sessionStorage.getItem("token")
                //  localStorage.getItem('token')
             },
          params:{
              id:this.fankuixinxideid,
              dealUserId:this.ruleForm.jishurenyuan,
              isdeal:flag
          }
    }).then(res=>{
      console.log(res)
      this.$message.success('分配成功！')
      this.add_group = false
    }).catch(err=>{
      console.log(err)
    })
      }
    }

    // 处理此工单
    // dialogFormVisibleshow(data){
    //    this.axios({
    //    headers:{
    //              'Authorization':sessionStorage.getItem("token")
    //             //  localStorage.getItem('token')
    //          },
    // }).then(res=>{
    //   console.log(res)
    // }).catch(err=>{
    //   console.log(err)
    // })
    // }

  },
}
</script>

<style scoped>
.page{
  margin-top: 1%;
}
.table_style{
  /* border: 1px solid black; */
  height: 80%;
  width: 100%;
  margin-top: 2%;
}
.center{
    height: 100%;
    /* border: 1px solid black; */
    width: 90%;
    margin-left:5%;
}
.el-table{
  font-size: 12px;
}
</style>