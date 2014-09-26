Swift-Date-valueType-And-String-extension
=========================================

Swift 日期(Date)的值类型 封装 及 字符串(String) UTF8 常用扩展

日期类型(Date)提供了丰富的计算方法,简单方便到几点,而属性只有一个 Double 的时间戳,保证内存开销不会成为负担,和普通的浮点数一样

例如:

        var now = Date()                                //当前日期
        let date1 = Date(year:2014, month:9, day:7)     //2014-09-07 00:00:00
        let date2 = date1 + 10 * 24 * 3600              //date1 加10天
        if now.between(date1, date2) {                  //如果now 在2个日期之间
            now += 24 * 3600                            //now + 1天
            println(now.stringWithFormat())
        }
        
还有很多就不一一列举了


字符串(String)扩展 因为Swift计算字符数量String.Index截取非常不方便,因此实现用Int做参数的各种截、替换、插入和URL编码解码等常用功能

        let hello = "Hello Swift"
        let subStr = hello[0..<3]
        println(subStr)

其他不一一列举了
