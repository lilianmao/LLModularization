var callStackSQL = {
    insert:'INSERT INTO callStack(id, callChain, service, serviceType, submitType, date) VALUES(?,?,?,?,?,?)',
    batchInsert:'INSERT INTO callStack(id, callChain, service, serviceType, submitType, date) VALUES ?',
    queryAll:'SELECT * FROM callStack',
    queryCount:'SELECT count(*) FROM callStack',
    getUserById:'SELECT * FROM callStack WHERE id = ? ',
    truncate:'truncate table callStack',
};

module.exports = callStackSQL;

// 注：
// 1. 批量插入是batchInsert，注意写法
