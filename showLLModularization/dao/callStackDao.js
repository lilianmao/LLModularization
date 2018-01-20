var mysql = require('mysql');
var config = require('../conf/conf');
var sql = require('./callStackSqlMapping')

var pool = mysql.createPool(config.mysql);

// 向前台返回JSON方法的简单封装
var jsonWrite = function (res, ret) {
    if(typeof ret === 'undefined') {
        res.json({
            code:'1',
            msg: '操作失败'
        });
    } else {
        res.json(ret);
    }
};

module.exports = {
    insert : function (req, res, next, params) {

        pool.getConnection(function (err, connection) {
            // 获取前台页面传过来的参数
            var param = req.query || req.params;

            // 建立连接，向表中插入值
            connection.query(sql.batchInsert, [params], function (err, rows, fields) {
                var result;

                if(rows == params.count) {
                    result = {
                        code: 200,
                        msg:'查询成功'
                    };
                }
                // 以json形式，把操作结果返回给前台页面
                jsonWrite(res, result);
                // 释放连接
                connection.release();
            });
        });

    },

    queryAll : function (req, res, next) {
        pool.getConnection(function(err, connection) {
            connection.query(sql.queryAll, function(err, result) {
                // jsonWrite(res, result);
                res.render('list',{
                    title:'应用调用栈页',
                    result:result
                });
                connection.release();
            });
        });
    },

    truncate : function (req, res, next) {
        pool.getConnection(function (err, connection) {
            connection.query(sql.truncate, function (err, result) {
                connection.release();
            });
        });
    }
};

