//
//  LJJWaterFlowLayout.m
//  WaterFlowDemo
//
//  Created by 俊杰  廖 on 2018/10/15.
//  Copyright © 2018年 俊杰  廖. All rights reserved.
//

#import "LJJWaterFlowLayout.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kColumnCount 3 //列数
#define kInterItemSpacing 10.0f //item间距
#define kLineSpacing 10.0f //行间距

@interface LJJWaterFlowLayout()

@end

@implementation LJJWaterFlowLayout

- (CGFloat)itemWidth {
    //代理获取itemSize
    UIEdgeInsets edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:0];
    CGFloat itemWidth = (kScreenWidth - (kColumnCount - 1)*kInterItemSpacing-edgeInsets.left-edgeInsets.right) / kColumnCount;
    return itemWidth;
}

/**
 准备布局item前调用，可以在这里面完成必要属性的初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    //初始化间距
    self.minimumInteritemSpacing = kInterItemSpacing;
    self.minimumLineSpacing = kLineSpacing;
    //初始化存储容器
    _attributes = [NSMutableDictionary dictionary];
    _cloArray = [NSMutableArray arrayWithCapacity:kColumnCount];
    for (int i=0; i<kColumnCount; ++i) {
        [_cloArray addObject:@(0.f)];
    }
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    //遍历所有item获取位置信息并且储存

    NSUInteger sectionCount = [self.collectionView numberOfSections];
    for (int section=0; section<sectionCount; ++section) {
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int row=0; row<itemCount; ++row) {
            [self layoutEachItemFrameAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
}

/**
 设置每个item的尺寸并和indexPath为键值对存在字典里

 @param indexPath item的位置x
 */
- (void)layoutEachItemFrameAtIndexPath:(NSIndexPath *)indexPath {
    //代理获取itemSize
    UIEdgeInsets edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
//    NSLog(@"前大小:%@",NSStringFromCGSize(itemSize));
    
    CGFloat itemWidth = (kScreenWidth - (kColumnCount - 1)*kInterItemSpacing-edgeInsets.left-edgeInsets.right) / kColumnCount;
    
    CGFloat itemHeight = itemWidth*itemSize.height/itemSize.width;
    //得到等比例大小
    itemSize = CGSizeMake(itemWidth, itemHeight);
//    NSLog(@"得到等比例大小:%@",NSStringFromCGSize(itemSize));
    //获取列数中高度最低的一组
    NSUInteger miniClo = 0;
    CGFloat miniHeight = [_cloArray[miniClo] floatValue];
    for (int clo=1; clo<_cloArray.count; ++clo) {
        CGFloat currentCloHeight = [_cloArray[clo] floatValue];
        //如果当前列的高度小于最低y高度，则重新赋值
        if (miniHeight > currentCloHeight) {
            miniHeight = currentCloHeight;
            miniClo = clo;
        }
    }
    
    //找到高度最小的列为clo,最小高度为miniClo
    //在当前高度最低的列上面追加item并且存储位置信息
    CGFloat x = edgeInsets.left + miniClo*(kInterItemSpacing+itemWidth);
    CGFloat y = edgeInsets.top + miniHeight;
    //确定cell的frame
    CGRect frame = CGRectMake(x, y, itemSize.width, itemSize.height);
    //每个cell的frame对应一个indexPath，放入字典中
    [_attributes setValue:indexPath forKey:NSStringFromCGRect(frame)];
    //更新列高
    [_cloArray replaceObjectAtIndex:miniClo withObject:@(CGRectGetMaxY(frame))];
}



/**
 返回所有当前在可视范围内的item的布局属性

 @param rect 可视范围
 @return 可视范围内的所有item的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //初始化可视化范围内应该显示的所有item的位置数组
    NSMutableArray *indexPaths = [NSMutableArray array];
    //遍历存放item位置信息的字典，并找到需要显示的item
    for (NSString *itemRectInfo in _attributes) {
        CGRect itemRect = CGRectFromString(itemRectInfo);
        //通过CGRectIntersectsRect方法确定每个item的rect与传入的rect是否有交集，如果有交集则说明这个item需要显示，所有我们将item的位置indexPath加入数组
        if (CGRectIntersectsRect(itemRect, rect)) {
            NSIndexPath *indexPath = _attributes[itemRectInfo];
            [indexPaths addObject:indexPath];
        }
    }
    
    //初始化存需要显示的item的数组
    NSMutableArray *attributeArray = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *index in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:index];
        [attributeArray addObject:attribute];
    }
    return attributeArray;
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    for (NSString * itemFrame in _attributes) {
        if (_attributes[itemFrame] == indexPath) {
            attribute.frame = CGRectFromString(itemFrame);
            break;
        }
    }
    return attribute;
}


/**
 计算collectionView的可滚动范围，必重写

 @return collectionView内容大小
 */
- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = [_cloArray[0] floatValue];
    for (int clo=1; clo<_cloArray.count; ++clo) {
        CGFloat currentCloHeight = [_cloArray[clo] floatValue];
        if (maxHeight < currentCloHeight) {
            maxHeight = currentCloHeight;
        }
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), maxHeight + self.collectionView.contentInset.bottom);
   
}

@end
