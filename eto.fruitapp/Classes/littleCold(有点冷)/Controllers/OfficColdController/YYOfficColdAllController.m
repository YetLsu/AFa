//
//  YYOfficColdAllController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYOfficColdAllController.h"
#import "YYLittleColdDetaileViewController.h"

#import "YYOfficColdCellModel.h"
#import "YYOfficColdCell.h"
#import "YYOfficColdCellFrame.h"


@interface YYOfficColdAllController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *allArrays;

@property (nonatomic, assign) CGFloat rowheight;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

/**
 *文章的url字符串
 */
@property (nonatomic, copy) NSString *essayUrlStr;
@property (nonatomic, assign) NSInteger baid;
@end

@implementation YYOfficColdAllController
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}


//获取所有文章
- (void)getAllArticles{
    NSString *urlStr = @"http://www.sxeto.com/fruitApp/Buyer?mode=31&category=0";
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
     
//        YYLog(@"%@",responseObject);
        for (int i = 0; i < responseObject.count - 1; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            NSDictionary *dic = responseObject[key];
            YYLog(@"%@",dic);
            NSString *category = dic[@"category"];
            NSString *leftTitle;
            switch (category.intValue) {
                case 1:
                    leftTitle = @"养生";
                    break;
                case 2:
                    leftTitle = @"烹饪";
                    break;
                case 3:
                    leftTitle = @"健康";
                    break;
                case 4:
                    leftTitle = @"食谱";
                    break;

                default:
                    break;
            }
            
            NSString *radius = dic[@"radius"];
           
            NSString *zan = dic[@"hot"];
 
            NSString *baid = dic[@"id"];
            //截取出时间
            NSString *date = dic[@"datatime"];
            NSRange range = NSMakeRange(0, 11);
            date = [date substringWithRange:range];
            YYOfficColdCellModel *model = [YYOfficColdCellModel officAndCustomModelWithLeftTitle:leftTitle andTitle:dic[@"title"] andContentWord:dic[@"intro"] andPictureImage:dic[@"img"] andTime:date andNumberZan:zan.integerValue andNumberComment:15 andEssayURL:dic[@"url"] andBaid:baid.integerValue andRadius:radius.integerValue];
            [self.allArrays addObject:model];
        }
        [self.allTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败");
    }];
}
- (NSMutableArray *)allArrays{
    if (!_allArrays) {
        _allArrays = [NSMutableArray array];
        
    }
    return _allArrays;
}


- (instancetype)initWithTableViewHeight:(CGFloat)height{
    if (self = [super init]) {

        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, height) style:UITableViewStyleGrouped];
        self.allTableView = tableView;
        self.allTableView.delegate = self;
        self.allTableView.dataSource = self;
       
        [self getAllArticles];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.allArrays.count == 0) {
        return 1;
    }else{
        return self.allArrays.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.allArrays.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tianchong"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin, 11, widthScreen - (2*YY16WidthMargin), 20)];
        label.text = @"_(:з」∠)_去别处看看吧~";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.9];
        [cell.contentView addSubview:label];
        self.rowheight = 44;
        return cell;
    }else{
        YYOfficColdCell *cell = [YYOfficColdCell OfficAndCustomColdCellWithTableView:tableView];
        
        YYOfficColdCellModel *model = self.allArrays[indexPath.section];
        
        YYOfficColdCellFrame *frame = [[YYOfficColdCellFrame alloc] init];
        frame.officAndCustomModel = model;
        
        cell.cellFrame = frame;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.rowheight = frame.rowHeihgt;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.rowheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYOfficColdCellModel *model = self.allArrays[indexPath.section];

    YYLittleColdDetaileViewController *dataile = [[YYLittleColdDetaileViewController alloc] initWithEssayUrl:model.essayURLStr andessayID:model.baid andRadius:model.radius];
    YYLog(@"%@",model.essayURLStr);
    YYLog(@"%ld",model.baid);

    if ([self.delegate respondsToSelector:@selector(pushControllerWithController:)]) {
        [self.delegate pushControllerWithController:dataile];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
@end
