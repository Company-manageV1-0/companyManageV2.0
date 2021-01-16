//日期排序
function arrSortByTime(arr) {
    //升序排序
    arr.sort(function (a, b) {
      if (a.time < b.time) {
        return -1;
      } else if (a.time > b.time) {
        return 1;
      } else {
        if (a.time < b.time) {
          return 1;
        } else if (a.time > b.time) {
          return -1;
        }
        return 0;
      }
    });
  }

function getTable(currentPage, thisArg) {
    this.bind(thisArg);
    this.pagesize = 8;
    //通过当前页数和每页限制条数 从总数组上分割要显示的数组
    this.showTableData = this.testTableData.slice(
      (currentPage - 1) * this.pagesize,
      currentPage * this.pagesize
    );
    console.log(this.showTableData);
    return this;
}
//get All Feedback Data
function getAllFeedbackData(thisArg){
    this.bind(thisArg);
    this.axios({
      method: "GET",
      url: (currentPage = 1, size = 1000)=>{
        let url = "http://121.36.57.122:8080/feedback/get-all";
        url = url.concat(
          "?pageIndex=" + currentPage.toString() + "&size=" + size
        );
        console.log(url);
    
        return url;
    },
      headers:{
            Authorization: sessionStorage.getItem("token"),
        },
    }).then((res) => {
      //超出限制用... 和 修改日期
      this.testTableData = res.data.result.records;
      for (let TableData of this.testTableData) {
        TableData.briefDescribe = TableData.briefDescribe
          .toString()
          .substr(0, [11])
          .concat("...");
        TableData.time = TableData.time.replace(/T/g, "-");
        TableData.questionType = "    ".concat(TableData.questionType);
        // for(let i = 0;i<TableData.declareDescribe.length/20;i++){
            // TableData.declareDescribe.substr(i,[(i+1)*20]).concat("<br />")
        // }
        // console.log(TableData.softwareName + TableData.id)
      }
      //按照日期排序
      arrSortByTime(this.testTableData);
      console.log(this.testTableData.length);
      //计算page总数
      this.pagecount =
        this.testTableData.length % 8 === 0
          ? this.testTableData.length / 8
          : (this.testTableData.length - (this.testTableData.length % 8)) /
              8 +
            1;
      // console.log(this.pagecount);

      getTable(1);

      return this;
    });
  }
  

export {getAllFeedbackData, getTable}