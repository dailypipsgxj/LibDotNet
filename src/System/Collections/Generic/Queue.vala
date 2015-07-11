// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
**
** Purpose: A circular-array implementation of a generic queue.
**
**
=============================================================================*/
using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
    // A simple Queue of generic objects.  Internally it is implemented as a 
    // circular buffer, so Enqueue can be O(n).  Dequeue is O(1).
// [DebuggerTypeProxy(typeof(QueueDebugView<>))]

// [DebuggerDisplay("Count = {Count}")]

    public class Queue<T> :
		Gee.PriorityQueue<T>,
		IEnumerable<T>,
		ICollection<T>,
		System.Collections.ICollection,
        IReadOnlyCollection<T>
    {
        private T[] _array;
        private int _head;       // First valid element in the queue
        private int _tail;       // Last valid element in the queue
        private int _size;       // Number of elements.
        private int _version;
        private Object _syncRoot;

        private const int MinimumGrow = 4;
        private const int GrowFactor = 200;  // double each time
        private const int DefaultCapacity = 4;

        // Creates a queue with room for capacity objects. The default grow factor
        // is used.
        //
        public Queue(int capacity = DefaultCapacity)
        {
            if (capacity < 0)
                throw new ArgumentOutOfRangeException("capacity SR.ArgumentOutOfRange_NeedNonNegNumRequired");
            base();
        }

        // Fills a Queue with the elements of an ICollection.  Uses the enumerator
        // to get each of the elements.
        //
        public Queue.FromCollection(IEnumerable<T> collection)
        {
			base();
            IEnumerator<T> en = collection.GetEnumerator();
            while (en.MoveNext())
                {
                    Enqueue(en.Current);
                }
        }


        public int Count
        {
            get { return size; }
        }

        bool IsSynchronized
        {
            get { return false; }
        }

        Object SyncRoot
        {
            get
            {
                return _syncRoot;
            }
        }

        // Adds item to the tail of the queue.
        //
        public void Enqueue(T item)
        {
			offer(item);
        }

        // GetEnumerator returns an IEnumerator over this Queue.  This
        // Enumerator will support removing.
        // 
        public Enumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        // Removes the Object at the head of the queue and returns it. If the queue
        // is empty, this method simply returns null.
        public T Dequeue()
        {
            return poll();
        }

        // Returns theObjectat the head of the queue. TheObjectremains in the
        // queue. If the queue is empty, this method throws an 
        // InvalidOperationException.
        public T Peek()
        {
            return peek ();
        }


        // Iterates over the objects in the queue, returning an array of the
        // objects in the Queue, or an empty array if the queue is empty.
        // The order of elements in the array is first in to last in, the same
        // order produced by successive calls to Dequeue.
        public T[] ToArray()
        {
            return to_array();
        }


        // PRIVATE Grows or shrinks the buffer to hold capacity objects. Capacity
        // must be >= _size.
        private void SetCapacity(int capacity)
        {
        }

        public void TrimExcess()
        {
        }

        // Implements an enumerator for a Queue.  The enumerator uses the
        // internal version number of the list to ensure that no modifications are
        // made to the list while an enumeration is in progress.

		[Compact]
        public class Enumerator : IEnumerator<T>,
            System.Collections.IEnumerator
        {
            private Queue<T> _q;
			private Gee.Iterator _iterator;
            private T _currentElement;

            internal Enumerator(Queue<T> q)
            {
                _q = q;
                _iterator = q.iterator();
                _currentElement = default(T);
            }

            public void Dispose()
            {
                _currentElement = default(T);
            }


            public T Current
            {
                get
                {
                    return _currentElement;
                }
            }

            void Reset()
            {
                _iterator = q.iterator();
                _currentElement = default(T);
            }
        }
    }
}
