//
//  LWDatePicker.m
//  CustomDatePicker
//
//  Created by sunshinelww on 2018/3/5.
//

#import "LWDatePicker.h"
#import "LWDateTimeSettingModel.h"
#import "NSDate+LWKit.h"
#import "LWTheme.h"
#import "NSDictionary+SafeAccess.h"


#define LWDatePickerHeight  240.f
#define LWDatePickerWidth   300.f
#define LWDateTableViewCellId @"cell"

typedef NS_ENUM(NSInteger,ViewTag) {
    view_tag_year = 10000,
    view_tag_month,
    view_tag_day,
    view_tag_hour,
    view_tag_minute
};

@interface LWCustomTableViewCell: UITableViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;

@end

@implementation LWCustomTableViewCell
@end

@interface LWDatePicker()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *yearTableView;
@property (nonatomic, strong) UITableView *monthTableView;
@property (nonatomic, strong) UITableView *dayTableView;
@property (nonatomic, strong) UITableView *hourTableView;
@property (nonatomic, strong) UITableView *minuteTableView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;

@property (nonatomic, strong) LWDateTimeSettingModel *settingModel;
@property (nonatomic, strong) NSMutableDictionary *currentDateComponent;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UILabel *toolBarContentLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation LWDatePicker

- (instancetype)initWithDateSettingModel:(LWDateTimeSettingModel *)settingModel{
    self = [super init];
    if (self) {
        _settingModel = settingModel;
        
        _yearArray = [NSMutableArray array];
        _monthArray = [NSMutableArray array];
        _dayArray = [NSMutableArray array];
        _hourArray = [NSMutableArray array];
        _minuteArray = [NSMutableArray array];
        
        [self setupUI];
        [self refreshAllTime];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.toolBarView];
    [self.backView addSubview:self.yearTableView];
    [self.backView addSubview:self.monthTableView];
    [self.backView addSubview:self.dayTableView];
    [self.backView addSubview:self.hourTableView];
    [self.backView addSubview:self.minuteTableView];
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell{
    [self.yearTableView registerClass:  [LWCustomTableViewCell class] forCellReuseIdentifier:LWDateTableViewCellId];
    [self.monthTableView registerClass: [LWCustomTableViewCell class] forCellReuseIdentifier:LWDateTableViewCellId];
    [self.dayTableView registerClass:   [LWCustomTableViewCell class] forCellReuseIdentifier:LWDateTableViewCellId];
    [self.hourTableView registerClass:  [LWCustomTableViewCell class] forCellReuseIdentifier:LWDateTableViewCellId];
    [self.minuteTableView registerClass:[LWCustomTableViewCell class] forCellReuseIdentifier:LWDateTableViewCellId];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, LWDatePickerWidth, LWDatePickerHeight);
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat minW = LWDatePickerWidth;
    CGFloat minH = LWDatePickerHeight;
    
    self.backView.frame = self.bounds;
    
    _cellHeight = (minH - 40)/5.f;
    
    //布局顶部控制
    self.toolBarView.frame = CGRectMake(0, 0, minW, 40);
    self.cancelButton.frame = CGRectMake(0, 0, 50, 40);
    self.confirmButton.frame = CGRectMake(minW - 50, 0, 50, 40);
    self.toolBarContentLabel.frame = CGRectMake(40, 0, minW - 2 * 50, 40);
    
    //时间选择tableView布局
    minX = 0;
    minY = 40;
    
    switch (self.settingModel.dateType) {
        case LWDatePickerDateFormatTypeYM:
            minW = minW/2;
            self.yearTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.monthTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            break;
        case LWDatePickerDateFormatTypeYMD:
            minW = minW/3;
            self.yearTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.monthTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.dayTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            break;
        case LWDatePickerDateFormatTypeYMDHM:
            minW = (minW - 10) /5;
            self.yearTableView.frame = CGRectMake(minX, minY, minW + 10, minH - minY);
            minX += minW;
            self.monthTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.dayTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.hourTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            minX += minW;
            self.minuteTableView.frame = CGRectMake(minX, minY, minW, minH - minY);
            break;
        default:
            break;
    }
    [self.yearTableView reloadData];
    [self.monthTableView reloadData];
    [self.dayTableView reloadData];
    [self.hourTableView reloadData];
    [self.minuteTableView reloadData];
}

