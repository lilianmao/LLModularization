var mysql = require('mysql');
var config = require('../conf/conf');
var sql = require('./callStackSqlMapping')

var pool = mysql.createPool(config.mysql);


class CallStackDao{
    constructor(){

    }

    async insert(params){
        // resolve，reject：分别表示异步操作执行成功后的回调函数和异步操作执行失败后的回调函数。
        return new Promise((resolve, reject)=>{
            pool.getConnection(function (err, connection) {

                // 建立连接，向表中插入值
                connection.query(sql.batchInsert, [params], function (err, rows, fields) {
                    var result;

                    if(rows == params.count) {
                        result = {
                            code: 200,
                            msg:'插入成功'
                        };
                    }

                    resolve(result);
                    connection.release();
                });
            });
        });
    }

    async queryAll(){
        return new Promise((resolve,reject)=>{
            pool.getConnection(function(err, connection) {
                connection.query(sql.queryAll, function(err, result) {
                    resolve(result);
                    connection.release();
                });
            });
        });

    }

    truncate(req, res, next) {
        pool.getConnection(function (err, connection) {
            connection.query(sql.truncate, function (err, result) {
                connection.release();
            });
        });
    }

    jsonWrite(res, ret){
        if(typeof ret === 'undefined') {
            res.json({
                code:'1',
                msg: '操作失败'
            });
        } else {
            res.json(ret);
        }
    }

}

module.exports = CallStackDao;

// 向前台返回JSON方法的简单封装
// var jsonWrite = function (res, ret) {
//     if(typeof ret === 'undefined') {
//         res.json({
//             code:'1',
//             msg: '操作失败'
//         });
//     } else {
//         res.json(ret);
//     }
// };

// module.exports = {
//     insert : function (req, res, next, params) {
//
//         pool.getConnection(function (err, connection) {
//             // 获取前台页面传过来的参数
//             var param = req.query || req.params;
//
//             // 建立连接，向表中插入值
//             connection.query(sql.batchInsert, [params], function (err, rows, fields) {
//                 var result;
//
//                 if(rows == params.count) {
//                     result = {
//                         code: 200,
//                         msg:'查询成功'
//                     };
//                 }
//                 // 以json形式，把操作结果返回给前台页面
//                 jsonWrite(res, result);
//                 // 释放连接
//                 connection.release();
//             });
//         });
//
//     },
//     //
//     // queryAll : async function (req, res, next) {
//     //     pool.getConnection(function(err, connection) {
//     //         connection.query(sql.queryAll, function(err, result) {
//     //             res.send(result);
//     //             connection.release();
//     //         });
//     //     });
//     // },
//
//     truncate : function (req, res, next) {
//         pool.getConnection(function (err, connection) {
//             connection.query(sql.truncate, function (err, result) {
//                 connection.release();
//             });
//         });
//     }
// };

