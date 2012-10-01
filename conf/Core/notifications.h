//
//  notifications.h


#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define postNotificationWithNameAndObject(name, argument) [NOTIFICATION_CENTER postNotificationName:name object:argument]
#define postNotificationWithName(name) postNotificationWithNameAndObject(name, nil)

#define kNotificationObjectSuccess @"succes"
#define kNotificationObjectError @"error"

#define kNotificationAppInitialized @"appInitialized"
