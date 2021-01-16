import axios from 'axios'
/** 技术人员获取所有符合的数据 */
/**
 * "result": {
    "records": [
      {
        "id": "06af28bca1350abd02a451e12e25d707",
        "userId": "2f831bb3-6049-4607-9cf3-310c4bd2264a",
        "softwareName": "王者荣耀",
        "questionType": "卡机",
        "briefDescribe": "为什么队友0/10举报不成功",
        "declareDescribe": "在一局普通的排位赛中，我选择了我胜率最高的英雄，然而我的队友却一直在送，其中有一个送了十个人头，还一直说我们太菜，他带不动，出去举报竟然不成功",
        "uploadFile": null,
        "isdeal": 1,
        "time": "2020-11-29 10:24:26",
        "dealUserId": null,
        "solution": null,
        "phone": null,
        "email": null
      }
    ],
    "total": 18,
    "size": 1,
    "current": 1,
    "searchCount": true,
    "pages": 18
  },
 */
function getAllFeedbackData(){
    return axios({
        method:'GET',
        url:'http://121.36.57.122:8080/feedback',
        headers:{
               'Authorization':sessionStorage.getItem("token")
           },
      })
}

export { getAllFeedbackData }