- (void)refreshAllTime{
    NSDate *selectedDate = self.settingModel.defaultDate?:self.settingModel.endDate;
    [self.currentDateComponent lw_safeSetObject:[NSString stringWithFormat:@"%ld年",selectedDate.year] forKey:@"year"];
    [self.currentDateComponent lw_safeSetObject:[NSString stringWithFormat:@"%02ld月",selectedDate.month] forKey:@"month"];
    [self.currentDateComponent lw_safeSetObject:[NSString stringWithFormat:@"%02ld日",selectedDate.day] forKey:@"day"];
    [self.currentDateComponent lw_safeSetObject:[NSString stringWithFormat:@"%02ld",selectedDate.hour] forKey:@"hour"];
    [self.currentDateComponent lw_safeSetObject:[NSString stringWithFormat:@"%02ld",selectedDate.minute] forKey:@"minute"];
    
    switch (self.settingModel.dateType) {
        case LWDatePickerDateFormatTypeYM:{
            [self refreshYear];
            [self refreshMonthWithYear:[self.currentDateComponent lw_stringForKey:@"year"]];
            
            [self setSelectDateComponent:@"year"];
            [self setSelectDateComponent:@"month"];
            break;
        }
        case LWDatePickerDateFormatTypeYMD:{
            NSString *year = [self.currentDateComponent lw_stringForKey:@"year"];
            NSString *month = [self.currentDateComponent lw_stringForKey:@"month"];
            [self refreshYear];
            [self refreshMonthWithYear:year];
            [self refreshDayWithYear:year andMonth:month];
            
            [self setSelectDateComponent:@"year"];
            [self setSelectDateComponent:@"month"];
            [self setSelectDateComponent:@"day"];
            break;
        }
        case LWDatePickerDateFormatTypeYMDHM:{
            NSString *year = [self.currentDateComponent lw_stringForKey:@"year"];
            NSString *month = [self.currentDateComponent lw_stringForKey:@"month"];
            NSString *day = [self.currentDateComponent lw_stringForKey:@"day"];
            NSString *hour = [self.currentDateComponent lw_stringForKey:@"hour"];
            [self refreshYear];
            [self refreshMonthWithYear:year];
            [self refreshDayWithYear:year andMonth:month];
            [self refreshHourWithYear:year andMonth:month andDay:day];
            [self refreshMinuteWithYear:year andMonth:month andDay:day andHour:hour];
            
            [self setSelectDateComponent:@"year"];
            [self setSelectDateComponent:@"month"];
            [self setSelectDateComponent:@"day"];
            [self setSelectDateComponent:@"hour"];
            [self setSelectDateComponent:@"minute"];
            break;
        }
        default:
            break;
    }
}
/**
 设置各个组件的选中时间
 **/
- (void)setSelectDateComponent:(NSString *)compnent{
    if (!compnent) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *dataArray;
        UITableView *tableView;
        if ([compnent isEqualToString:@"year"]) {
            dataArray = self.yearArray;
            tableView = self.yearTableView;
        }
        else if ([compnent isEqualToString:@"month"]){
            dataArray = self.monthArray;
            tableView = self.monthTableView;
        }
        else if ([compnent isEqualToString:@"day"]){
            dataArray = self.dayArray;
            tableView = self.dayTableView;
        }
        else if ([compnent isEqualToString:@"hour"]){
            dataArray = self.hourArray;
            tableView = self.hourTableView;
        }
        else if ([compnent isEqualToString:@"minute"]){
            dataArray = self.minuteArray;
            tableView = self.minuteTableView;
        }
        NSString *value = [self.currentDateComponent lw_stringForKey:compnent];
        NSInteger index = [dataArray indexOfObject:value];
        if (index > 0 && index < dataArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(index + 2) inSection:0];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    });
}

