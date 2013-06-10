// ======================================================================================
// Copyright (c) 2013, Christian Fruth, Boxx IT Solutions e.K.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of the Boxx IT Solutions e.K. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ======================================================================================

#import "JFloatArraySerializer.h"
#import "Kryo.h"

@implementation JFloatArraySerializer

- (BOOL)acceptsNull
{
	return YES;
}

- (void)write:(Kryo *)kryo value:(id)value to:(KryoOutput *)output
{
	if (value == nil)
	{
		[output writeByte:IS_NULL];
		return;
	}
	
	JFloatArray *array = value;
	const float *floatValues = [array floatValues];
	NSUInteger length = array.count;
	
	[output writeInt:(SInt32)length + 1 optimizePositive:YES];
	
	for (NSUInteger i = 0; i < length; ++i)
	{
		[output writeFloat:floatValues[i]];
	}
}

- (id)read:(Kryo *)kryo withClass:(Class)type from:(KryoInput *)input
{
	SInt32 length = [input readIntOptimizePositive:YES];
	
	if (length == IS_NULL)
	{
		return nil;
	}
	
	JFloatArray *newArray = [JFloatArray arrayWithCapacity:length - 1];
	
	for (NSUInteger i = 0; i < length - 1; ++i)
	{
		[newArray addValue:[input readFloat]];
	}
	
	return newArray;
}

@end