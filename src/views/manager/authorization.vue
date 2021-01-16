
<template>
<div class="center">
  <br/>
   <a-page-header
      class="header"
      title="管理员中心 ｜ 权限管理"
      @back=" () => { this.$router.push({ path: '../user_first/first' }); } "
    />

   

    <!-- <el-button  @click="add_group_" class="add_group">增加角色</el-button> -->
    <div class="main">
      <!-- <el-table
    :data="tableData4"
    border
    style="width: 100%"
    height="100%">

     @selection-change="handleSelectionChange">
    <el-table-column
      type="selection"
      width="40">
    </el-table-column>

    <el-table-column
      fixed
      prop="name"
      label="角色"
      width="250">
    </el-table-column>

    <el-table-column
      prop="comment"
      label="角色描述"
      width="300">
    </el-table-column>

    <el-table-column
      prop="remark"
      label="备注"
      width="300">
    </el-table-column>

    <el-table-column
      fixed="right"
      label="操作"
      width="">

      <template scope="scope">
        <el-button
          @click.native.prevent="deleteRow(scope.$index,tableData4,scope.row.name)"
          type="text"
          size="small">
        <i class="el-icon-delete">删除</i>
        </el-button>

      
        <el-button
        @click="dialogFormVisibleshow(scope.row.name)"
          type="text"
          size="small">
         <i class="el-icon-setting">功能管理</i>
        </el-button>

       
      </template>
    </el-table-column>
  </el-table> -->

  <el-table
    :data="tableData4.slice((currentPage-1)*pageSize,currentPage*pageSize)"
    stripe
    :row-style="{height:'15px'}"
    :header-cell-style="{'text-align':'center'}"
    :cell-style="{'text-align':'center'}"
    style="width: 100%"
     >
    <el-table-column
      prop="name"
      label="角色"
      width="200">
    </el-table-column>
    <el-table-column
      prop="comment"
      label="角色描述"
      width="300">
    </el-table-column>
    <el-table-column
      prop="remark"
      label="备注"
      width="150">
    </el-table-column>

    <el-table-column
      prop="id"
      label="角色ID"
      width="300">
    </el-table-column>

    <el-table-column
      fixed="right"
      label="操作"
      width="">

      <template scope="scope">
        <el-button
          @click.native.prevent="deleteRow(scope.$index,tableData4,scope.row.id)"
          type="text"
          size="small">
        <i class="el-icon-delete"></i>
        </el-button>

        <el-button
        @click="dialogFormVisibleshow(scope.row.id)"
          type="text"
          size="small">
         <i class="el-icon-setting"></i>
        </el-button>

          <el-button
          @click="add_group_"
          type="text"
          size="small">
         <i class="el-icon-plus"></i>
        </el-button>
      </template>
    </el-table-column>
  </el-table>
<div>
 <!-- <el-switch v-model="value">
 </el-switch> -->
 <br/>
 <!-- 只有一页时隐藏页码 -->
 <div class="page">
 <el-pagination
     
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="pageSize"
        :page-sizes="[11]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="tableData4.length" class="fy">
</el-pagination>
 </div>
</div>
</div>

<!-- 增加角色弹出框 -->
<el-dialog class="dialog2" title="增加角色"  :visible.sync="add_group">
<el-form :model="ruleForm" >

<el-form-item label="角色名称:" >
    <el-input v-model="ruleForm.name"></el-input>
  </el-form-item>

  <el-form-item label="角色描述:" >
    <el-input v-model="ruleForm.describe"></el-input>
  </el-form-item>

  <el-form-item label="备注:">
    <el-input v-model="ruleForm.remark"></el-input>
  </el-form-item>
</el-form>

  <div slot="footer" class="dialog-footer">
    <el-button @click="add_group_sure" class="sure">确定</el-button>
    <el-button @click="add_group = false" class="cancel">取消</el-button>
  </div>
</el-dialog>

