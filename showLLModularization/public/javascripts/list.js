$(document).ready(function(){
    //过滤信息
    // $('#search').live("click" ,function(e){
    $('body').on("click" , '#search' , function(e){
        e.preventDefault();
        let id = $('#searchId').val();
        $.ajax({
            type:'GET',
            url:'/users/query?id='+id,
            success:function(data){
                console.log(data);
                // TODO: 有bug，先注释掉，哈哈😀
                // $('#infoContainer').empty().append(`
				// 	<tr>
				// 		<td>${data[0]['id']}</td>
				// 		<td>${data[0]['callChain']}</td>
				// 		<td>${data[0]['service']}</td>
				// 		<td>${data[0]['serviceType']}</td>
				// 	</tr>
				// `);

            }
        })
    })

});