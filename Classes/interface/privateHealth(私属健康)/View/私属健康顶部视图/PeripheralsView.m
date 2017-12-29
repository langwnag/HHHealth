//
//  PeripheralsView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PeripheralsView.h"
//顶部按钮视图
#import "OrderBtnSet.h"
//导入E-charts
#import "PYLineDemoOptions.h"
#import "PYEchartsView.h"

#define WEEKBTN_WIDTH 45
#define WEEKBTN_HEIGHT 21

#define OPTION_DIC @{@"心率:周":[SZRFunction SZRstringTOColor:@"ffccff"],@"心率:月":[SZRFunction SZRstringTOColor:@"99ffff"],@"心率:季":[SZRFunction SZRstringTOColor:@"66ff33"],@"心率:年":[SZRFunction SZRstringTOColor:@"836FFF"],@"血压:周":[SZRFunction SZRstringTOColor:@"7D26CD"],@"血压:月":[SZRFunction SZRstringTOColor:@"87CEEB"],@"血压:季":[SZRFunction SZRstringTOColor:@"B0E2FF"],@"血压:年":[SZRFunction SZRstringTOColor:@"C1C1C1"],@"血氧:周":[SZRFunction SZRstringTOColor:@"D8BFD8"],@"血氧:月":[SZRFunction SZRstringTOColor:@"FF33FF"],@"血氧:季":[SZRFunction SZRstringTOColor:@"FF7F00"],@"血氧:年":[SZRFunction SZRstringTOColor:@"24df3a"],@"呼吸:周":[SZRFunction SZRstringTOColor:@"00FFFF"],@"呼吸:月":[SZRFunction SZRstringTOColor:@"F5DEB3"],@"呼吸:季":[SZRFunction SZRstringTOColor:@"87CEFA"],@"呼吸:年":[SZRFunction SZRstringTOColor:@"C1FFC1"],@"计步:周":[SZRFunction SZRstringTOColor:@"C6E2FF"],@"计步:月":[SZRFunction SZRstringTOColor:@"D1EEEE"],@"计步:季":[SZRFunction SZRstringTOColor:@"96CDCD"],@"计步:年":[SZRFunction SZRstringTOColor:@"ffcccc"]}


@interface PeripheralsView ()<OrderBtnSetDelegate>
//顶部按钮btn
@property(nonatomic,strong)OrderBtnSet * topBtnSView;

@property(nonatomic,assign)CGFloat frameWidth;
@property(nonatomic,assign)CGFloat frameHeight;

@property(nonatomic,copy)NSString * firstLevelStr;//心率，血压...
@property(nonatomic,copy)NSString * secondLevelStr;//周,月,季...
@property(nonatomic,copy)NSString * optionStr;//选择的字符串

//@property(nonatomic,strong)UILabel * optionLabel;
@property (nonatomic,strong) UIView * brokenLineViewBG;

/** 继承py */
@property (nonatomic,strong)PYEchartsView *kEchartView;



@end

@implementation PeripheralsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frameHeight = frame.size.height;
        self.frameWidth = frame.size.width;
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    //顶部按钮视图
    self.topBtnSView = [[OrderBtnSet alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth, 30)];
    __weak PeripheralsView * tempSelf = self;
    self.topBtnSView.initialStrBlock = ^(NSString * str){
        tempSelf.firstLevelStr = str;
    };
    [self.topBtnSView createUI];
    self.topBtnSView.Tagdelegate = self;
    
    
    [self addSubview:self.topBtnSView];
    //创建折现视图
    [self createBrokenLineView];
    //创建周 月 季 年 按钮
    [self createZYJNBtn];
    [self createView];

    
}

#pragma mark 创建折线视图
-(void)createBrokenLineView{
    
    self.brokenLineViewBG = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnSView.frame) + 25,self.frameWidth , self.frameHeight - (CGRectGetMaxY(self.topBtnSView.frame) + 25))];
    [self addSubview:self.brokenLineViewBG];
//    self.optionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.optionLabel.textColor = [UIColor whiteColor];
//    [self.brokenLineViewBG addSubview:self.optionLabel];

}
#pragma mark 创建图形
- (void)createView{
    UIButton* btnTitleFrame = (UIButton* )[self viewWithTag:201];
    self.kEchartView = [[PYEchartsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnTitleFrame.frame)-70, SZRScreenWidth, 249)];
    PYOption* option = [PYLineDemoOptions irregularLine2Option];
    [self.kEchartView setOption:option];
    [self.kEchartView loadEcharts];
    [self.brokenLineViewBG addSubview:self.kEchartView];
}

-(void)createZYJNBtn{
    //背景视图
    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnSView.frame), self.frameWidth, 25)];
    NSArray * btnTitleArr = @[@"周",@"月",@"季",@"年"];
    CGFloat leftSpace = self.frameWidth == 320 ? 20 : 40;
    CGFloat midSpace = (self.frameWidth - WEEKBTN_WIDTH * 4 - leftSpace * 2)/3;
    for (int i = 0; i < 4; i++) {
        UIButton * btn = [SZRFunction createButtonWithFrame:CGRectMake(leftSpace + (midSpace + WEEKBTN_WIDTH)*i, 5, WEEKBTN_WIDTH, 17) withTitle:btnTitleArr[i] withImageStr:nil withBackImageStr:nil];
        btn.backgroundColor = [UIColor yellowColor];
        [btn setTitleColor:SZR_NewNavColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        //切圆角
        btn.layer.cornerRadius = 3.0f;
        btn.layer.masksToBounds = YES;
        btn.tag = 200 + i;
        [btn setTag:201];
        [btn addTarget:self action:@selector(clickWYJNBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [BGView addSubview:btn];
    }
    [self addSubview:BGView];
    self.secondLevelStr = btnTitleArr[0];
    [self MYLabelText];
}


#pragma mark 顶部按钮代理
-(void)OrderBtnSet:(NSString *)paramStr{
    self.firstLevelStr = paramStr;
    [self MYLabelText];
}

-(void)clickWYJNBtn:(UIButton *)btn{
    self.secondLevelStr = btn.titleLabel.text;
    [self MYLabelText];
}

-(void)MYLabelText{
    self.optionStr = [NSString stringWithFormat:@"%@:%@",self.firstLevelStr,self.secondLevelStr];
//    self.optionLabel.text = self.optionStr;
    
    self.brokenLineViewBG.backgroundColor = OPTION_DIC[self.optionStr];
    
    
}



@end
