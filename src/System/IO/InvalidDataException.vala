// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;

namespace System.IO
{
    public class InvalidDataException : Exception
    {

        public InvalidDataException(string? message = null, Exception? innerException = null){
			if (string == null) {
				base(SR.GenericInvalidData);
			} else {
				base(message, innerException);
			}
        }
    }
}
