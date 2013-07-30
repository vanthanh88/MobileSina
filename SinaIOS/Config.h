//
//  Config1.h
//  Sina_Ios
//
//  Created by macos on 20/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

#define APP_FACEBOOK_ID             @"389304137790873"
#define DATA_NAME                   @"123doc.db"
#define DATAPATH [[Utils applicationDocumentsDirectory] stringByAppendingPathComponent:DATA_NAME]

#define KEY_USERID                  @"user_login"


#define DEFAULT_FONT_FAMILY_NAME    @"Times New Roman"

#define KEY_ORDER                   @"order"
#define KEY_NAME                    @"name"
#define KEY_LINK                    @"link"
#define KEY_LOCATIONCOUNT           @"locationCount"
//colour
#define SAPHIACOLOR                 0xdfceb6
#define HOMEBUTTONCOLORBOOKMARK     0x3f3f3f
#define HOMEBUTTONCOLOR             0x08511b
#define BLACKCOLOR                  0x000000
#define WHITECOLOR                  0xf3f3f3

#define ACC_AUTHEN                  @"appmobile"
#define PASS_AUTHEN                 @"bjhbcashc2suwbnq"
#define REST_SHARE_KEY              @"2012doc123" 
#define ACCESSKEYID                 @"flkalaiuemcdsd"

#define URL_LOGIN                   @"http://123doc.vn/mobile/login_book.php"
#define URL_SYNC                    @"http://123doc.vn/mobile/sync_book.php"
#define URL_LISTBOOKONCLOUD         @"http://123doc.vn/mobile/cat_cloud_book.php"
#define URL_GETBOOKINFOR            @"http://123doc.vn/mobile/get_info_book.php"
#define URL_DOWNLOADBOOK            @"http://123doc.vn/mobile/down_book.php"
#define URL_FB_LOGIN                @"http://123doc.vn/mobile/login_facebook.php"
#define URL_GET_CAT                 @"http://123doc.vn/mobile/cat_api.php"
#define URL_GET_BOOK_BY_CAT         @"http://123doc.vn/mobile/catid_book.php"
#define URL_REGISTER                @"http://123doc.vn/mobile/register_book.php"
#define URL_SEARCHBOOK              @"http://123doc.vn/mobile/search_book.php"
#define URL_DEREGISTERDEVICE        @"http://123doc.vn/mobile/deregister_book.php"
#define URL_USERSBOOK               @"http://123doc.vn/mobile/safe_book.php"

#define URL_BUY_BOOK                @"http://123doc.vn/mobile/buy_book.php"

#define KEY_DATA                    @"data"
#define KEY_ACCESSKEYID             @"accessKeyId"
#define KEY_CHECKSUM                @"checksum"
#define KEY_SUCCESS                 @"success"

#define KEY_EMAIL                   @"email"
#define KEY_IDUSER                  @"id_user"

//for api result infor book
#define KEY_IDBOOK                  @"id_book"
#define KEY_IDCHAPTER               @"id_chapter"
#define KEY_AUTHOR                  @"author"
#define KEY_PUBLISHER               @"publisher"
#define KEY_CATEGORY                @"category"
#define KEY_TOTALSPAN               @"total_location"
#define KEY_CHAPTER                 @"chapter"
#define KEY_LINK_IMAGE              @"link_image"
#define KEY_CHAPTER_LOCATION_TOTAL  @"cha_location_total"
#define KEY_CHAPTER_NAME            @"cha_name"
#define KEY_CHAPTER_ORDER           @"cha_order"
#define KEY_BOOK_DESCRIPTION        @"desc"
#define KEY_LIST_BOOK_RELATED       @"list_book_related"
#define KEY_STATUS_BOOK             @"status"
#define KEY_RATE_BOOK               @"rate"



#define DEFAULT_ID                  @"150"
#define DEFAULT_EMAIL               @"namdhis@gmail.com"
#define DEFAULT_PASS                @"123456"

#define USERID_PREFERENCES              @"textEntry_key"
#define NAME_PREFERENCES                @"name_key"
#define EMAIL_PREFERENCES               @"email_key"
#define USERTYPE_PREFERENCES            @"type_key"

#define kUsernameLogin                  @"username_login"
#define kPasswordLogin                  @"password_login"


#define DATASYNC(id_user, list_book) [NSString stringWithFormat:@"{\"id_user\":\"%@\",\"list_book\":[%@]}", id_user, list_book]
#define DATALOGIN(email, password, deviceID, deviceName)  [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\",\"id_device\":\"%@\",\"name_device\":\"%@\"}",email,password,deviceID,deviceName];
#define DATALISTONCLOUD(category, order, page) [NSString stringWithFormat:@"{\"category\":%@,\"order\":%@,\"page\":%@}",category, order, page];
#define DATAGETBOOKINFOR(id_book) [NSString stringWithFormat:@"{\"id_book\":\"%@\"}",id_book];

