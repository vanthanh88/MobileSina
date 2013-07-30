//
//  FieldEditorViewController.h
//  SinaEbookReader
//
//  Created by macos on 20/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "MCSegmentedControl.h"

@class FieldSpecifier, FieldEditorViewController, FieldSectionSpecifier;

typedef enum FieldSpecifierType { 
	FieldSpecifierTypeText,
	FieldSpecifierTypePassword,
	FieldSpecifierTypeEmail,
	FieldSpecifierTypeURL,
	FieldSpecifierTypeSwitch,
	FieldSpecifierTypeCheck,
	FieldSpecifierTypeButton,
	FieldSpecifierTypeSection,
	FieldSpecifierTypeNumeric,
    FieldSpecifierTypeSegment,
    FieldSpecifierTypeWebView,
    FieldSpecifierTypeTextView,
    FieldSpecifierTypeViewNomal,
    FieldSpecifierTypeImageButton
} FieldSpecifierType;


@protocol FieldEditorViewControllerDelegate <NSObject>

@optional
- (void)fieldEditor:(FieldEditorViewController *)editor didFinishEditingWithValues:(NSDictionary *)returnValues;
- (void)fieldEditorDidCancel:(FieldEditorViewController *)editor;
- (void)fieldEditor:(FieldEditorViewController *)editor pressedButtonWithKey:(NSString *)key;
- (void)fieldEditor:(FieldEditorViewController *)editor changeValueWithType:(FieldSpecifierType)type AndValue: (NSString*)value;

@end


@interface FieldEditorViewController : UITableViewController <UITextFieldDelegate, FieldEditorViewControllerDelegate> {

	id delegate;
	id context;
	NSString *editorIdentifier;
	NSArray *fieldSections;
	NSMutableDictionary *values;
	NSString *doneButtonTitle;
	NSString *cancelButtonTitle;
	BOOL isSubSection;
	BOOL isOpeningSubsection;
	BOOL hasChanges;
	UITextField *selectedTextField;
    
    
}

@property (nonatomic, retain) id<FieldEditorViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *fieldSections;
@property (nonatomic, retain) NSMutableDictionary *values;
@property (nonatomic, retain) NSString *doneButtonTitle;
@property (nonatomic, retain) NSString *cancelButtonTitle;
@property (nonatomic, retain) id context;
@property (nonatomic, retain) NSString *editorIdentifier;
@property (nonatomic, assign) BOOL isSubSection;
@property (nonatomic, assign) BOOL hasChanges;
@property (nonatomic, retain) UITextField *selectedTextField;

- (id)initWithFieldSections:(NSArray *)sections title:(NSString *)title;
- (void)openSubsection:(FieldSpecifier *)subsectionField;
- (void)done;
- (void)dismissKeyboard;

@end


@interface FieldSectionSpecifier : NSObject {
	
	NSArray *fields;
	NSString *title;
	NSString *description;
	BOOL exclusiveSelection;
    BOOL showHeader;
    BOOL enable;
    NSString* textExclusiveSelectionDefault;
}

@property (nonatomic, retain) NSArray *fields;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) BOOL exclusiveSelection;
@property (nonatomic, assign) BOOL showHeader;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, retain) NSString* textExclusiveSelectionDefault;

+ (FieldSectionSpecifier *)sectionWithFields:(NSArray *)f title:(NSString *)t description:(NSString *)d;

@end


@interface FieldSpecifier : NSObject {
	
	FieldSpecifierType type;
	NSArray *subsections;
	NSString *key;
	NSString *title;
	NSString *placeholder;
    
    NSArray *segmentTitles;
    NSInteger defaultSegmentChoose;
    NSString* htmlText;
    NSString* imageName;
    UIView* viewNomal;
    
	id defaultValue;
	BOOL shouldDisplayDisclosureIndicator;
    BOOL disable;
    
}

@property (nonatomic, assign) FieldSpecifierType type;
@property (nonatomic, retain) NSArray *subsections;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSArray *segmentTitles;
@property (nonatomic, assign) NSInteger defaultSegmentChoose;
@property (nonatomic, strong) NSString* htmlText;


@property (nonatomic, retain) UIView* viewNomal;

@property (nonatomic, retain) id defaultValue;
@property (nonatomic, assign) BOOL shouldDisplayDisclosureIndicator;
@property (nonatomic, assign) BOOL disable;

+ (FieldSpecifier *)fieldWithType:(FieldSpecifierType)t key:(NSString *)k;
+ (FieldSpecifier *)switchFieldWithKey:(NSString *)k title:(NSString *)switchTitle defaultValue:(BOOL)flag;
+ (FieldSpecifier *)emailFieldWithKey:(NSString *)k title:(NSString *)emailTitle defaultValue:(NSString *)defaultEmail;
+ (FieldSpecifier *)URLFieldWithKey:(NSString *)k title:(NSString *)URLTitle defaultValue:(NSString *)defaultURL;
+ (FieldSpecifier *)passwordFieldWithKey:(NSString *)k title:(NSString *)passwordTitle defaultValue:(NSString *)defaultPassword;
+ (FieldSpecifier *)textFieldWithKey:(NSString *)k title:(NSString *)textTitle defaultValue:(NSString *)defaultText;
+ (FieldSpecifier *)numericFieldWithKey:(NSString *)k title:(NSString *)numericTitle defaultValue:(NSString *)defaultText;
+ (FieldSpecifier *)checkFieldWithKey:(NSString *)k title:(NSString *)checkmarkTitle defaultValue:(BOOL)checked;
+ (FieldSpecifier *)buttonFieldWithKey:(NSString *)k title:(NSString *)buttonTitle;
+ (FieldSpecifier *)subsectionFieldWithSections:(NSArray *)sections key:(NSString *)k title:(NSString *)t;
+ (FieldSpecifier *)subsectionFieldWithSection:(FieldSectionSpecifier *)section key:(NSString *)k;

+ (FieldSpecifier *)segmentFieldWithKey:(NSString *)k segments:(NSArray*)titles defaultSegment:(NSInteger)segmentChoose;

+ (FieldSpecifier *)webViewFieldWithKey:(NSString *)k htmlData:(NSString*)html;
+ (FieldSpecifier *)textViewFieldWithKey:(NSString *)k content:(NSString*)text;
+ (FieldSpecifier *)viewNomalFieldWithKey:(NSString *)k viewNomal:(UIView*)view;
+ (FieldSpecifier *)imageButtonFieldWithKey:(NSString *)k imageName: (NSString*)image textTitle:(NSString*)title;

@end


@interface NamedTextField : UITextField {
	
	NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end


@interface NamedSwitch: UISwitch {
	
	NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end

@interface NamedWebView : UIWebView {
    NSString* name;

}

@property (nonatomic, retain) NSString* name;

@end

@interface NamedTextView : UITextView {

    NSString* name;
}

@property(nonatomic, retain) NSString* name;

@end

@interface NamedViewNomal : UIView {

    NSString* name;
}

@property(nonatomic, retain) NSString* name;

@end


@interface NamedSegmentControl : MCSegmentedControl {

    NSString *name;
}
@property (nonatomic, retain) NSString *name;

@end