<!-- 权限选择弹出框 -->
<el-dialog class="dialog" title="设置功能权限" :visible.sync="dialogFormVisible">
<div class="border">
  <form action="" class="load-indicator main-form form-ajax" id="managePrivForm" method="post" target="hiddenwin">
    <table class="table table-hover table-striped table-bordered" id="privList">
      <thead>
        <tr class="text-center">
          <th class="thWidth">模块</th>
          <th colspan="2">方法</th>
        </tr>
      </thead>
      <tbody>
        <tr class="even">
              <th class="text-middle text-right thWidth">
                <div class="checkbox-primary checkbox-inline checkbox-right check-all">
                  <input type="checkbox" id="allCheckerindex" @click="allCheckerindex">
                  <label class="text-right">首页</label>
                </div>
              </th>
              <td id="index" class="pv-10px" colspan="2">
                    <div class="group-item">
                  <input type="checkbox"  name="bianli" id="fi" value="0"> <label for="actions[index]index">首页</label>
                   </div>
              </td>
        </tr>

         <tr class="even">
              <th class="text-middle text-right thWidth">
                <div class="checkbox-primary checkbox-inline checkbox-right check-all">
                  <input type="checkbox"  value="15" id="fi15" @click="usersall">
                  <label class="text-right" style="color:#409EFF" >用户中心</label>
                </div>
              </th>
            
        </tr>

        <tr class=" bg-gray">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckmyfeedback" @click="allCheckmyfeedback">
            <label class="text-right" >我的反馈</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli"  value="1" id="fi1"> 
            <label>提交我的反馈</label></div>          </div>

            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="2" id="fi2"> 
            <label>删除我的反馈</label></div>
            </div>
            </td>
      </tr>

        <tr class=" even" >
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckapply">
            <label class="text-right">申请界面</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="3" id="fi3">
             <label>提交申请</label></div> </div>
            </td>
      </tr>

       <tr class=" bg-gray">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allChecmyinform">
            <label class="text-right" >我的资料</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="4" id="fi4"> 
            <label >修改我的资料</label></div> </div>
            </td>
      </tr>

      
       <tr class="even">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckversion">
            <label class="text-right" >版本库</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="5" id="fi5"> 
            <label >下载版本库</label></div></div>
            </td>
      </tr>

       <tr class="even">
              <th class="text-middle text-right thWidth">
                <div class="checkbox-primary checkbox-inline checkbox-right check-all">
                  <input type="checkbox"  value="17" id="fi17" @click="manager">
                  <label class="text-right" style="color:#409EFF">管理员中心</label>
                </div>
              </th>
             
        </tr>

      <tr class="even">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckfenpei" @click="fenpei">
            <label class="text-right" >分配工单</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"   name="bianli" value="6" id="fi6"> 
             <label >分配我的工单</label></div></div>
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="7" id="fi7">
             <label >删除工单</label></div></div>
            </td>
      </tr>

      <tr class="bg-grey">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckmanage" @click="guanli">
            <label class="text-right" >管理用户</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="8" id="fi8">
            <label >增加用户</label></div></div>

            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="9" id="fi9"> 
            <label >删除用户</label></div></div>
             <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"   name="bianli" value="10" id="fi10">
            <label >修改用户角色</label></div></div>
            </td>
      </tr>

       <tr class="bg-grey">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allChecklog">
            <label class="text-right" >日志统计</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox" name="bianli" value="11" id="fi11">
             <label >查看日志</label></div></div>
            </td>
      </tr>

      <tr class="bg-grey" >
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckchuli">
            <label class="text-right" >处理申请</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="12" id="fi12"> 
            <label >处理申请</label></div> </div>
            </td>
      </tr>

       <tr class="bg-grey">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" value="16" id="fi16" @click="jishu">
            <label class="text-right"  style="color:#409EFF">技术人员中心</label>
          </div>
        </th>
      </tr>

        <tr class="bg-grey">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckadd">
            <label class="text-right" >增加版本库</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="13" id="fi13"> 
            <label >提交最新版本信息</label></div> </div>
            </td>
      </tr>

      <tr class="bg-grey">
        <th class="text-middle text-right thWidth">
          <div class="checkbox-primary checkbox-inline checkbox-right check-all">
            <input type="checkbox" id="allCheckfeeback">
            <label class="text-right" >处理反馈</label>
          </div>
        </th>
            <td id="testreport" class="pv-10px" colspan="2">
            <div class="group-item">
            <div class="checkbox-primary checkbox-inline"><input type="checkbox"  name="bianli" value="14" id="fi14"> 
            <label >处理反馈</label></div> </div>
            </td>
      </tr>

      </tbody>
    </table>
  </form>
  