#pragma mark - tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case view_tag_year:
            return self.yearArray.count + 4;
            break;
        case view_tag_month:
            return self.monthArray.count + 4;
            break;
        case view_tag_day:
            return self.dayArray.count + 4;
            break;
        case view_tag_hour:
            return self.hourArray.count + 4;
            break;
        case view_tag_minute:
            return self.minuteArray.count + 4;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LWDateTableViewCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    if (!titleLabel) {
        titleLabel = [UILabel new];
        titleLabel.tag = 100;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:titleLabel];
    }
    
    titleLabel.frame = cell.contentView.frame;
    titleLabel.textColor = [UIColor blackColor];
    NSArray *dataArray;
    
    switch (tableView.tag) {
        case view_tag_year:
            dataArray = self.yearArray;
            break;
        case view_tag_month:
            dataArray = self.monthArray;
            break;
        case view_tag_day:
            dataArray = self.dayArray;
            break;
        case view_tag_hour:
            dataArray = self.hourArray;
            break;
        case view_tag_minute:
            dataArray = self.minuteArray;
            break;
        default:
            dataArray = [NSArray array];
            break;
    }
    if (indexPath.row < 2 || indexPath.row > dataArray.count + 1) {
        titleLabel.text = @"";
    }
    else{
        titleLabel.text = dataArray[indexPath.row - 2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tableView = (UITableView *)scrollView;
    NSArray *cells = tableView.visibleCells;
    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LWCustomTableViewCell *cell = (LWCustomTableViewCell*)obj;
        [self changeLabelWithTableView:tableView andCell:cell];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateRelatedDataArray:(UITableView *)scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self updateRelatedDataArray:(UITableView *)scrollView];
}

/**
 设置选中cell和非选中cell的样式
 **/
- (void)changeLabelWithTableView:(UITableView *)tableView andCell:(LWCustomTableViewCell *)cell{
    CGRect rect = [tableView rectForRowAtIndexPath:cell.indexPath];
    CGRect viewRect = [tableView convertRect:rect toView:self.backView];
    
    CGFloat minY = tableView.center.y - _cellHeight/2;
    CGFloat maxY = tableView.center.y + _cellHeight/2;
    
    CGFloat cellY = viewRect.origin.y + viewRect.size.height/2;
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    if (maxY > cellY && minY < cellY) { //当前cell是选中状态
        titleLabel.alpha = 1.f;
        titleLabel.font = [UIFont systemFontOfSize:15+2];
    }
    else{
        titleLabel.alpha = 0.5f;
        titleLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)updateRelatedDataArray:(UITableView *)tableView{
    NSArray *visibleCells = tableView.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LWCustomTableViewCell *cell = (LWCustomTableViewCell *)obj;
        UILabel *titleLabel = [cell.contentView viewWithTag:100];
        if (titleLabel.alpha == 1.f) {
            [tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; //将选中的Cell居中
            NSString *value = titleLabel.text;
            if ([value isEqualToString:@""]) {
                return ;
            }
            switch (tableView.tag) {
                case view_tag_year:{
                    [self.currentDateComponent lw_safeSetObject:value forKey:@"year"];
                    [self refreshMonthWithYear:value];
                    break;
                }
                case view_tag_month:{
                    [self.currentDateComponent lw_safeSetObject:value forKey:@"month"];
                    NSString *year = [self.currentDateComponent objectForKey:@"year"];
                    [self refreshDayWithYear:year andMonth:value];
                    break;
                }
                case view_tag_day:{
                    [self.currentDateComponent lw_safeSetObject:value forKey:@"day"];
                    NSString *year = [self.currentDateComponent objectForKey:@"year"];
                    NSString *month = [self.currentDateComponent objectForKey:@"month"];
                    [self refreshHourWithYear:year andMonth:month andDay:value];
                    break;
                }
                case view_tag_hour:{
                    [self.currentDateComponent lw_safeSetObject:value forKey:@"hour"];
                    NSString *year = [self.currentDateComponent objectForKey:@"year"];
                    NSString *month = [self.currentDateComponent objectForKey:@"month"];
                    NSString *day = [self.currentDateComponent objectForKey:@"day"];
                    [self refreshMinuteWithYear:year andMonth:month andDay:day andHour:value];
                    break;
                }
                case view_tag_minute:
                    break;
                default:
                    break;
            }
        }
    }];
}

- (void)refreshYear{
    NSInteger minYear = self.settingModel.startDate.year;
    NSInteger maxYear = self.settingModel.endDate.year;
    
    [self.yearArray removeAllObjects];
    for (NSInteger i = minYear; i<= maxYear; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%ld年",(long)i]];
    }
    [self.yearTableView reloadData];
    
}

/**
 * 根据年刷新月
 **/
