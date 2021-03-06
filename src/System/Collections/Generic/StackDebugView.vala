// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Diagnostics;

namespace System.Collections.Generic
{
    internal class StackDebugView<T>
    {
        private   Stack<T> _stack;

        public StackDebugView(Stack<T> stack)
        {
            if (stack == null)
            {
                throw ArgumentNullException("stack");
            }

            _stack = stack;
        }

        public T[] Items
        {
            get
            {
                return _stack.ToArray();
            }
        }
    }
}
