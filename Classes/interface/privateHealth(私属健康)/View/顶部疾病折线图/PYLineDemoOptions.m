//
//  PYLineDemoOptions.m
//  iOS-Echarts
//
//  Created by lizhi on 16/9/5.
//  Copyright © 2016年 pluto-y. All rights reserved.
//

#import "PYLineDemoOptions.h"
@interface PYLineDemoOptions ()

@end
@implementation PYLineDemoOptions
+ (PYOption *)irregularLine2Option {
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
//            title.textEqual(@"时间坐标折线图")
//            .subtextEqual(@"dataZoom支持");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@30).y2Equal(@30);
           //更改网格线
            grid.borderColorEqual(PYRGBA(0, 0, 0, 0));
        
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            //设置时间轴的格式和显示样式
            .formatterEqual(@"(function(params){var date = new Date(params.value[0]);data = date.getFullYear() + \'-\' + (date.getMonth() + 1) + \'-\' + date.getDate() + \' \' + date.getHours() + \':\' + date.getMinutes(); return data + \'<br/>\' + params.value[1] + \',\' + params.value[2]})");
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(NO)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                    mark.showEqual(YES);
                }])
                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                    dataView.showEqual(YES).readOnlyEqual(NO);
                }])
                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                    restore.showEqual(YES);
                }]);
            }]);
        }])
        .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
            dataZoom.showEqual(NO).startEqual(@75);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            //图例设置颜色
//            legend.dataEqual(@[@"series1"]).backgroundColorEqual(PYRGBA(255, 255, 0, 1));
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
//            //设置竖线颜色
//            axis.splitLine =[[PYAxisSplitLine alloc]init];
//            axis.splitLine.lineStyle = [[PYLineStyle alloc]init];
//            axis.splitLine.lineStyle.color =PYRGBA(0, 255, 0, 1);
            axis.typeEqual(PYAxisTypeTime)
            .splitNumberEqual(@6)//x轴的段数 决定线的密集程度
            .showEqual(NO);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue).axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatter = @"0.{value}";
                //让y轴竖线消失
                axis.axisLine = [[PYAxisLine alloc] init];
                axis.axisLine.show = NO;
                //y轴字体颜色设置
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual(PYRGBA(255, 255, 255, 1));
                }]);
            }]);
            //设置横线颜色
            axis.splitLine =[[PYAxisSplitLine alloc]init];
            axis.splitLine.lineStyle = [[PYLineStyle alloc]init];
            axis.splitLine.lineStyle.color =PYRGBA(0, 255, 0, 0.3);

        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            //设置节点显不显
            series.symbolEqual(@"none")
            .symbolSizeEqual(@"(function(value) {return Math.round(value[2]/100) + 2;})").showAllSymbolEqual(YES).nameEqual(@"series1")
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                   normal.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                       //图形线的颜色
                       lineStyle.colorEqual(PYRGBA(255, 255, 0, 1));
                   }]);
                   }]);
            }])
              .typeEqual(PYSeriesTypeLine)
            
            //这个地方控制折线图线的数据
//               .dataEqual([NSMutableArray arrayWithArray:[self createData]]);
//        }]);
            .dataEqual(@"(function () {var d = [];var len = 0;var now = new Date();var value;while (len++ < 200) {d.push([new Date(2014, 9, 1, 0, len * 10000),(Math.random()*30).toFixed(2) - 0,(Math.random()*100).toFixed(2) - 0]);}return d;})()");
        }]);
    

    }];
}

+ (NSArray *)createData{

    NSString *tempString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *tempData = [[tempString componentsSeparatedByString:@", "] mutableCopy];
    NSMutableArray * newData = [NSMutableArray array];
    for (NSString * str in tempData) {
    
        NSString * newStr = [NSString stringWithFormat:@"%f",[str floatValue]/1600];
        [newData addObject:newStr];
        
    }
    
    NSLog(@"newData = %@",newData);
    
    return newData;
}

@end
