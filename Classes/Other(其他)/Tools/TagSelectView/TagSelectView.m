//
//  TagSelectView.m
//  标签选择
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 huanghui. All rights reserved.
//

#import "TagSelectView.h"
#import "SDAutoLayout.h"
@interface TagSelectView ()
{
    CGFloat width;
    CGFloat TagHeight;
    UIColor *tagSelectColor;
    UIColor *tagCancelColor;
    CGFloat vcViewWidth;
}
@property(nonatomic,copy)NSMutableArray *dataArray;

@end


@implementation TagSelectView
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(instancetype)init
{
    if ([super init]) {
       
       
        
          /**     这里改标签高度 和 颜色   **/
        
        //高度
            TagHeight =28;
        //选择后颜色
//            tagSelectColor= [UIColor orangeColor];
        //没有选择的颜色
//            tagCancelColor=[UIColor whiteColor];
        
            //view颜色
         self.backgroundColor=[UIColor whiteColor];
            
    
      
       
    }


    return self;

}
-(void)setUpTitleArray:(NSMutableArray *)titleArray
{

    self.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 0);
    [self.dataArray addObjectsFromArray:titleArray];
    [self SetFirstView];
    [self SetSubview];

}
-(void)SetFirstView
{
    UIView *title_View = [[UIView alloc]init];
    
    [self addSubview:title_View];
    
    
    //长度根据 文字长度 而定 不设置 稍后 调整
    title_View.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,10)
    .heightIs(TagHeight);
    //圆角
    title_View.layer.cornerRadius=TagHeight/2;
    title_View.layer.masksToBounds=YES;
#pragma mark - 后添加
    title_View.layer.borderWidth = 1.0f;
    title_View.layer.borderColor = [UIColor orangeColor].CGColor;

    //标记tag值 等会获取
    
    title_View.tag =1000;
    
    //添加Label
    UILabel *title_lable =[[UILabel alloc]init];
