#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SSZipArchive/SSZipArchive.h>
#include "ioswrap.h"

void ioswrap_log(const char *message)
{
    NSLog(@"%s", message);
}

void ioswrap_paths(int type, char *dest, size_t destlen)
{
    NSArray *paths;

    if (type == PATH_DOCUMENTS)
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    else if (type == PATH_LIBRARY_SUPPORT || type == PATH_LIBRARY_CACHE)
        paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    else
        return;

    NSString *path = paths.firstObject;
    const char *path_c = path.UTF8String;

    if (type == PATH_DOCUMENTS)
        snprintf(dest, destlen, "%s", path_c);
    else if (type == PATH_LIBRARY_SUPPORT)
        snprintf(dest, destlen, "%s/Application Support", path_c);
    else // type == PATH_LIBRARY_CACHE
        snprintf(dest, destlen, "%s/Caches", path_c);
}

void ioswrap_assets()
{
    char buf[256];
    ioswrap_paths(PATH_LIBRARY_SUPPORT, buf, sizeof(buf));
    NSString *destpath = [NSString stringWithUTF8String:buf];
    NSString *zippath = [[NSBundle mainBundle] pathForResource:@"assets" ofType:@"zip"];

    NSLog(@"Assets found in %@", zippath);
    NSLog(@"Extracting to %@", destpath);
    [SSZipArchive unzipFileAtPath:zippath toDestination:destpath];
}

void ioswrap_size(unsigned int *dest)
{
    CGSize bounds = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    dest[0] = bounds.width * scale;
    dest[1] = bounds.height * scale;
}
