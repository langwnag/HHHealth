//
//  HealthCircleCell.m
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HealthCircleCell.h"

#import "CircleModel.h"

@implementation HealthCircleCell
{
    NSArray<CircleModel *> * _circleArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (NSMutableArray *)tagArr{
//    
//    if (!_tagArr) {
//        
//        _tagArr = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    return _tagArr;
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(CGFloat)loadData:(NSArray<CircleModel *> *)dataArr{
    _circleArr = dataArr;
    //距左边间距
    CGFloat leftSpace = 20;
    CGFloat barLineSpace = 20;
    for (int i = 0; i < dataArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 100 + i;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        //注册事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString * circleName = [dataArr[i] name];
        //计算文字的大小
        CGFloat length = [circleName boundingRectWithSize:CGSizeMake(SZRScreenWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
        [btn setTitle:circleName forState:UIControlStateNormal];
        [btn setTitleColor:SZR_NewNavColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"diseaseSelectBg"] forState:UIControlStateSelected];

        [btn setBackgroundImage:[UIImage imageNamed:@"whiteImage"] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.frame = CGRectMake(leftSpace, barLineSpace, length+15, 25);
        //判断是否需要换行
        if (leftSpace+length+15+20 > SZRScreenWidth) {
            //换行时将leftSpace置为20
            leftSpace = 20;
            barLineSpace = barLineSpace + 25 + 10;
            btn.frame = CGRectMake(leftSpace, barLineSpace, length+15, 25);
        }
        leftSpace = btn.frame.size.width + btn.frame.origin.x + 10;
        [self.contentView addSubview:btn];
    }
    return barLineSpace + 25 + 20;
}
// 这是判断逻辑
-(void)btnClick:(UIButton *)btn{
//    if (!self.lastSelectedBtn) {
//        //没有一个疾病选中
//        if (!btn.selected) {
//            //开始btn为未选中状态 设置为选中
//            if (self.selectedDiseaseStrBlock) {
//                NSNumber * cicleID = [_circleArr[btn.tag - 100] healthyCircleRangeId];
//                self.selectedDiseaseStrBlock(cicleID);
//            }
//        }
//        _lastSelectedBtn = btn;
//    }else{
//        //已有一个疾病选中
//        if (btn.selected) {
//            if (self.selectedDiseaseStrBlock) {
//                NSNumber * cicleID = [_circleArr[btn.tag - 100] healthyCircleRangeId];
//                self.selectedDiseaseStrBlock(cicleID);
//            }
//            _lastSelectedBtn = nil;
//        }
//        else{
//            //修改当前选中btn
//            _lastSelectedBtn.selected = !_lastSelectedBtn.selected;
//            _lastSelectedBtn = btn;
//            if (self.selectedDiseaseStrBlock) {
//                NSNumber * cicleID = [_circleArr[btn.tag - 100] healthyCircleRangeId];
//                self.selectedDiseaseStrBlock(cicleID);
//            }
//        }
//    }

//    btn.selected = !btn.selected;
//    NSInteger * tmpCount = 0;
//    for (UIButton * tmpBtn in _tagArr) {
//        
//        if (tmpBtn.tag == btn.tag) {
//            
//            if (btn.isSelected == NO) {
//                
//                [_tagArr removeObject:btn];
//            }
//        }else{
//            
//            [_tagArr addObject:btn];
//        }
//        tmpCount++;
//    }
    NSNumber * circleId = [_circleArr[btn.tag - 100] healthyCircleRangeId];
    self.selectedDiseaseStrBlock(circleId);
    btn.selected = !btn.selected;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