</div>  

  <div slot="footer" class="dialog-footer">
    <el-button @click="dialogFormVisible_sure" class="sure" >确定</el-button>
    <el-button type="primary" @click="dialogFormVisible = false" class="cancel">取消</el-button>
  </div>

</el-dialog>

</div>
</template>

<script>
import store from '../../store'
// var i = 0;
import $ from  'jquery'
    
  export default {
    data() {

      return {
      
        // 当前页
      currentPage: 1,
      // 每页多少条
       pageSize: 11,
       date: '',
      // tableData: [],
      search: '',
      // options: [],
      
      // list: '',
      componentlist: [],
      statuslist: [],
        // value:false,
        ruleForm:{
          name:'',
          describe:'',
          remark:'',
        },
        character:'',
        string:[],
        list:[],

        tableData4:[],

        dialogFormVisible:false,
        add_group:false,
       
      }
    },

    // 获取后端所有的角色
     mounted(){
        this.axios({
          url:store.state.Baseurl+':8080/role',
          headers:{
                 'Authorization':sessionStorage.getItem("token")
                //  localStorage.getItem('token')
             },
        }).then(res=>{
           console.log(res);
           
           this.list = res.data.result;
         
            // console.log("list" + this.list);
           this.tableData4 = this.list
           
          //  console.log("re"+res.data.result)
          //  alert(+res.data.result[0].username)

          
        }).catch(err=>{
            console.log(err);
        });
       },


    methods: {
    
    handleCurrentChange(val) {
      this.currentPage = val;
    },

    //这里的功能是 每一栏的全选按钮，并且控制导航栏的显示和隐藏
    allCheckerindex(){
      var a = document.getElementById('allCheckerindex')
      if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='0']").attr('checked','true');
      }else{
          $("input:checkbox[value='0']").attr('checked',false);
      }
    },

    usersall(){
      var a = document.getElementById('fi15')
      if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='1']").attr('checked','true');
        $("input:checkbox[value='2']").attr('checked','true');
        $("input:checkbox[value='3']").attr('checked','true');
        $("input:checkbox[value='4']").attr('checked','true');
        $("input:checkbox[value='5']").attr('checked','true');
      }else{
          $("input:checkbox[value='1']").attr('checked',false);
          $("input:checkbox[value='2']").attr('checked',false);
          $("input:checkbox[value='3']").attr('checked',false);
          $("input:checkbox[value='4']").attr('checked',false);
          $("input:checkbox[value='5']").attr('checked',false);
      }
    },

    allCheckmyfeedback(){
       var a = document.getElementById('allCheckmyfeedback')
       if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='1']").attr('checked','true');
         $("input:checkbox[value='2']").attr('checked','true');
      }else{
          $("input:checkbox[value='1']").attr('checked',false);
           $("input:checkbox[value='2']").attr('checked',false);
      }
    },

  manager(){
     var a = document.getElementById('fi17')
       if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='6']").attr('checked','true');
        $("input:checkbox[value='7']").attr('checked','true');
        $("input:checkbox[value='8']").attr('checked','true');
        $("input:checkbox[value='9']").attr('checked','true');
        $("input:checkbox[value='10']").attr('checked','true');
        $("input:checkbox[value='11']").attr('checked','true');
        $("input:checkbox[value='12']").attr('checked','true');
      }else{
          $("input:checkbox[value='6']").attr('checked',false);
          $("input:checkbox[value='7']").attr('checked',false);
          $("input:checkbox[value='8']").attr('checked',false);
          $("input:checkbox[value='9']").attr('checked',false);
          $("input:checkbox[value='10']").attr('checked',false);
          $("input:checkbox[value='11']").attr('checked',false);
          $("input:checkbox[value='12']").attr('checked',false);
      }
  },


  fenpei(){
    var a = document.getElementById('allCheckfenpei')
       if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='6']").attr('checked','true');
         $("input:checkbox[value='7']").attr('checked','true');
      }else{
          $("input:checkbox[value='6']").attr('checked',false);
          $("input:checkbox[value='7']").attr('checked',false);
      }
  },

  guanli(){
    var a = document.getElementById('allCheckmanage')
       if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='8']").attr('checked','true');
        $("input:checkbox[value='9']").attr('checked','true');
        $("input:checkbox[value='10']").attr('checked','true');
      }else{
        $("input:checkbox[value='8']").attr('checked',false);
        $("input:checkbox[value='9']").attr('checked',false);
        $("input:checkbox[value='10']").attr('checked',false);
      }
  },

