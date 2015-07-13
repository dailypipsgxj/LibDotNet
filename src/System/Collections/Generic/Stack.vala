// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
**
** Purpose: An array implementation of a generic stack.
**
**
=============================================================================*/
using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
    // A simple stack of objects.  Internally it is implemented as an array,
    // so Push can be O(n).  Pop is O(1).

    public class Stack<T> : Gee.LinkedList<T>, IEnumerable<T>, ICollection<T>, IReadOnlyCollection<T>
    {
        private Object _syncRoot;

        private const int DefaultCapacity = 4;

        // Create a stack with a specific initial capacity.  The initial capacity
        // must be a non-negative number.
        public Stack(int capacity = DefaultCapacity)
        {
			base ();
        }

        // Fills a Stack with the contents of a particular collection.  The items are
        // pushed onto the stack in the same order they are read by the enumerator.
        //
        public Stack.FromCollection(IEnumerable<T> collection)
        {
            /*
             foreach (T item in collection) {
                add (item.Key, item.Value);
            }
            */

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


        IEnumerator<T> GetEnumerator()
        {
            return new Enumerator(this);
        }


        public void TrimExcess()
        {
        }

        // Returns the topObjecton the stack without removing it.  If the stack
        // is empty, Peek throws an InvalidOperationException.
        public T Peek()
        {
			var poke = peek ();
            if (poke == null)
                throw InvalidOperationException("SR.InvalidOperation_EmptyStack");
            return poke;
        }

        // Pops an item from the top of the stack.  If the stack is empty, Pop
        // throws an InvalidOperationException.
        public T Pop()
        {
			var pop = poll();
            if (pop == null)
                throw InvalidOperationException("SR.InvalidOperation_EmptyStack");
            return pop;
        }

        // Pushes an item to the top of the stack.
        // 
        public void Push(T item)
        {
			add (item);
        }

        // Copies the Stack to an array, in the same order Pop would return the items.
        public T[] ToArray()
        {
            T[] objArray = new T[size];
            int i = 0;
            foreach (var item in this) {
                objArray[i] = item;
                i++;
            }
            return objArray;
        }

		[Compact]
        public class Enumerator : IEnumerator<T>, System.Collections.IEnumerator
        {
            public Stack<T> _stack;
            public T _currentElement;
			public Gee.Iterator _iterator;

            public Enumerator(Stack<T> stack)
            {
                _stack = stack;
                _iterator = stack.iterator ();
                _currentElement = default(T);
            }

            public void Dispose()
            {
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
				iterator = stack.list_iterator();
                _currentElement = default(T);
            }
        }
    }
}
