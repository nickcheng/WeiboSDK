//
//  User.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "User.h"
#import "Resources.h"
#import "NSDictionaryAdditions.h"

@implementation User {
  long long   _userId; //用户UID
	NSString*   _screenName; //微博昵称
  NSString*   _name; //友好显示名称，如Bill Gates(此特性暂不支持)
	NSString*	_province; //省份编码（参考省份编码表）
	NSString*	_city; //城市编码（参考城市编码表）
	NSString*   _location; //地址
	NSString*   _description; //个人描述
	NSString*   _url; //用户博客地址
	NSString*   _profileImageUrl; //自定义图像
	NSString*	_profileLargeImageUrl; //大图像地址
	NSString*	_domain; //用户个性化URL
  NSString*   _verifiedReason; //认证原因
	Gender		_gender; //性别,m--男，f--女,n--未知
	int         _followersCount; //粉丝数
  int         _friendsCount; //关注数
  int         _statusesCount; //微博数
  int         _favoritesCount; //收藏数
  int         _biFollowersCount; //用户的互粉数
	time_t      _createdAt; //创建时间
  BOOL        _following; //是否已关注(此特性暂不支持)
	BOOL		_followedBy; //该用户是否关注当前登录用户
  BOOL        _verified; //加V标示，是否微博认证用户
	BOOL		_allowAllActMsg; //是否允许所有人给我发私信
	BOOL		_geoEnabled; //是否允许带有地理信息
  BOOL        _allowComment; //是否允许所有人对我的微博进行评论
  OnlineStatus _onlineStatus;//用户的在线状态，0：不在线、1：在线
}