jishu(){
  var a = document.getElementById('fi16')
   if(a.checked){
        console.log(a.checked)
        $("input:checkbox[value='13']").attr('checked','true');
        $("input:checkbox[value='14']").attr('checked','true');
      }else{
          $("input:checkbox[value='13']").attr('checked',false);
          $("input:checkbox[value='14']").attr('checked',false);
      }
},
      // 显示增加角色弹出框
      add_group_(){
        this.add_group = true;
      },



//将增加的角色信息传给后端
add_group_sure(){
  if(this.ruleForm.name != '' && this.ruleForm.describe!='' && this.ruleForm.remark != ''){
     this.axios({
          url:store.state.Baseurl+':8080/role',
          headers:{
              'Authorization':sessionStorage.getItem("token")
           },
           method:'post',
           params:{
             name:this.ruleForm.name,
             comment:this.ruleForm.describe,
             remark:this.ruleForm.remark
           }
        }).then(res=>{
          // console.log(this.ruleForm.name)
          // console.log(this.ruleForm.describe)
          console.log(res)
          this.$message.success('增加角色成功,请刷新页面查看！');
        }).catch(err=>{
          console.log(err);
        })
        this.add_group = false
  }else{
    this.add_group = false
    this.$message.error('请输入相关信息');
  }
},

