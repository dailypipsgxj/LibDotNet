// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
// [DebuggerTypeProxy(typeof(ICollectionDebugView<>))]
// [DebuggerDisplay("Count = {Count}")]

    public class LinkedList<T> : Gee.LinkedList, ICollection<T>, System.Collections.ICollection, IReadOnlyCollection<T>
    {
        // This LinkedList is a doubly-Linked circular list.
        internal LinkedListNode<T> head;
        internal int count;
        internal int version;
        private Object _syncRoot;

        public LinkedList(IEnumerable<T> collection)
        {
            if (collection == null)
            {
                throw ArgumentNullException("collection");
            }

            foreach (T item in collection)
            {
                AddLast(item);
            }
        }

        public int Count
        {
            get { return count; }
        }

        public LinkedListNode<T> First
        {
            get { return head; }
        }

        public LinkedListNode<T> Last
        {
            get { return head == null ? null : head.prev; }
        }

        bool IsReadOnly
        {
            get { return false; }
        }

        void Add(T value)
        {
            AddLast(value);
        }

        public LinkedListNode<T> AddAfter(LinkedListNode<T> node, T value)
        {
            ValidateNode(node);
            LinkedListNode<T> result;
            
            
            if (value is LinkedListNode<T>) {
				result = value;
				ValidateNewNode(result);
				result.list = this;
			} else {
				result = new LinkedListNode<T>(node.list, value);
			}
            
            InternalInsertNodeBefore(node.next, result);
            return result;
        }


        public LinkedListNode<T> AddBefore(LinkedListNode<T> node, T value)
        {
            ValidateNode(node);
            LinkedListNode<T> result;
            
            if (value is LinkedListNode<T>) {
				result = value;
				ValidateNewNode(result);
				result.list = this;
			} else {
				result = new LinkedListNode<T>(node.list, value);
			}

            InternalInsertNodeBefore(node, result);
            
            if (node == head)
            {
                head = result;
            }
            return result;
        }

        public LinkedListNode<T> AddFirst(T value)
        {

            LinkedListNode<T> result;
            
            if (value is LinkedListNode<T>) {
				result = value;
				ValidateNewNode(result);
				result.list = this;
			} else {
				result = new LinkedListNode<T>(this, value);
			}

            if (head == null)
            {
                InternalInsertNodeToEmptyList(result);
            }
            else
            {
                InternalInsertNodeBefore(head, result);
                head = result;
            }
            return result;
        }

        public LinkedListNode<T> AddLast(T value)
        {

            LinkedListNode<T> result;
            
            if (value is LinkedListNode<T>) {
				result = value;
				ValidateNewNode(result);
				result.list = this;
			} else {
				result = new LinkedListNode<T>(this, value);
			}

            if (head == null)
            {
                InternalInsertNodeToEmptyList(result);
            }
            else
            {
                InternalInsertNodeBefore(head, result);
            }
            return result;
        }


        public void Clear()
        {
            LinkedListNode<T> current = head;
            while (current != null)
            {
                LinkedListNode<T> temp = current;
                current = current.Next;   // use Next the instead of "next", otherwise it will loop forever
                temp.Invalidate();
            }

            head = null;
            count = 0;
            version++;
        }

        public bool Contains(T value)
        {
            return Find(value) != null;
        }

        public void CopyTo(T[] array, int index)
        {
            if (array == null)
            {
                throw ArgumentNullException("array");
            }

            if (index < 0 || index > array.Length)
            {
                throw ArgumentOutOfRangeException("index", SR.Format(SR.IndexOutOfRange, index));
            }

            if (array.Length - index < Count)
            {
                throw ArgumentException(SR.Arg_InsufficientSpace);
            }

            LinkedListNode<T> node = head;
            if (node != null)
            {
                do
                {
                    array[index++] = node.item;
                    node = node.next;
                } while (node != head);
            }
        }

        public LinkedListNode<T> Find(T value)
        {
            LinkedListNode<T> node = head;
            EqualityComparer<T> c = EqualityComparer<T>.Default;
            if (node != null)
            {
                if (value != null)
                {
                    do
                    {
                        if (c.Equals(node.item, value))
                        {
                            return node;
                        }
                        node = node.next;
                    } while (node != head);
                }
                else
                {
                    do
                    {
                        if (node.item == null)
                        {
                            return node;
                        }
                        node = node.next;
                    } while (node != head);
                }
            }
            return null;
        }

        public LinkedListNode<T> FindLast(T value)
        {
            if (head == null) return null;

            LinkedListNode<T> last = head.prev;
            LinkedListNode<T> node = last;
            EqualityComparer<T> c = EqualityComparer<T>.Default;
            if (node != null)
            {
                if (value != null)
                {
                    do
                    {
                        if (c.Equals(node.item, value))
                        {
                            return node;
                        }

                        node = node.prev;
                    } while (node != last);
                }
                else
                {
                    do
                    {
                        if (node.item == null)
                        {
                            return node;
                        }
                        node = node.prev;
                    } while (node != last);
                }
            }
            return null;
        }

        public Enumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        public bool Remove(T value)
        {
			
			LinkedListNode<T> node;
			
            if (value is LinkedListNode<T>) {
				node = value;
				ValidateNode(node);
			} else {
				node = Find(value);
			}
            if (node != null)
            {
                InternalRemoveNode(node);
                return true;
            }
            return false;
        }

        public void RemoveFirst()
        {
            if (head == null) { throw InvalidOperationException(SR.LinkedListEmpty); }
            InternalRemoveNode(head);
        }

        public void RemoveLast()
        {
            if (head == null) { throw InvalidOperationException(SR.LinkedListEmpty); }
            InternalRemoveNode(head.prev);
        }

        private void InternalInsertNodeBefore(LinkedListNode<T> node, LinkedListNode<T> newNode)
        {
            newNode.next = node;
            newNode.prev = node.prev;
            node.prev.next = newNode;
            node.prev = newNode;
            version++;
            count++;
        }

        private void InternalInsertNodeToEmptyList(LinkedListNode<T> newNode)
        {
            Debug.Assert(head == null && count == 0, "LinkedList must be empty when this method is called!");
            newNode.next = newNode;
            newNode.prev = newNode;
            head = newNode;
            version++;
            count++;
        }

        internal void InternalRemoveNode(LinkedListNode<T> node)
        {
            Debug.Assert(node.list == this, "Deleting the node from another list!");
            Debug.Assert(head != null, "This method shouldn't be called on empty list!");
            if (node.next == node)
            {
                Debug.Assert(count == 1 && head == node, "this should only be true for a list with only one node");
                head = null;
            }
            else
            {
                node.next.prev = node.prev;
                node.prev.next = node.next;
                if (head == node)
                {
                    head = node.next;
                }
            }
            node.Invalidate();
            count--;
            version++;
        }

        internal void ValidateNewNode(LinkedListNode<T> node)
        {
            if (node == null)
            {
                throw ArgumentNullException("node");
            }

            if (node.list != null)
            {
                throw InvalidOperationException(SR.LinkedListNodeIsAttached);
            }
        }


        internal void ValidateNode(LinkedListNode<T> node)
        {
            if (node == null)
            {
                throw ArgumentNullException("node");
            }

            if (node.list != this)
            {
                throw InvalidOperationException(SR.ExternalLinkedListNode);
            }
        }

        bool IsSynchronized
        {
            get { return false; }
        }

        Object SyncRoot
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

        void System.Collections.ICollection.CopyTo(Array array, int index)
        {
            if (array == null)
            {
                throw ArgumentNullException("array");
            }

            if (array.Rank != 1)
            {
                throw ArgumentException(SR.Arg_MultiRank);
            }

            if (array.GetLowerBound(0) != 0)
            {
                throw ArgumentException(SR.Arg_NonZeroLowerBound);
            }

            if (index < 0)
            {
                throw ArgumentOutOfRangeException("index", SR.Format(SR.IndexOutOfRange, index));
            }

            if (array.Length - index < Count)
            {
                throw ArgumentException(SR.Arg_InsufficientSpace);
            }

            T[] tArray = array as T[];
            if (tArray != null)
            {
                CopyTo(tArray, index);
            }
            else
            {
                // No need to use reflection to verify that the types are compatible because it isn't 100% correct and we can rely 
                // on the runtime validation during the cast that happens below (i.e. we will get an ArrayTypeMismatchException).
                Object[] objects = array as Object[];
                if (objects == null)
                {
                    throw ArgumentException(SR.Invalid_Array_Type);
                }
                LinkedListNode<T> node = head;
                try
                {
                    if (node != null)
                    {
                        do
                        {
                            objects[index++] = node.item;
                            node = node.next;
                        } while (node != head);
                    }
                }
                catch (ArrayTypeMismatchException e)
                {
                    throw ArgumentException(SR.Invalid_Array_Type);
                }
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        // [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
        [Compact]
        public class Enumerator : IEnumerator<T>, System.Collections.IEnumerator
        {
            private LinkedList<T> _list;
            private LinkedListNode<T> _node;
            private int _version;
            private T _current;
            private int _index;

            public Enumerator(LinkedList<T> list)
            {
                _list = list;
                _version = list.version;
                _node = list.head;
                _current = default(T);
                _index = 0;
            }

            public Object Current
            {
                get
                {
                    if (_index == 0 || (_index == _list.Count + 1))
                    {
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return _current;
                }
            }

            public bool MoveNext()
            {
                if (_version != _list.version)
                {
                    throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                }

                if (_node == null)
                {
                    _index = _list.Count + 1;
                    return false;
                }

                ++_index;
                _current = _node.item;
                _node = _node.next;
                if (_node == _list.head)
                {
                    _node = null;
                }
                return true;
            }

            void System.Collections.IEnumerator.Reset()
            {
                if (_version != _list.version)
                {
                    throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                }

                _current = default(T);
                _node = _list.head;
                _index = 0;
            }

            public void Dispose()
            {
            }
        }
    }

    // Note following class is not serializable since we customized the serialization of LinkedList. 
    public class LinkedListNode<T>
    {
        internal LinkedList<T> list;
        internal LinkedListNode<T> next;
        internal LinkedListNode<T> prev;
        internal T item;

        internal LinkedListNode(LinkedList<T>? list = null, T value)
        {
            if (list != null) this.list = list;
            this.item = value;
        }

        public LinkedList<T> List
        {
            get { return list; }
        }

        public LinkedListNode<T> Next
        {
            get { return next == null || next == list.head ? null : next; }
        }

        public LinkedListNode<T> Previous
        {
            get { return prev == null || this == list.head ? null : prev; }
        }

        public T Value
        {
            get { return item; }
            set { item = value; }
        }

        internal void Invalidate()
        {
            list = null;
            next = null;
            prev = null;
        }
    }
}

