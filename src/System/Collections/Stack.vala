// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
** Class: Stack
**
** Purpose: Represents a simple last-in-first-out (LIFO)
**          non-generic collection of objects.
**
**
=============================================================================*/

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    // A simple stack of objects.  Internally it is implemented as an array,
    // so Push can be O(n).  Pop is O(1).

    public class Stack : Gee.LinkedList<Object>, ICollection, IEnumerable
    {
        private Object _syncRoot;

        private const int _defaultCapacity = 10;

        // Create a stack with a specific initial capacity.  The initial capacity
        // must be a non-negative number.
        public Stack(int initialCapacity = _defaultCapacity)
        {
            base();
        }

        // Fills a Stack with the contents of a particular collection.  The items are
        // pushed onto the stack in the same order they are read by the enumerator.
        //
        public Stack.WithCollection(ICollection col){
            IEnumerator en = col.GetEnumerator();
            while (en.MoveNext())
                Push(en.Current);
        }

        public virtual int Count
        {
            get
            {
                return size;
            }
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

        // Removes all Objects from the Stack.
        public virtual void Clear()
        {
        }

        public virtual Object Clone()
        {
            Stack s = new Stack(size);
            return s;
        }

        public virtual bool Contains(Object obj)
        {
            return false;
        }

        // Copies the stack into an array.
        public virtual void CopyTo(Array array, int index)
        {
        }

        // Returns an IEnumerator for this Stack.
        public virtual IEnumerator GetEnumerator()
        {
            return new StackEnumerator(this);
        }

        // Returns the topObjecton the stack without removing it.  If the stack
        // is empty, Peek throws an InvalidOperationException.
        public virtual Object Peek()
        {
            return this as Object;
        }

        // Pops an item from the top of the stack.  If the stack is empty, Pop
        // throws an InvalidOperationException.
        public virtual Object Pop()
        {
            return this as Object;
        }

        // Pushes an item to the top of the stack.
        // 
        public virtual void Push(Object obj)
        {
        }

        // Returns a synchronized Stack.
        //
        public static Stack Synchronized(Stack stack)
        {
            return new SyncStack(stack);
        }


        // Copies the Stack to an array, in the same order Pop would return the items.
        public virtual Object[] ToArray()
        {
            Object[] objArray = new Object[size];
            return objArray;
        }

        private class SyncStack : Stack
        {
            private Stack _s;
            private Object _root;

            internal SyncStack(Stack stack)
            {
                _s = stack;
                _root = stack.SyncRoot;
            }

            public override bool IsSynchronized
            {
                get { return true; }
            }

            public override Object SyncRoot
            {
                get
                {
                    return _root;
                }
            }

            public override int Count
            {
                get
                {
                    lock (_root)
                    {
                        return _s.Count;
                    }
                }
            }

            public override bool Contains(Object obj)
            {
                lock (_root)
                {
                    return _s.Contains(obj);
                }
            }

            public override Object Clone()
            {
                lock (_root)
                {
                    return new SyncStack((Stack)_s.Clone());
                }
            }

            public override void Clear()
            {
                lock (_root)
                {
                    _s.Clear();
                }
            }

            public override void CopyTo(Array array, int arrayIndex)
            {
                lock (_root)
                {
                    _s.CopyTo(array, arrayIndex);
                }
            }

            public override void Push(Object value)
            {
                lock (_root)
                {
                    _s.Push(value);
                }
            }

            public override Object Pop()
            {
                lock (_root)
                {
                    return _s.Pop();
                }
            }

            public override IEnumerator GetEnumerator()
            {
                lock (_root)
                {
                    return _s.GetEnumerator();
                }
            }

            public override Object Peek()
            {
                lock (_root)
                {
                    return _s.Peek();
                }
            }

            public override Object[] ToArray()
            {
                lock (_root)
                {
                    return _s.ToArray();
                }
            }
        }


        private class StackEnumerator : Object, IEnumerator
        {
            private Stack _stack;
			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}

            internal StackEnumerator(Stack stack)
            {
                _stack = stack;
                _currentElement = null;
            }

            public virtual bool MoveNext()
            {
                return false;
            }

            public virtual Object Current
            {
                owned get
                {
                    return _currentElement;
                }
            }

            public virtual void Reset()
            {
                _currentElement = null;
            }
        }

    }
}
