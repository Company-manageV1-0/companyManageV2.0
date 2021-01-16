import axios from 'axios'
/** 管理员获取所有审核请求 */
/**
 * "result": [
    {
      "id": "2f831bb3-6049-4607-9cf3-310c4bd2264a",
      "username": "杨达",
      "img": "http://ql9f52shl.hn-bkt.clouddn.com/dc43b7a5-ec19-4009-9110-9ba8a79ca35e.jpg",
      "sex": "男",
      "phone": "18224393018",
      "email": "2842635969@qq.com",
      "registerTime": "2020-11-26 08:27:27",
      "roleId": "7",
      "auditStatus": "2",
      "staffImg": null,
      "idCardFrontImg": null,
      "idCardBackImg": null
    }
  ],
 *  
 */
function getAllApplyData(){
    return axios({
        method:'GET',
        url:'http://121.36.57.122:8080/apply',
        headers:{
               'Authorization':sessionStorage.getItem("token")
           },
      })
}

export { getAllApplyData }