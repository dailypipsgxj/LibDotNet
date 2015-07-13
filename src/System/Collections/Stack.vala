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

    public class Stack : Gee.LinkedList, ICollection
    {
        private Object[] _array;     // Storage for stack elements

        private int _size;           // Number of items in the stack.
        private int _version;        // Used to keep enumerator in sync w/ collection.
        private Object _syncRoot;

        private const int _defaultCapacity = 10;

        // Create a stack with a specific initial capacity.  The initial capacity
        // must be a non-negative number.
        public Stack(int initialCapacity = _defaultCapacity)
        {
            if (initialCapacity < 0)
                throw ArgumentOutOfRangeException("initialCapacity", SR.ArgumentOutOfRange_NeedNonNegNum);
            Contract.EndContractBlock();
            _size = 0;
            _version = 0;
            base();
        }

        // Fills a Stack with the contents of a particular collection.  The items are
        // pushed onto the stack in the same order they are read by the enumerator.
        //
        public Stack.WithCollection(ICollection col){
			this((col == null ? 32 : col.Count));
            Contract.EndContractBlock();
            IEnumerator en = col.GetEnumerator();
            while (en.MoveNext())
                Push(en.Current);
        }

        public virtual int Count
        {
            get
            {
                Contract.Ensures(Contract.Result<int>() >= 0);
                return _size;
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
                if (_syncRoot == null)
                {
                    System.Threading.Interlocked.CompareExchange<Object>(ref _syncRoot, new Object(), null);
                }
                return _syncRoot;
            }
        }

        // Removes all Objects from the Stack.
        public virtual void Clear()
        {
            Array.Clear(_array, 0, _size); // Don't need to doc this but we clear the elements so that the gc can reclaim the references.
            _size = 0;
            _version++;
        }

        public virtual Object Clone()
        {
            Contract.Ensures(Contract.Result<Object>() != null);

            Stack s = new Stack(_size);
            s._size = _size;
            Array.Copy(_array, 0, s._array, 0, _size);
            s._version = _version;
            return s;
        }

        public virtual bool Contains(Object obj)
        {
            int count = _size;

            while (count-- > 0)
            {
                if (obj == null)
                {
                    if (_array[count] == null)
                        return true;
                }
                else if (_array[count] != null && _array[count].Equals(obj))
                {
                    return true;
                }
            }
            return false;
        }

        // Copies the stack into an array.
        public virtual void CopyTo(Array array, int index)
        {
            if (array == null)
                throw ArgumentNullException("array");
            if (array.Rank != 1)
                throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
            if (index < 0)
                throw ArgumentOutOfRangeException("index", SR.ArgumentOutOfRange_NeedNonNegNum);
            if (array.Length - index < _size)
                throw ArgumentException(SR.Argument_InvalidOffLen);
            Contract.EndContractBlock();

            int i = 0;
            Object[] objArray = array as Object[];
            if (objArray != null)
            {
                while (i < _size)
                {
                    objArray[i + index] = _array[_size - i - 1];
                    i++;
                }
            }
            else
            {
                while (i < _size)
                {
                    array.SetValue(_array[_size - i - 1], i + index);
                    i++;
                }
            }
        }

        // Returns an IEnumerator for this Stack.
        public virtual IEnumerator GetEnumerator()
        {
            Contract.Ensures(Contract.Result<IEnumerator>() != null);
            return new StackEnumerator(this);
        }

        // Returns the topObjecton the stack without removing it.  If the stack
        // is empty, Peek throws an InvalidOperationException.
        public virtual Object Peek()
        {
            if (_size == 0)
                throw InvalidOperationException(SR.InvalidOperation_EmptyStack);
            Contract.EndContractBlock();
            return _array[_size - 1];
        }

        // Pops an item from the top of the stack.  If the stack is empty, Pop
        // throws an InvalidOperationException.
        public virtual Object Pop()
        {
            if (_size == 0)
                throw InvalidOperationException(SR.InvalidOperation_EmptyStack);
            //Contract.Ensures(Count == Contract.OldValue(Count) - 1);
            Contract.EndContractBlock();
            _version++;
            Object obj = _array[--_size];
            _array[_size] = null;     // Free memory quicker.
            return obj;
        }

        // Pushes an item to the top of the stack.
        // 
        public virtual void Push(Object obj)
        {
            //Contract.Ensures(Count == Contract.OldValue(Count) + 1);
            if (_size == _array.Length)
            {
                Object[] newArray = new Object[2 * _array.Length];
                Array.Copy(_array, 0, newArray, 0, _size);
                _array = newArray;
            }
            _array[_size++] = obj;
            _version++;
        }

        // Returns a synchronized Stack.
        //
        public static Stack Synchronized(Stack stack)
        {
            if (stack == null)
                throw ArgumentNullException("stack");
            Contract.Ensures(Contract.Result<Stack>() != null);
            Contract.EndContractBlock();
            return new SyncStack(stack);
        }


        // Copies the Stack to an array, in the same order Pop would return the items.
        public virtual Object[] ToArray()
        {
            Contract.Ensures(Contract.Result<Object[]>() != null);

            if (_size == 0)
                return Array.Empty<Object>();

            Object[] objArray = new Object[_size];
            int i = 0;
            while (i < _size)
            {
                objArray[i] = _array[_size - i - 1];
                i++;
            }
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


        private class StackEnumerator : IEnumerator
        {
            private Stack _stack;
            private int _index;
            private int _version;
            private Object _currentElement;

            internal StackEnumerator(Stack stack)
            {
                _stack = stack;
                _version = _stack._version;
                _index = -2;
                _currentElement = null;
            }

            public virtual bool MoveNext()
            {
                bool retval;
                if (_version != _stack._version) throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                if (_index == -2)
                {  // First call to enumerator.
                    _index = _stack._size - 1;
                    retval = (_index >= 0);
                    if (retval)
                        _currentElement = _stack._array[_index];
                    return retval;
                }
                if (_index == -1)
                {  // End of enumeration.
                    return false;
                }

                retval = (--_index >= 0);
                if (retval)
                    _currentElement = _stack._array[_index];
                else
                    _currentElement = null;
                return retval;
            }

            public virtual Object Current
            {
                get
                {
                    if (_index == -2) throw InvalidOperationException(SR.InvalidOperation_EnumNotStarted);
                    if (_index == -1) throw InvalidOperationException(SR.InvalidOperation_EnumEnded);
                    return _currentElement;
                }
            }

            public virtual void Reset()
            {
                if (_version != _stack._version) throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                _index = -2;
                _currentElement = null;
            }
        }

    }
}
