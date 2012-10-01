//
//  MyDebug.h


#define SelfClassName [[self class] description]

#define ClassError(errorMessage) NSLog(@"%@ -> %@", SelfClassName, errorMessage)
#define MethodError(methodName, errorMessage) NSLog(@"%@:%@ -> %@", SelfClassName, methodName, errorMessage)