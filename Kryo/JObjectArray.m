// ======================================================================================
// Copyright (c) 2013, Christian Fruth, Boxx IT Solutions e.K.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list
// of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list
// of conditions and the following disclaimer in the documentation and/or other materials
// provided with the distribution.
// Neither the name of the Boxx IT Solutions e.K. nor the names of its contributors may
// be used to endorse or promote products derived from this software without specific
// prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
// SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.
// ======================================================================================

#import "JObjectArray.h"
#import "Serializer/JObjectArraySerializer.h"
#import "Kryo.h"
#import <objc/runtime.h>

@implementation JObjectArray

+ (instancetype)arrayWithArray:(NSArray *)array
{
	JObjectArray *newArray = [[JObjectArray alloc] initWithCapacity:array.count];
	[newArray->_array addObjectsFromArray:array];
	return newArray;
}

+ (instancetype)arrayWithObject:(id)object
{
	JObjectArray *newArray = [[JObjectArray alloc] initWithCapacity:1];
	[newArray addObject:object];
	return newArray;
}

+ (instancetype)arrayWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, firstObject);

	JObjectArray *newArray = [[JObjectArray alloc] initWithCapacity:16];
	[newArray addObject:firstObject];
	
	// Über nachfolgende Blöcke iterieren
    id nextObject = va_arg(args, id);
	
	while (nextObject != nil)
    {
		[newArray addObject:nextObject];
		nextObject = va_arg(args, id);
    }
	
	va_end(args);
	
	return newArray;
}

+ (instancetype)arrayWithCapacity:(NSUInteger)length
{
	return [[JObjectArray alloc] initWithCapacity:length];
}

+ (instancetype)arrayOfType:(Class)type
{
	Class arrayType = [Kryo resolveArrayType:type];
	return [[arrayType alloc] init];
}

+ (instancetype)arrayOfType:(Class)type withObject:(id)object
{
	Class arrayType = [Kryo resolveArrayType:type];
	JObjectArray *newArray = [[arrayType alloc] initWithCapacity:1];
	[newArray addObject:object];
	return newArray;
}

+ (instancetype)arrayOfType:(Class)type withObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
	va_list args;
	va_start(args, firstObject);

	Class arrayType = [Kryo resolveArrayType:type];
	JObjectArray *newArray = [[arrayType alloc] initWithCapacity:16];
	[newArray addObject:firstObject];

	// Über nachfolgende Blöcke iterieren
	id nextObject = va_arg(args, id);

	while (nextObject != nil)
	{
		[newArray addObject:nextObject];
		nextObject = va_arg(args, id);
	}

	va_end(args);

	return newArray;
}

+ (instancetype)arrayOfType:(Class)type withCapacity:(NSUInteger)length
{
	Class arrayType = [Kryo resolveArrayType:type];
	return [[arrayType alloc] initWithCapacity:length];
}

+ (instancetype)arrayOfType:(Class)type withArray:(NSArray *)array
{
	Class arrayType = [Kryo resolveArrayType:type];
	JObjectArray *newArray = [[arrayType alloc] initWithCapacity:array.count];
	[newArray->_array addObjectsFromArray:array];
	return newArray;
}

- (id)init
{
	return [self initWithCapacity:NSIntegerMax];
}

- (id)initWithCapacity:(NSUInteger)length
{
	self = [super init];

	if (self != nil)
	{
		_array = (length == NSIntegerMax) ? [NSMutableArray new] : [NSMutableArray arrayWithCapacity:length];
	}

	return self;
}

- (NSUInteger)count
{
	return _array.count;
}

- (void)addObject:(id)object
{
	[_array addObject:object];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [_array objectAtIndex:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	return [_array objectAtIndex:index];
}

- (NSArray *)array
{
	return [NSArray arrayWithArray:_array];
}

- (NSMutableArray *)mutableArray
{
	return [NSMutableArray arrayWithArray:_array];
}

- (NSUInteger)indexOfObject:(id)object
{
	return [_array indexOfObject:object];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

- (Class)componentType
{
	return [NSObject class];
}

+ (Class)defaultSerializer
{
	return [JObjectArraySerializer class];
}

- (NSString *)debugDescription
{
	return _array.debugDescription;
}

@end