- (void)refreshMonthWithYear:(NSString *)year{
    BOOL isMin = [year isEqualToString:self.yearArray.firstObject];
    BOOL isMax = [year isEqualToString:self.yearArray.lastObject];
    NSInteger min = 1;
    NSInteger max = 12;
    if (isMin) {
        min = self.settingModel.startDate.month;
    }
    if (isMax) {
        max = self.settingModel.endDate.month;
    }
    [self.monthArray removeAllObjects];
    for (NSInteger i = min; i <= max; i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%ld月",i]];
    }
    [self.monthTableView reloadData];
    [self refreshSelectDateWithTag:view_tag_month];
}

- (void)refreshDayWithYear:(NSString *)year andMonth:(NSString *)month{
    BOOL isMin = [year isEqualToString:self.yearArray.firstObject] && [month isEqualToString:self.monthArray.firstObject];
    BOOL isMax = [year isEqualToString:self.yearArray.lastObject] && [month isEqualToString:self.monthArray.lastObject];
    if ([year containsString:@"年"]) {
        year = [year substringWithRange:NSMakeRange(0, year.length-1)];
    }
    if ([month containsString:@"月"]) {
        month = [month substringWithRange:NSMakeRange(0, month.length - 1)];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSInteger min = 1;
    NSInteger max = [self countDaysOfMonth:date];
    if (isMin) {
        min = self.settingModel.startDate.day;
    }
    if (isMax) {
        max = self.settingModel.endDate.day;
    }
    [self.dayArray removeAllObjects];
    for(NSInteger i = min; i<= max; i++){
        [self.dayArray addObject:[NSString stringWithFormat:@"%02ld日",(long)i]];
    }
    [self.dayTableView reloadData];
    [self refreshSelectDateWithTag:view_tag_day];
}

- (void)refreshHourWithYear:(NSString *)year andMonth:(NSString *)month andDay:(NSString *)day{
    BOOL isMin = [year isEqualToString:self.yearArray.firstObject] && [month isEqualToString:self.monthArray.firstObject] && [day isEqualToString:self.dayArray.firstObject];
    BOOL isMax = [year isEqualToString:self.yearArray.lastObject] && [month isEqualToString:self.monthArray.lastObject] && [day isEqualToString:self.dayArray.lastObject];
    
    NSInteger min = 0;
    NSInteger max = 23;
    
    if (isMin) {
        min = self.settingModel.startDate.hour;
    }
    if (isMax) {
        max = self.settingModel.endDate.hour;
    }
    [self.hourArray removeAllObjects];
    for (NSUInteger i = min; i <= max; i++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    [self.hourTableView reloadData];
    [self refreshSelectDateWithTag:view_tag_hour];
}

- (void)refreshMinuteWithYear:(NSString *)year andMonth:(NSString *)month andDay:(NSString *)day andHour:(NSString *)hour{
    BOOL isMin = [year isEqualToString:self.yearArray.firstObject] && [month isEqualToString:self.monthArray.firstObject] && [day isEqualToString:self.dayArray.firstObject] && [hour isEqualToString:self.hourArray.firstObject];
    BOOL isMax = [year isEqualToString:self.yearArray.lastObject] && [month isEqualToString:self.monthArray.lastObject] && [day isEqualToString:self.dayArray.lastObject] && [hour isEqualToString:self.hourArray.lastObject ];
    
    NSInteger min = 0;
    NSInteger max = 59;
    
    if (isMin) {
        min = self.settingModel.startDate.minute;
    }
    if (isMax) {
        max = self.settingModel.endDate.minute;
    }
    [self.minuteArray removeAllObjects];
    for (NSUInteger i = min ; i <= max; i++) {
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    [self.minuteTableView reloadData];
    [self refreshSelectDateWithTag:view_tag_minute];
}

- (void)refreshSelectDateWithTag:(ViewTag)tag{
    UITableView *tableView = [self.backView viewWithTag:tag];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *cells = [tableView visibleCells];
        [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LWCustomTableViewCell *cell = (LWCustomTableViewCell *)obj;
            UILabel *label = [cell viewWithTag:100];
            if (label.alpha == 1.f) {
                [tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                NSString *key = @"";
                switch (tag) {
                    case view_tag_year:
                        key = @"year";
                        break;
                    case view_tag_month:
                        key = @"month";
                        break;
                    case view_tag_day:
                        key = @"day";
                        break;
                    case view_tag_hour:
                        key = @"hour";
                        break;
                    case view_tag_minute:
                        key = @"minute";
                        break;
                    default:
                        break;
                }
                if (label.text)
                {
                    [self.currentDateComponent lw_safeSetObject:label.text forKey:key];
                }
            }
        }];
        
        switch (tag) {
            case view_tag_year:
                [self refreshMonthWithYear:[self.currentDateComponent lw_stringForKey:@"year"]];
                break;
            case view_tag_month:
                [self refreshDayWithYear:[self.currentDateComponent lw_stringForKey:@"year"] andMonth:[self.currentDateComponent objectForKey:@"month"]];
                break;
            case view_tag_day:
                [self refreshHourWithYear:[self.currentDateComponent lw_stringForKey:@"year"] andMonth:[self.currentDateComponent lw_stringForKey:@"month"] andDay:[self.currentDateComponent lw_stringForKey:@"day"]];
                break;
            case view_tag_hour:
                [self refreshMinuteWithYear:[self.currentDateComponent lw_stringForKey:@"year"] andMonth:[self.currentDateComponent lw_stringForKey:@"month"] andDay:[self.currentDateComponent lw_stringForKey:@"day"] andHour:[self.currentDateComponent lw_stringForKey:@"hour"]];
                break;
            default:
                break;
        }
        
    });
}

#pragma mark - event
- (void)handleButtonAction:(UIButton *)sender{
    
}

#pragma mark - public property

- (CGFloat)viewWidth{
    return LWDatePickerWidth;
}

- (CGFloat)viewHeight{
    return LWDatePickerHeight;
}

#pragma mark - private property

- (NSMutableDictionary *)currentDateComponent{
    if (!_currentDateComponent) {
        _currentDateComponent = [NSMutableDictionary dictionary];
    }
    return _currentDateComponent;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
    }
    return _backView;
}

