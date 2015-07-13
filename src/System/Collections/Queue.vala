// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
** Class: Queue
**
** Purpose: Represents a first-in, first-out collection of objects.
**
=============================================================================*/

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    // A simple Queue of objects.  Internally it is implemented as a circular
    // buffer, so Enqueue can be O(n).  Dequeue is O(1).

    public class Queue : Gee.PriorityQueue, ICollection
    {
        private Object _syncRoot;

        // Creates a queue with room for capacity objects. When full, the new
        // capacity is set to the old capacity * growFactor.
        //
        public Queue(int capacity = 32, float growFactor = 2.0)
        {
            base();
        }

        // Fills a Queue with the elements of an ICollection.  Uses the enumerator
        // to get each of the elements.
        //
        public Queue.WithCollection(ICollection col){
			this(col.Count);
            IEnumerator en = col.GetEnumerator();
            while (en.MoveNext())
                Enqueue(en.Current);
        }


        public virtual int Count
        {
            get { return _size; }
        }

        public virtual Object Clone()
        {
            Queue q = new Queue(_size);
            return q;
        }

        public virtual bool IsSynchronized
        {
            get { return false; }
        }

        public virtual Object SyncRoot
        {
            get
            {
                return _syncRoot;
            }
        }

        // Removes all Objects from the queue.
        public virtual void Clear()
        {
        }

        // CopyTo copies a collection into an Array, starting at a particular
        // index into the array.
        // 
        public virtual void CopyTo(Array array, int index)
        {
        }

        // Adds obj to the tail of the queue.
        //
        public virtual void Enqueue(Object obj)
        {
        }

        // GetEnumerator returns an IEnumerator over this Queue.  This
        // Enumerator will support removing.
        // 
        public virtual IEnumerator GetEnumerator()
        {
            return new QueueEnumerator(this);
        }

        // Removes theObjectat the head of the queue and returns it. If the queue
        // is empty, this method simply returns null.
        public virtual Object Dequeue()
        {
            return new Object();
        }

        // Returns theObjectat the head of the queue. TheObjectremains in the
        // queue. If the queue is empty, this method throws an 
        // InvalidOperationException.
        public virtual Object Peek()
        {

        }

        // Returns a synchronized Queue.  Returns a synchronized wrapper
        // class around the queue - the caller must not use references to the
        // original queue.
        // 
        public static Queue Synchronized(Queue queue)
        {
            return new SynchronizedQueue(queue);
        }

        // Returns true if the queue contains at least oneObjectequal to obj.
        // Equality is determined using obj.Equals().
        //
        // Exceptions: ArgumentNullException if obj == null.
        public virtual bool Contains(Object obj)
        {
            return false;
        }

        internal Object GetElement(int i)
        {
            return -1;
        }

        // Iterates over the objects in the queue, returning an array of the
        // objects in the Queue, or an empty array if the queue is empty.
        // The order of elements in the array is first in to last in, the same
        // order produced by successive calls to Dequeue.
        public virtual Object[] ToArray()
        {
           Object[] arr = new Object[size];
            return arr;
        }


        // PRIVATE Grows or shrinks the buffer to hold capacity objects. Capacity
        // must be >= _size.
        private void SetCapacity(int capacity)
        {
        }

        public virtual void TrimToSize()
        {
        }


        // Implements a synchronization wrapper around a queue.
        public class SynchronizedQueue : Queue
        {
            private Queue _q;
            private Object _root;

            internal SynchronizedQueue(Queue q)
            {

            }

            public override bool IsSynchronized
            {
                get { return true; }
            }

            public override Object SyncRoot
            {
                get { return _root; }
            }

            public override int Count
            {
                get
                {
                    lock (_root)
                    {
                        return _q.Count;
                    }
                }
            }

            public override void Clear()
            {
                lock (_root)
                {
                    _q.Clear();
                }
            }

            public override Object Clone()
            {
                lock (_root)
                {
                    return new SynchronizedQueue((Queue)_q.Clone());
                }
            }

            public override bool Contains(Object obj)
            {
                lock (_root)
                {
                    return _q.Contains(obj);
                }
            }

            public override void CopyTo(Array array, int arrayIndex)
            {
                lock (_root)
                {
                    _q.CopyTo(array, arrayIndex);
                }
            }

            public override void Enqueue(Object value)
            {
                lock (_root)
                {
                    _q.Enqueue(value);
                }
            }

            public override Object Dequeue()
            {
                lock (_root)
                {
                    return _q.Dequeue();
                }
            }

            public override IEnumerator GetEnumerator()
            {
                lock (_root)
                {
                    return _q.GetEnumerator();
                }
            }

            public override Object Peek()
            {
                lock (_root)
                {
                    return _q.Peek();
                }
            }

            public override Object[] ToArray()
            {
                lock (_root)
                {
                    return _q.ToArray();
                }
            }

            public override void TrimToSize()
            {
                lock (_root)
                {
                    _q.TrimToSize();
                }
            }
        }

        // Implements an enumerator for a Queue.  The enumerator uses the
        // internal version number of the list to ensure that no modifications are
        // made to the list while an enumeration is in progress.
        public class QueueEnumerator : IEnumerator
        {
            private Queue _q;
            private Object _currentElement;

            internal QueueEnumerator(Queue q)
            {
            }

            public virtual bool MoveNext()
            {
                return true;
            }

            public virtual Object Current
            {
                get
                {
                    return _currentElement;
                }
            }

            public virtual void Reset()
            {
            }
        }

    }
}