//设置权限，获取角色权限
       dialogFormVisibleshow(data){
        // console.log(data)//  console.log(index,1)
        
        this.character = data;
        console.log( this.character)

          this.axios({
         
           url:store.state.Baseurl+':8080/role-premission/' + this.character,
           headers:{
              'Authorization':sessionStorage.getItem("token")
           },
           params:{
              id:this.character
           },

         }).then(res=>{
             //循环遍历复选框
          // let i = 0
           console.log(res)
            // if(res.result[0] == 1)
            //  console.log(res.data.result.length)
          // var len = res.result.length;
          
          // for(i;i<len;i++){
          //   if(res.result[i] == 1){
          //     console.log(i);
          //       $("input:checkbox[value='i']").attr('checked','true');
                
          //   }else{
          //       $("input:checkbox[value='i']").attr('checked','false');
          //   }
          // }
          
          // $("input:checkbox[value='1']").attr('checked','true');
          console.log(res.data.result[0])

          if(res.data.result[0] == '1'){
           
             $("input:checkbox[value='0']").attr('checked','true');
          }else{
           
             $("input:checkbox[value='0']").attr('checked',false);
          }
          if(res.data.result[1] == 1){
              console.log('is 1')
             $("input:checkbox[value='1']").attr('checked',true);
             console.log(document.getElementById('fi1').checked)
           }else{
         
             $("input:checkbox[value='1']").attr('checked',false);
          }
           if(res.data.result[2] == 1){
              console.log('is 1')
             $("input:checkbox[value='2']").attr('checked','true');
           }else{
             $("input:checkbox[value='2']").attr('checked',false);
          }
           if(res.data.result[3] == 1){
             $("input:checkbox[value='3']").attr('checked','true');
           }else{
             $("input:checkbox[value='3']").attr('checked',false);
          }
           if(res.data.result[4] == 1){
             $("input:checkbox[value='4']").attr('checked','true');
           }else{
             $("input:checkbox[value='4']").attr('checked',false);
          }
           if(res.data.result[5] == 1){
             $("input:checkbox[value='5']").attr('checked','true');
           }else{
             $("input:checkbox[value='5']").attr('checked',false);
          }
           if(res.data.result[6] == 1){
             
             $("input:checkbox[value='6']").attr('checked','true');
           }else{
            
             $("input:checkbox[value='6']").attr('checked',false);
          }
           if(res.data.result[7] == 1){
             $("input:checkbox[value='7']").attr('checked','true');
           }else{
            
             $("input:checkbox[value='7']").attr('checked',false);
          }
           if(res.data.result[8] == 1){
             $("input:checkbox[value='8']").attr('checked','true');
           }else{
             
             $("input:checkbox[value='8']").attr('checked',false);
          }
           if(res.data.result[9] == 1){
             $("input:checkbox[value='9']").attr('checked','true');
           }else{
             $("input:checkbox[value='9']").attr('checked',false);
          }
           if(res.data.result[10] == 1){
             $("input:checkbox[value='10']").attr('checked','true');
           }else{
             $("input:checkbox[value='10']").attr('checked',false);
          }
           if(res.data.result[11] == 1){
             $("input:checkbox[value='11']").attr('checked','true');
           }else{
             $("input:checkbox[value='11']").attr('checked',false);
          }
           if(res.data.result[12] == 1){
             $("input:checkbox[value='12']").attr('checked','true');
           }else{
             $("input:checkbox[value='12']").attr('checked',false);
          }
           if(res.data.result[13] == 1){
             $("input:checkbox[value='13']").attr('checked','true');
             console.log('131')
           }else{
             $("input:checkbox[value='13']").attr('checked',false);
             console.log('130')
          }if(res.data.result[14] == 1){
             console.log('141')
             $("input:checkbox[value='14']").attr('checked','true');
           }else{
              console.log('140')
             $("input:checkbox[value='14']").attr('checked',false); 
          }
         }).catch(err=>{
          console.log(err)
         })

         this.dialogFormVisible = true;
        // console.log('dadada')
        // 获取当前角色的权限
          
       },

//更改确定按钮：将更改权限传给后端
      dialogFormVisible_sure(){

         var A = '';var B ='';var C='';var D='';
         var E = '';var F = '';var G = '';var H = '';var I = '';var J = '';
         var K ='';var L ='';var M = '';var N = ''
         var W =''

        var a = document.getElementById('fi')
        console.log(a.checked);
        if(a.checked){
              A = '0';
        }else{
          A = '#';
        }

        var b = document.getElementById('fi1')
        // console.log(b.checked);
        if(b.checked){
           B = '1';
        }else{
           B = '#';
        }

        var c = document.getElementById('fi2')
        // console.log(c.checked);
        if(c.checked){
           C = '2';
          
        }else{
           C = '#';
        }

        var d = document.getElementById('fi3')
        // console.log(d.checked);
        if(d.checked){
             D= '3';
        }else{
           D= '#';
        }

       
        var e = document.getElementById('fi4')
        // console.log(e.checked);
        if(e.checked){
           E= '4';
        }else{
          E= '#';
        }

        var f = document.getElementById('fi5')
        // console.log(f.checked);
        if(f.checked){
          F= '5';
        }else{
           F= '#';
        }
       
       var g = document.getElementById('fi6')
        // console.log(g.checked);
        if(g.checked){
          G = '6'
        }else{
          G = '#'
        }
       
       var h = document.getElementById('fi7')
        // console.log(h.checked);
        if(h.checked){
          H = '7'
        }else{
          H = '#'
        }
       
       var i = document.getElementById('fi8')
        // console.log(i.checked);
        if(i.checked){
          I = '8'
        }else{
          I = '#'
        }
       
       var n = document.getElementById('fi9')
        // console.log(n.checked);
        if(n.checked){
           N = '9'
        }else{
          N = '#'
        }

        var j = document.getElementById('fi10')
        // console.log(j.checked);
        if(j.checked){
          J = '10'
        }else{
          J = '#'
        }

        var k = document.getElementById('fi11')
        // console.log(k.checked);
        if(k.checked){
           K = '11'
        }else{
          K = '#'
        }
        var l = document.getElementById('fi12')
        // console.log(l.checked);
        if(l.checked){
           L = '12'
        }
        else{
          L = '#'
        }
        var m = document.getElementById('fi13')
        // console.log(m.checked);
        if(m.checked){
          M = '13'
          console.log('14have')
        }else{
          console.log('13none')
          M = '#'
        }

       var w = document.getElementById('fi14')
        if(w.checked){
          W = '14'
          console.log('14have')
        }else{
           console.log('14none')
          W = '#'
        }

        this.axios({
          url:store.state.Baseurl+':8080/role-premission',
          headers:{
             'Authorization':sessionStorage.getItem("token")
          },
          method:'post',

          params:{
            premission:A+','+B+','+C+','+D+','+E+','+F+','+G+','+H+','+I+','+N+','+J+','+K+','+L+','+M+','+W,
            id:this.character
          }
        }).then(res=>{
            console.log(res)
             this.string = []
             this.$message.success('修改权限成功！');
             this.character = ''
        }).catch(err=>{
          console.log(err)
        })
         
        
         this.dialogFormVisible = false;
      },

      
     
     //删除行
      deleteRow(index,rows,data) {
  
        console.log(data)
        this.axios({
          url:store.state.Baseurl+":8080/role/"+data,
          headers:{
              'Authorization':sessionStorage.getItem("token")
           },
           method:'delete',
           params:{
             id:data
           }
        }).then(res=>{
          console.log(res)
          rows.splice(index,1);
          this.$message.success('删除成功！');
        }).catch(err=>{
          console.log(err);
        })
      },
    },
    
    
  }
    
