//
//  LWViewController.m
//  CustomDatePicker
//
//  Created by 13517248639@163.com on 03/05/2018.
//  Copyright (c) 2018 13517248639@163.com. All rights reserved.
//

#import "LWViewController.h"
#import "LWDatePicker.h"
#import "LWDateTimeSettingModel.h"

@interface LWViewController ()

@property (nonatomic, strong)LWDatePicker *datePicker;

@end

@implementation LWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LWDateTimeSettingModel *settingModel = [LWDateTimeSettingModel new];
    settingModel.dateType = LWDatePickerDateFormatTypeYMDHM;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    settingModel.startDate = [formatter dateFromString:@"2008-08-06 20:00"];
    settingModel.endDate = [NSDate date];
    settingModel.defaultDate = [NSDate date];
    self.datePicker = [[LWDatePicker alloc] initWithDateSettingModel:settingModel];
    [self.view addSubview:self.datePicker];
}

- (void)viewWillLayoutSubviews{
    self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
}

- (void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.2f animations:^{
         self.datePicker.frame = CGRectMake(0, self.view.frame.size.height - self.datePicker.viewHeight, self.view.frame.size.width, self.datePicker.viewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

@end
