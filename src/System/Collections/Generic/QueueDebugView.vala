// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Diagnostics;

namespace System.Collections.Generic
{
    internal class QueueDebugView<T>
    {
        private   Queue<T> _queue;

        public QueueDebugView(Queue<T> queue)
        {
            if (queue == null)
            {
                throw ArgumentNullException("queue");
            }

            _queue = queue;
        }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

        public T[] Items
        {
            get
            {
                return _queue.ToArray();
            }
        }
    }
}
