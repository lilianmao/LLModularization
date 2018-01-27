var mysql = require('mysql');
var config = require('../conf/conf');
var sql = require('./callStackSqlMapping')

var pool = mysql.createPool(config.mysql);


class CallStackDao {
    constructor() {

    }

    async insert(params) {
        // resolve，reject：分别表示异步操作执行成功后的回调函数和异步操作执行失败后的回调函数。
        return new Promise((resolve, reject) => {
            pool.getConnection(function (err, connection) {

                // 建立连接，向表中插入值
                connection.query(sql.batchInsert, [params], function (err, rows, fields) {
                    var result;

                    if (rows == params.count) {
                        result = {
                            code: 200,
                            msg: '插入成功'
                        };
                    }

                    resolve(result);
                    connection.release();
                });
            });
        });
    }

    async queryAll() {
        return new Promise((resolve, reject) => {
            pool.getConnection(function (err, connection) {
                connection.query(sql.queryAll, function (err, result) {
                    resolve(result);
                    connection.release();
                });
            });
        });

    }

    async queryCount(content) {
        return new Promise((resolve, reject) => {
            pool.getConnection(function (err, connection) {
                let countSQL = sql.queryCount;
                if (typeof(content) != "undefined") {
                    content = "%"+content+"%";
                    countSQL = countSQL + " where callChain like ?";
                }
                connection.query(countSQL, content, function (err, result) {
                    resolve(result);
                    connection.release();
                });
            });
        });
    }

    async queryByPage(pagenum, pagesize, pageContent) {
        return new Promise((resolve, reject) => {
            pool.getConnection(function (err, connection) {
                let querySQL;
                if (typeof(pageContent) != "undefined") {
                    pageContent = "%"+pageContent+"%";
                    querySQL = sql.queryAll + " where callChain like ? limit " + pagenum + ", " + pagesize;
                } else {
                    querySQL = sql.queryAll + " limit " + pagenum + ", " + pagesize;
                }
                connection.query(querySQL, pageContent, function (err, result) {
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

    jsonWrite(res, ret) {
        if (typeof ret === 'undefined') {
            res.json({
                code: '1',
                msg: '操作失败'
            });
        } else {
            res.json(ret);
        }
    }

}

module.exports = CallStackDao;