#define DATADOWLOADBOOK(id_book, id_user) [NSString stringWithFormat:@"{\"id_book\":\"%@\",\"id_user\":\"%@\"}", id_book, id_user];
#define DATASEARCHBOOK(keyword,page)  [NSString stringWithFormat:@"{\"keyword\":”%@\",\"page\":%@}",keyword,page];

#define DATA_REQUEST_FACEBOOK(email,username,id_facebook, assesstkn,iddevice) [NSString stringWithFormat:@"{\"email\":\"%@\",\"name\":\"%@\",\"id_facebook\":\"%@\",\"accesstoken\":\"%@\",\"id_device\":\"%@\"}",email,username,id_facebook, assesstkn,iddevice]

#define DATA_GET_BOOK_BY_CAT(cat_id, page, order) [NSString stringWithFormat:@"{\"cat_id\":%@,\"page\":%@,\"order\":%@}",cat_id,page,order]  

#define DATA_DEREGISTER_DEVICE(idUser,idDevice) [NSString stringWithFormat:@"{\"id_user\":\"%@\",\"id_device\":\"%@\"}",idUser,idDevice]

#define DATA_REGISTER_USER(email, password, name) [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\",\"name\":\"%@\"}",email, password, name]

#define DATA_SEARCH_BOOK(keyword, page) [NSString stringWithFormat:@"{\"keyword\":\"%@\", \"page\":%@}",keyword, page]

#define DATA_CHECK_USER_S_BOOK(idUser, idBook) [NSString stringWithFormat:@"{\"id_user\":\"%@\",\"id_book\":\"%@\"}",idUser, idBook]  //key "success" value 1, 0


// Table Book
#define T_BOOK_ID                   @"BOOKID" // ID của sách - PK
#define T_BOOK_NAME                 @"NAME" // Tên sách
#define T_BOOK_AUTHOR               @"AUTHOR" // Tác giả
#define T_BOOK_PUBLISHER            @"PUBLISHER" // Nhà phát hành
#define T_BOOK_CATEGORY             @"CATEGORY" // Thể loại
#define T_BOOK_TOTAL_SPAN           @"TOTALSPAN" // Tổng số span
#define T_BOOK_TOTAL_CHAPTER        @"TOTALCHAPTER" // Tổng số chương

// Table CHAPTER
#define T_CHAPTER_ID                @"CHAPTERID" // ID của chapter - PK
#define T_CHAPTER_BOOK_ID           @"BOOKID" // ID của sách - FK
#define T_CHAPTER_ORDER             @"ORDER_CHAPTER" // số thứ tự của chương
#define T_CHAPTER_NAME              @"NAME" // Tên của chương
#define T_CHAPTER_LINK              @"LINK" // Đường dẫn của chương
#define T_CHAPTER_TOTAL_SPAN        @"TOTALSPAN" // Tổng số span  trong 1 chương
#define T_CHAPTER_CHECK_LOAD        @"CHECKLOAD" // Kiểm tra thuộc tính tải của chương

// Table SPAN
#define T_SPAN_CHAPTER_ID           @"IDCHAPTER" // ID của chapter
#define T_SPAN_LOCATION             @"LOCATION"// Số thứ tự của span
#define T_SPAN_CONTENT              @"CONTENT"// Nội dung của span
#define T_SPAN_PARENT               @"PARENT"
// Table CONFIG BOOK

#define T_CONFIG_TABLE                @"CONFIGBOOK" // Tên bàng
#define T_CONFIG_BOOK_ID              @"BOOKID" // ID của quyển sách đang đọc
#define T_CONFIG_FONT                 @"FONT" // Kiểu font của chữ
#define T_CONFIG_SIZE                 @"SIZE" // Kích cỡ của chữ
#define T_CONFIG_ALIGN                @"ALIGN" // Kiểu căn lề
#define T_CONFIG_PADDING              @"PADDING"
#define T_CONFIG_BACKGROUND_COLOR     @"BACKGROUNDCOLOR"// Màu nền
#define T_CONFIG_TEXT_COLOR           @"TEXTCOLOR" // Màu của chữ
#define T_CONFIG_LOCATION_READING     @"LOCATIONREADING" //Location được đọc gần đây nhất
#define DATABOOKNAMEDEFAULT           @"SPAN_TABLE_NEW"

#define REQUEST_TIME_OUT            20

typedef enum {
    BOOKSTATUS_ONCLOUD,
    BOOKSTATUS_DOWLOADING,
    BOOKSTATUS_DOWLOADED,
    BOOKSTATUS_READING,
    BOOKSTATUS_QUEUED
}BOOKSTATUS;

@interface Config : NSObject

@end
