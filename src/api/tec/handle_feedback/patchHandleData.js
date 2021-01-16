import axios from 'axios'
/** 技术人员提交处理的方法solution */
/**
 * params
 * id 反馈id
 * solution 处理的办法
 */
function patchHandleData(params){
    return axios({
        method:'PATCH',
        url:'http://121.36.57.122:8080/feedback',
        headers:{
               'Authorization':sessionStorage.getItem("token")
           },
        params:params
      })
}

export { patchHandleData }