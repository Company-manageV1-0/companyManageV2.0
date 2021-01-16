import axios from 'axios'
/** 管理员提交审核结果 */
/**
 * @param {*} params
 * 都是string类型
 * 
 * auditStatus 申请审核状态，0未申请，1已申请待审核，2通过审核，3未通过审核
 * id 用户ID
 * roleId 申请的角色的ID
 */
function patchApplyData(params){
    return axios({
        method:'PATCH',
        url:'http://121.36.57.122:8080/apply',
        headers:{
               'Authorization':sessionStorage.getItem("token")
           },
        params:params,
      })
}

export { patchApplyData }