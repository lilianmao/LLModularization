// table数据展示通用的函数
function refreshTable(data) {
    for (item in data) {
        // 创建tr和td DOM节点
        var trElement = document.createElement('tr');

        let idElement = document.createElement('td');
        idElement.append(data[item].id);
        trElement.append(idElement);
        let callChainElement = document.createElement('td');
        callChainElement.append(data[item].callChain);
        trElement.append(callChainElement);
        let serviceElement = document.createElement('td');
        serviceElement.append(data[item].service);
        trElement.append(serviceElement);
        let serviceTypeElement = document.createElement('td');
        serviceTypeElement.append(data[item].serviceType);
        trElement.append(serviceTypeElement);
        let submitTypeElement = document.createElement('td');
        submitTypeElement.append(data[item].submitType);
        trElement.append(submitTypeElement);
        let dateElement = document.createElement('td');
        var date = convertDateFromString(data[item].date);
        var dateStr = date.format("yyyy-MM-dd hh:mm:ss");
        dateElement.append(dateStr);
        trElement.append(dateElement);

        $("#myTable").append(trElement);
    }
}

Date.prototype.format = function(fmt) {
    var o = {
        "M+" : this.getMonth()+1,                 //月份
        "d+" : this.getDate(),                    //日
        "h+" : this.getHours(),                   //小时
        "m+" : this.getMinutes(),                 //分
        "s+" : this.getSeconds(),                 //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S"  : this.getMilliseconds()             //毫秒
    };
    if(/(y+)/.test(fmt)) {
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }
    for(var k in o) {
        if(new RegExp("("+ k +")").test(fmt)){
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        }
    }
    return fmt;
}

function convertDateFromString(dateString) {
    if (dateString) {
        console.log(dateString);
        var arr1 = dateString.split("T");
        var sdate = arr1[0].split('-');
        var tdate = arr1[1].split('.')[0].split(':');
        var date = new Date(sdate[0], sdate[1]-1, sdate[2], tdate[0], tdate[1], tdate[2]);
        return date;
    }
}