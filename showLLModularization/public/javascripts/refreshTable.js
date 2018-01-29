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
        dateElement.append(data[item].date);
        trElement.append(dateElement);

        $("#myTable").append(trElement);
    }
}