#pragma mark - 后添加
    title_lable.textColor = [UIColor orangeColor];

    [title_View addSubview:title_lable];
    //不添加长度 文本自适应
    title_lable.sd_layout
    .leftSpaceToView(title_View,10)
    .topSpaceToView(title_View,4)
    .bottomSpaceToView(title_View,4);
    title_lable.text=self.dataArray.firstObject;
    title_lable.tag=100;
    //添加文本自适应
    [title_lable setSingleLineAutoResizeWithMaxWidth:0];
    
    title_lable.font=[self titleFont];
    //确定title_View长度
    [title_View setupAutoWidthWithRightView:title_lable rightMargin:10];
    
    //添加点击button
    UIButton *title_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [title_View addSubview:title_button];
    
    title_button.sd_layout
    .leftSpaceToView(title_View,0)
    .topSpaceToView(title_View,0)
    .rightSpaceToView(title_View,0)
    .bottomSpaceToView(title_View,0);
    
    
    [title_button addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    title_button.tag =1;
    
    
//    title_View.backgroundColor = tagSelectColor;
//    title_View.layer.borderColor=tagSelectColor.CGColor;
//    title_View.layer.borderWidth=1;
//    title_lable.textColor=[UIColor whiteColor];
//    
   

}
-(void)SetSubview
{
    for (int i = 1; i <self.dataArray.count ; i++) {
        //前一个View
        UIView *frontView =[self viewWithTag:1000+i-1];
        
        
        //(复制代码)
        
        UIView *title_View = [[UIView alloc]init];
        
        [self addSubview:title_View];
        
        title_View.backgroundColor = [UIColor whiteColor];
        
        
        title_View.sd_layout
        .leftSpaceToView(frontView,10)
        .topEqualToView(frontView)
        .heightIs(TagHeight);
        
        
        //圆角
        title_View.layer.cornerRadius=14;
        title_View.layer.masksToBounds=YES;
#pragma mark - 后添加
        title_View.layer.borderWidth = 1.0f;
        title_View.layer.borderColor = [UIColor orangeColor].CGColor;

        //标记tag值 等会获取
        
        title_View.tag =1000+i;
        
        //添加Label
        UILabel *title_lable =[[UILabel alloc]init];
#pragma mark - 后添加
        title_lable.textColor = [UIColor orangeColor];
        [title_View addSubview:title_lable];
        //不添加长度 文本自适应
        title_lable.sd_layout
        .leftSpaceToView(title_View,10)
        .topSpaceToView(title_View,4)
        .bottomSpaceToView(title_View,4);
        title_lable.text=self.dataArray[i];
        title_lable.font=[self titleFont];
        title_lable.tag=i+100;
        //添加文本自适应
        [title_lable setSingleLineAutoResizeWithMaxWidth:0];
        //确定title_View长度
        [title_View setupAutoWidthWithRightView:title_lable rightMargin:10];
        
        //添加点击button
        UIButton *title_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [title_View addSubview:title_button];
        
        title_button.sd_layout
        .leftSpaceToView(title_View,0)
        .topSpaceToView(title_View,0)
        .rightSpaceToView(title_View,0)
        .bottomSpaceToView(title_View,0);
        
        
        [title_button addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        title_button.tag =i+1;
        
        
        
//        title_View.backgroundColor = tagCancelColor;
//        title_View.layer.borderColor=tagSelectColor.CGColor;
//        title_View.layer.borderWidth=1;
//        title_lable.textColor=tagSelectColor;
        
        
        [title_View setDidFinishAutoLayoutBlock:^(CGRect rect) {
            
            //位置加长度
            width =rect.origin.x+rect.size.width+10;
            
        }];
        //关键地方 因为是异步回调 所以必须每布局一个view就要更新一次才能回调参数
        // （*****注意：都是建好一个 布局一个******）
        // 跟在上面 添加创建个view 复制 n 个这样一样的代码 把名字改了 是一个意思
        [title_View updateLayout];
        
        //如果这个标签位置超过屏幕就换行
//        if (width>[ UIScreen mainScreen ].bounds.size.width) {
//            
//            title_View.sd_layout
//            .leftSpaceToView(self,10)
//            .topSpaceToView(frontView,10)
//            .heightIs(TagHeight);
//            
        // 屏幕宽度减去左边控件的距离，如果左边没有控件宽度，默认vcViewWidth传0
        if (width> [UIScreen mainScreen].bounds.size.width - vcViewWidth) {
            
            title_View.sd_layout
            .leftSpaceToView(self,10)
            .topSpaceToView(frontView,10)
            .heightIs(TagHeight);
            
        }
    }
    
    
    
    UIView *view =[self viewWithTag:1000+self.dataArray.count-1];
    
    //view高度自适应(self.BaseView 现在才给高度)
    [self setupAutoHeightWithBottomView:view bottomMargin:10];

}

- (void)setViewWidth:(CGFloat)viewWidth{
    _viewWidth = viewWidth;
    vcViewWidth = viewWidth;
}

-(void)titleAction:(UIButton *)button
{
    
    
    NSLog(@"%@",[self.dataArray objectAtIndex:button.tag-1]);
    
    [self.delegate TagdidSelectTitle:[self.dataArray objectAtIndex:button.tag-1] SelectIndex:button.tag-1];
    
    for (int i = 0; i<self.dataArray.count; i++) {
        
        UIView *view =[self viewWithTag:1000+i];
        
        UILabel *Label =[self viewWithTag:100+i];
        if (button.tag==i+1) {
//            view.backgroundColor=tagSelectColor;
//            Label.textColor=tagCancelColor;
        }else
        {
//            view.backgroundColor=tagCancelColor;
//            Label.textColor=tagSelectColor;
        }
    }
}


-(UIFont *)titleFont
{
    
    if ([ UIScreen mainScreen ].bounds.size.width<321) {
        
        return [UIFont systemFontOfSize:14];
        
        
    }else if ([ UIScreen mainScreen ].bounds.size.width>319&&[ UIScreen mainScreen ].bounds.size.width<376)
    {
        return [UIFont systemFontOfSize:16];
        
        
    }else if ([ UIScreen mainScreen ].bounds.size.width>375)
    {
        return  [UIFont systemFontOfSize:18];
        
    }else
    {
        return [UIFont systemFontOfSize:17];
    }
    
    
}
-(void)reloadViewData
{

     [self.delegate TagdidSelectTitle:[self.dataArray objectAtIndex:0] SelectIndex:0];
    for (int i = 0; i<self.dataArray.count; i++) {
        
        UIView *view =[self viewWithTag:1000+i];
        
        UILabel *Label =[self viewWithTag:100+i];
        if (0==i) {
            
//            view.backgroundColor=tagSelectColor;
//            Label.textColor=tagCancelColor;
        }else
        {
//            view.backgroundColor=tagCancelColor;
//            Label.textColor=tagSelectColor;
        }
        
        
    }


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
