TFHpple
==============
将 TFHpple 的 html node 解析改成了 pod 管理, 有问题请 issue
 

```

## Usage,,https://segmentfault.com/a/1190000003860297
准备工作
1--pod 'TFHpple'

2---
1.导入TFHpple
2.引入静态库文件libxml2.2.dylib
3.PROJECT 中的 Search Path - header search paths添加 /usr/include/libxml2


解析步骤

1.初始化data
2.根据data创建TFHpple实例
3.查找节点存入数组
4.在该节点下 循环查找子节点

源HTML代码：

<div class="cell item" style=""><div style="position: absolute; margin: -10px -10px 0px 650px;"></div>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>

<td width="48" valign="top" align="center"><a href="/member/zhangyi2099"><img src="//cdn.v2ex.co/avatar/d00c/ceb1/18330_normal.png?m=1345037943" class="avatar" border="0" align="default" /></a></td>
<td width="10"></td>

<td width="auto" valign="middle"><span class="item_title"><a href="/t/228173#reply1">看了本「网球优等生」</a></span>
<div class="sep5"></div>
<span class="small fade"><div class="votes"></div><a class="node" href="/go/acg">ACG</a> &nbsp;•&nbsp; <strong><a href="/member/zhangyi2099">zhangyi2099</a></strong> &nbsp;•&nbsp; 20 分钟前 &nbsp;•&nbsp; 最后回复来自 <strong><a href="/member/yishanxin">yishanxin</a></strong></span>
</td>
<td width="70" align="right" valign="middle">

<a href="/t/228173#reply1" class="count_livid">1</a>

</td>
</tr>
</table>
</div>
Object-C代码

NSData *htmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.xxx.com/xxxx?x=1"]];

TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlData];

#pragma mark 每页主题
NSArray *itemArray = [xpathParser searchWithXPathQuery:@"//div[@class = 'cell item']"];

//通过for in 在itemArray数组中 循环查找子节点
for (TFHppleElement *hppleElement in itemArray) {

/***
这段被正则表达代替 @"//div[@class = 'cell item']"]
if ([[hppleElement objectForKey:@"class" ] isEqualToString:@"cell item"]) {
[self.allDataMutableArray addObject:hppleElement];
}
*/

#pragma mark 子节点头像

NSArray *IMGElementsArr = [hppleElement searchWithXPathQuery:@"//img"];
for (TFHppleElement *tempAElement in IMGElementsArr) {
NSString *imgStr = [tempAElement objectForKey:@"src"];
NSString *subStr = [@"http:" stringByAppendingString:imgStr];
[self.avatarMutableArray addObject:subStr];
}

#pragma mark 子节点标题/链接

NSArray *TitleElementArr = [hppleElement searchWithXPathQuery:@"//span[@class='item_title']"];
for (TFHppleElement *tempAElement in TitleElementArr) {
//获得标题
NSString *titleStr =  [tempAElement content];

//1.获得子节点（正文连接节点） 2.获得节点属性值 3.加入到字典中
NSArray * arr = [tempAElement children];
TFHppleElement *href = arr.firstObject;
NSString * titleHrefStr = [href objectForKey:@"href"];

[self.allDataMutableDict setObject:titleStr forKey:@"title"];
self.allDataMutableDict[@"titleHref"] = titleHrefStr;
}


#pragma mark 子节点fade
//简化写法 简化3步
NSArray *nodeElementArr = [hppleElement searchWithXPathQuery:@"//a[@class='node']"];
self.allDataMutableDict[@"node"] = [nodeElementArr.firstObject content];

NSArray *fadeElementArr = [hppleElement searchWithXPathQuery:@"//span[@class = 'small fade']"];
NSArray *subArray = [ [fadeElementArr.firstObject content] componentsSeparatedByString:@"  •  "];

self.allDataMutableDict[@"louZhu"] = [subArray objectAtIndex:1];
self.allDataMutableDict[@"lastTime"] = [subArray objectAtIndex:2];



#pragma mark 子节点回复数
NSArray * repeatElementArr = [hppleElement searchWithXPathQuery:@"//a[@class = 'count_livid']"];
if ([repeatElementArr.firstObject content ]) {
self.allDataMutableDict[@"repeatCount"] = [repeatElementArr.firstObject content];
}else{
self.allDataMutableDict[@"repeatCount"] = [NSString stringWithFormat:@"%d",0];
}



#pragma mark 转化model 存进数组
[model setValuesForKeysWithDictionary:self.allDataMutableDict];
[self.allDataMutableArray addObject:model];


}

 
```
##Give Feedback

**Contact:**  491590253@qq.com