</script>

<style scoped>

.el-table{
  font-size: 12px;
}
 .ant-page-header-heading-title {
    display: block;
    float: left;
    margin-bottom: 0;
    padding-right: 12px;
    color: rgba(0, 0, 0, 0.85);
    font-weight: 600;
    font-size: 15px;
    line-height: 32px;
}

.page{
  position: absolute;
  top: 95%;
}

.add_group{
  width:50px;
   height:30px;
   
}

.cancel{
   width:50px;
   height:30px;

}
.sure{
  width:50px;
  height:30px;
  color: #FFF;
  background-color: #409EFF;
  border-color: #409EFF;
}
/* tr {
    display: table-row;
    vertical-align: inherit;
    border-color: inherit;
} */
* {
    margin: 0;
    padding: 0;
}
.text-center td, .text-center th {
    text-align: center;
}
.table td, .table th {
    padding: 10px 25px;
    line-height: 1.42857143;
    vertical-align: top;
    border-bottom: 1px solid #cbd0db;
    -webkit-transition: background .2s cubic-bezier(.175,.885,.32,1);
    -o-transition: background .2s cubic-bezier(.175,.885,.32,1);
    transition: background .2s cubic-bezier(.175,.885,.32,1);
}
.table-bordered td, .table-bordered th {
    border: 1px solid #cbd0db;
    /* width:150%; */
    /* float:right; */
}
.thWidth {
    width: 25% !important;
}
*, :after, :before {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}
table {
    border-collapse: separate;
    text-indent: initial;
    border-spacing: 2px;
}
.group-item {
    display: block;
    width: 150px;
    float: left;
    font-size: 14px;
}
table {
    border-spacing: 0;
    border-collapse: collapse;
}
.border{
  /* border: 1px solid black; */
  height: 90%;
  width: 90%;
  margin-left: 5%;
}

a{
  color: #00BFFF;
}


.biaoge{
    font-size: 13px;
    table-layout: fixed;
    background-color: #fff;
    border-radius: 4px 4px 0 0;
}
.add_group{
    border: none;
    background-color:#00BFFF;
    color: white;
    width: 100px;
    height: 30px;
    /* float: right; */
    margin-left: 90%;
    border-radius: 4px;
}

.main{
    /* border: 1px solid black; */
    height:80%;
    margin-top:1%;
}
.center{
    height: 100%;
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