- (UITableView *)yearTableView{
    if (!_yearTableView) {
        UITableView *tbView = [UITableView new];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor clearColor];
        tbView.showsVerticalScrollIndicator = NO;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.tag = view_tag_year;
        _yearTableView = tbView;
    }
    return _yearTableView;
}

- (UITableView *)monthTableView{
    if (!_monthTableView) {
        UITableView *tbView = [UITableView new];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor clearColor];
        tbView.showsVerticalScrollIndicator = NO;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.tag = view_tag_month;
        _monthTableView = tbView;
    }
    return _monthTableView;
}

- (UITableView *)dayTableView{
    if (!_dayTableView) {
        UITableView *tbView = [UITableView new];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor clearColor];
        tbView.showsVerticalScrollIndicator = NO;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.tag = view_tag_day;
        _dayTableView = tbView;
    }
    return _dayTableView;
}

- (UITableView *)hourTableView{
    if (!_hourTableView) {
        UITableView *tbView = [UITableView new];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor clearColor];
        tbView.showsVerticalScrollIndicator = NO;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.tag = view_tag_hour;
        _hourTableView = tbView;
    }
    return _hourTableView;
}

- (UITableView *)minuteTableView{
    if (!_minuteTableView) {
        UITableView *tbView = [UITableView new];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor clearColor];
        tbView.showsVerticalScrollIndicator = NO;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.tag = view_tag_minute;
        _minuteTableView = tbView;
    }
    return _minuteTableView;
}

- (UIView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [UIView new];
        _toolBarView.backgroundColor = kLWColorF8F8F8;
    }
    return _toolBarView;
}

- (UILabel *)toolBarContentLabel{
    if (!_toolBarContentLabel) {
        _toolBarContentLabel = [UILabel new];
        _toolBarContentLabel.font = [UIFont systemFontOfSize:15];
        _toolBarContentLabel.textAlignment = NSTextAlignmentCenter;
        _toolBarContentLabel.textColor = [UIColor blackColor];
        [self.toolBarView addSubview:_toolBarContentLabel];
    }
    return _toolBarContentLabel;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000;
        _confirmButton = btn;
        [self.toolBarView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1001;
        _cancelButton = btn;
        [self.toolBarView addSubview:_cancelButton];
    }
    return _cancelButton;
}

#pragma mark - Tools

- (NSInteger)countDaysOfMonth:(NSDate *)date{
    NSRange dataInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return dataInOfMonth.length;
}

@end
