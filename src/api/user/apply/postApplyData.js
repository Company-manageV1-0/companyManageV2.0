import axios from 'axios'

/**提交用户申请api */
/**
 * 
 * @param {*} params
 *    auditStatus 申请审核状态，0未申请，1已申请待审核，2通过审核，3未通过审核
 *    id 用户ID
 *    idCardBackImg 身份证反面照
 *    idCardFrontImg 身份证正面照
 *    roleId 申请的角色的ID
 *    staffImg 该软件公司申请职员的工作牌照片
 */

function postApplyData(params){
    return axios({
        method:'POST',
        url:'http://121.36.57.122:8080/apply',
        headers:{
               'Authorization':sessionStorage.getItem("token")
           },
        params:params,
      })
}

export { postApplyData }




