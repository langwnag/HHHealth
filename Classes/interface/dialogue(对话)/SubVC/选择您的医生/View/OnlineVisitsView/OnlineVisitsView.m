//
//  OnlineVisitsView.m
//  YiJiaYi
//
//  Created by mac on 2017/4/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OnlineVisitsView.h"
#import "TelephoneCounHeaderV.h"
#import "CustomConsultingCell.h"
@interface OnlineVisitsView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) TelephoneCounHeaderV* telephoneCounHeaderV;


@end
@implementation OnlineVisitsView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    // 添加蒙版效果

    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];

    [self.tableV registerNib:[UINib nibWithNibName:@"CustomConsultingCell" bundle:nil] forCellReuseIdentifier:@"CustomConsultingCell"];

    [self addSubview:self.tableV];
    [self.tableV addSubview:self.telephoneCounHeaderV];
}
- (SZRTableView *)tableV{
    if (!_tableV) {
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, k6PAdaptedWidth(1160/3), k6PAdaptedHeight(750/2.6)) style:UITableViewStylePlain controller:self];
        _tableV.center = self.center;
        _tableV.layer.cornerRadius = 8.0f;
        _tableV.layer.masksToBounds = YES;
        _tableV.scrollEnabled = NO;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

- (TelephoneCounHeaderV *)telephoneCounHeaderV{
    if (!_telephoneCounHeaderV) {
        _telephoneCounHeaderV = [[[NSBundle mainBundle] loadNibNamed:@"TelephoneCounHeaderV" owner:self options:nil] lastObject];
        _telephoneCounHeaderV.frame = CGRectMake(0, 0, 0, k6PAdaptedHeight(372/2.6));
        _telephoneCounHeaderV.phoneLa.text = @"在线咨询";
        _tableV.tableHeaderView = _telephoneCounHeaderV;
    }
    return _telephoneCounHeaderV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomConsultingCell* customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomConsultingCell" forIndexPath:indexPath];
    customCell.descriptionLa.text = @"您可以与健康师进行在线文字、语音咨询";
    customCell.priceLa.hidden = YES;
    return customCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(void)removeView:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