@synthesize userId = _userId;
@synthesize screenName = _screenName;
@synthesize name = _name;
@synthesize province = _province;
@synthesize city = _city;
@synthesize location = _location;
@synthesize description = _description;
@synthesize url = _url;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize profileLargeImageUrl = _profileLargeImageUrl;
@synthesize domain = _domain;
@synthesize verifiedReason = _verifiedReason;
@synthesize gender = _gender;
@synthesize followersCount = _followersCount;
@synthesize friendsCount = _friendsCount;
@synthesize statusesCount = _statusesCount;
@synthesize favoritesCount = _favoritesCount;
@synthesize biFollowersCount = _biFollowersCount;
@synthesize createdAt = _createdAt;
@synthesize following = _following;
@synthesize followedBy = _followedBy;
@synthesize verified = _verified;
@synthesize allowAllActMsg = _allowAllActMsg;
@synthesize geoEnabled = _geoEnabled;
@synthesize allowComment = _allowComment;
@synthesize onlineStatus = _onlineStatus;

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:[NSNumber numberWithLongLong:self.userId] forKey:@"userId"];
  [encoder encodeObject:self.screenName forKey:@"screenName"];
  [encoder encodeObject:self.name forKey:@"name"];
  [encoder encodeObject:self.province forKey:@"province"];
  [encoder encodeObject:self.city forKey:@"city"];
  [encoder encodeObject:self.location forKey:@"location"];
  [encoder encodeObject:self.description forKey:@"description"];
  [encoder encodeObject:self.url forKey:@"url"];
  [encoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
  [encoder encodeObject:self.profileLargeImageUrl forKey:@"profileLargeImageUrl"];
  [encoder encodeObject:self.domain forKey:@"domain"];
  [encoder encodeObject:self.verifiedReason forKey:@"verifiedReason"];
  [encoder encodeInt:self.gender forKey:@"gender"];
  [encoder encodeInt:self.followersCount forKey:@"followersCount"];
  [encoder encodeInt:self.friendsCount forKey:@"friendsCount"];
  [encoder encodeInt:self.statusesCount forKey:@"statusesCount"];
  [encoder encodeInt:self.favoritesCount forKey:@"favoritesCount"];
  [encoder encodeInt:self.biFollowersCount forKey:@"biFollowersCount"];
  [encoder encodeInt:self.createdAt forKey:@"createdAt"];
  [encoder encodeBool:self.following forKey:@"following"];
  [encoder encodeBool:self.followedBy forKey:@"followedBy"];
  [encoder encodeBool:self.verified forKey:@"verified"];
  [encoder encodeBool:self.allowAllActMsg forKey:@"allowAllActMsg"];
  [encoder encodeBool:self.geoEnabled forKey:@"geoEnabled"];
  [encoder encodeBool:self.allowComment forKey:@"allowComment"];
  [encoder encodeInt:self.onlineStatus forKey:@"onlineStatus"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super init];
  if (self) {
    [self setUserId:[[decoder decodeObjectForKey:@"userId"] longLongValue]];
    self.screenName = [decoder decodeObjectForKey:@"screenName"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.province = [decoder decodeObjectForKey:@"province"];
    self.city = [decoder decodeObjectForKey:@"city"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.description = [decoder decodeObjectForKey:@"description"];
    self.url = [decoder decodeObjectForKey:@"url"];
    self.profileImageUrl = [decoder decodeObjectForKey:@"profileImageUrl"];
    self.profileLargeImageUrl = [decoder decodeObjectForKey:@"profileLargeImageUrl"];
    self.domain = [decoder decodeObjectForKey:@"domain"];
    self.verifiedReason = [decoder decodeObjectForKey:@"verifiedReason"];
    self.gender = [decoder decodeIntForKey:@"gender"];
    self.followersCount = [decoder decodeIntForKey:@"followersCount"];
    self.friendsCount = [decoder decodeIntForKey:@"friendsCount"];
    self.statusesCount = [decoder decodeIntForKey:@"statusesCount"];
    self.favoritesCount = [decoder decodeIntForKey:@"favoritesCount"];
    self.biFollowersCount = [decoder decodeIntForKey:@"biFollowersCount"];
    self.createdAt = [decoder decodeIntForKey:@"createdAt"];
    self.following = [decoder decodeBoolForKey:@"following"];
    self.followedBy = [decoder decodeBoolForKey:@"followedBy"];
    self.verified = [decoder decodeBoolForKey:@"verified"];
    self.allowAllActMsg = [decoder decodeBoolForKey:@"allowAllActMsg"];
    self.geoEnabled = [decoder decodeBoolForKey:@"geoEnabled"];
    self.allowComment = [decoder decodeBoolForKey:@"allowComment"];
    self.onlineStatus = [decoder decodeIntForKey:@"onlineStatus"];
  }
  return self;
}

- (id)initWithJsonDictionary:(NSDictionary*)dic {
	self = [super init];
  if (self) {
    self.userId = [dic longLongValueForKey:@"id"];
    self.screenName = [dic stringValueForKey:@"screen_name"];
    self.name = [dic stringValueForKey:@"name"];
    NSString *provinceId = [dic stringValueForKey:@"province"];
    NSString *cityId = [dic stringValueForKey:@"city"];
    self.province = [Resources getProvinceName:provinceId];
    self.city = [Resources getCityNameWithProvinceId:provinceId withCityId:cityId];
    self.location = [dic stringValueForKey:@"location"];
    self.description = [dic stringValueForKey:@"description"];
    self.url = [dic stringValueForKey:@"url"];
    self.profileImageUrl = [dic stringValueForKey:@"profile_image_url"];
    self.profileLargeImageUrl = [dic stringValueForKey:@"avatar_large"];
    self.domain = [dic stringValueForKey:@"domain"];
    self.verifiedReason = [dic stringValueForKey:@"verified_reason"];
    
    NSString *genderChar = [dic stringValueForKey:@"gender"];
    if ([genderChar isEqualToString:@"m"])
      self.gender = GenderMale;
    else if ([genderChar isEqualToString:@"f"])
      self.gender = GenderFemale;
    else
      self.gender = GenderUnknow;
    
    self.followersCount = [dic intValueForKey:@"followers_count"];
    self.friendsCount = [dic intValueForKey:@"friends_count"];
    self.statusesCount = [dic intValueForKey:@"statuses_count"];
    self.favoritesCount = [dic intValueForKey:@"favourites_count"];
    self.biFollowersCount = [dic intValueForKey:@"bi_followers_count"];
    self.createdAt = [dic timeValueForKey:@"created_at"];
    self.following = [dic boolValueForKey:@"following"];
    self.followedBy = [dic boolValueForKey:@"follow_me"];
    self.verified = [dic boolValueForKey:@"verified"];
    self.allowAllActMsg = [dic boolValueForKey:@"allow_all_act_msg"];
    self.geoEnabled = [dic boolValueForKey:@"geo_enabled"];
    self.allowComment = [dic boolValueForKey:@"allow_all_comment"];
    self.onlineStatus = [dic intValueForKey:@"online_status"];
  }
	return self;
}

@end
