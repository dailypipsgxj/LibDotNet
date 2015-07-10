// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
// [DebuggerTypeProxy(typeof(IDictionaryDebugView<,>))]

// [DebuggerDisplay("Count = {Count}")]

    public class SortedDictionary<TKey, TValue> : Gee.TreeMap<TKey, TValue>, IDictionary<TKey, TValue>, IDictionary, IReadOnlyDictionary<TKey, TValue>
    {
        private KeyCollection _keys;

        private ValueCollection _values;
        
        private IComparer keyComparer;

        //private TreeSet<KeyValuePair<TKey, TValue>> _set;


        public SortedDictionary(IComparer<TKey>? comparer = null)
        {
			base (comparer);
			keyComparer = comparer;
        }

        public SortedDictionary.FromDictionary(IDictionary<TKey, TValue> dictionary, IComparer<TKey>? comparer = null)
        {

        }

        bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair<TKey, TValue>>? comparer = null)
        {

        }

        bool IsReadOnly
        {
            get
            {
                return false;
            }
        }

        public TValue get (TKey key) {
			return base.get (key);
		}

        public void set (TKey key) {
			base.set (key, value);
        }

        public int Count
        {
            get
            {
                return size;
            }
        }

        public IComparer<TKey> Comparer
        {
            get
            {
                return ((KeyValuePairComparer)keyComparer);
            }
        }

        public KeyCollection Keys
        {
            get
            {
                if (_keys == null) _keys = new KeyCollection(this);
                return _keys;
            }
        }


        public ValueCollection Values
        {
            get
            {
                if (_values == null) _values = new ValueCollection(this);
                return _values;
            }
        }


        public void Add(TKey key, TValue value)
        {
            base.set(key, value);
        }

        public void Clear()
        {
            clear();
        }

        public bool ContainsKey(TKey key)
        {
            return has_key(key);
        }

        public bool ContainsValue(TValue value)
        {
			if (value in base.values)
				return true;
            return false;
        }


        public Enumerator GetEnumerator()
        {
            return new Enumerator(this, Enumerator.KeyValuePair);
        }

        public bool Remove(TKey key)
        {
            return unset(key);
        }

        public bool TryGetValue(TKey key, out TValue value)
        {
			
			if (has_key (key)) {
				value = base.get (key);
				return true;
			} else {
                value = default(TValue);
                return false;
			}
        }

        void CopyTo(Array array, int index)
        {
            //((ICollection)_set).CopyTo(array, index);
        }

        bool IsFixedSize
        {
            get { return false; }
        }


        bool IsSynchronized
        {
            get { return false; }
        }
        
        Object SyncRoot
        {
            get { return ((ICollection)_set).SyncRoot; }
        }

        [Compact]
        public class Enumerator : IEnumerator<KeyValuePair<TKey, TValue>>, IDictionaryEnumerator
        {
            /*
            private Gee.TreeMap<KeyValuePair<TKey, TValue>>.Enumerator _treeEnum;
            private int _getEnumeratorRetType;  // What should Enumerator.Current return?

            internal const int KeyValuePair = 1;
            internal const int DictEntry = 2;
            */

            internal Enumerator(SortedDictionary<TKey, TValue> dictionary, int getEnumeratorRetType)
            {
              //  _treeEnum = dictionary._set.GetEnumerator();
              //  _getEnumeratorRetType = getEnumeratorRetType;
            }

            public bool MoveNext()
            {
                //return _treeEnum.MoveNext();
            }

            public void Dispose()
            {
                //_treeEnum.Dispose();
            }

            public KeyValuePair<TKey, TValue> Current
            {
                get
                {
                   // return _treeEnum.Current;
                }
            }

            internal bool NotStartedOrEnded
            {
                get
                {
                    //return _treeEnum.NotStartedOrEnded;
                }
            }

            internal void Reset()
            {
                //_treeEnum.Reset();
            }


            Object Key
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw new InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return Current.Key;
                }
            }

            Object Value
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw new InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return Current.Value;
                }
            }

            DictionaryEntry Entry
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw new InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return new DictionaryEntry(Current.Key, Current.Value);
                }
            }
        }
       

        public class KeyCollection : ICollection<TKey>, ICollection, IReadOnlyCollection<TKey>
        {
            private SortedDictionary<TKey, TValue> _dictionary;

            public KeyCollection(SortedDictionary<TKey, TValue> dictionary)
            {
                if (dictionary == null)
                {
                    throw ArgumentNullException("dictionary");
                }
                _dictionary = dictionary;
            }

            public Enumerator GetEnumerator()
            {
                return new Enumerator(_dictionary);
            }

            public void CopyTo(TKey[] array, int index)
            {
                if (array == null)
                {
                    throw ArgumentNullException("array");
                }

                if (index < 0)
                {
                    throw ArgumentOutOfRangeException("index");
                }

                if (array.Length - index < Count)
                {
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                }

                _dictionary._set.InOrderTreeWalk((node) => { array[index++] = node.Item.Key; return true; });
            }

            void ICollection.CopyTo(Array array, int index)
            {
                if (array == null)
                {
                    throw ArgumentNullException("array");
                }

                if (array.Rank != 1)
                {
                    throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
                }

                if (array.GetLowerBound(0) != 0)
                {
                    throw ArgumentException(SR.Arg_NonZeroLowerBound);
                }

                if (index < 0)
                {
                    throw ArgumentOutOfRangeException("arrayIndex", SR.ArgumentOutOfRange_NeedNonNegNum);
                }

                if (array.Length - index < _dictionary.Count)
                {
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                }

                TKey[] keys = array as TKey[];
                if (keys != null)
                {
                    CopyTo(keys, index);
                }
                else
                {
                    Object[] objects = (Object[])array;
                    if (objects == null)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }

                    try
                    {
                        _dictionary._set.InOrderTreeWalk((node) => { objects[index++] = node.Item.Key; return true; });
                    }
                    catch (ArrayTypeMismatchException e)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }
                }
            }




            Object SyncRoot
            {
                get { return ((ICollection)_dictionary).SyncRoot; }
            }
            
// [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
// [Compact]

            public class Enumerator : IEnumerator<TKey>, IEnumerator
            {
                private SortedDictionary.Enumerator _dictEnum;

                internal Enumerator(SortedDictionary<TKey, TValue> dictionary)
                {
                    _dictEnum = dictionary.GetEnumerator();
                }

                public void Dispose()
                {
                    _dictEnum.Dispose();
                }

                public bool MoveNext()
                {
                    return _dictEnum.MoveNext();
                }

                public TKey Current
                {
                    get
                    {
                        return _dictEnum.Current.Key;
                    }
                }
                
                Object CurrentObj
                {
                    get
                    {
                        if (_dictEnum.NotStartedOrEnded)
                        {
                            throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                        }

                        return Current;
                    }
                }

                void IEnumerator.Reset()
                {
                    _dictEnum.Reset();
                }
            }
        }
// [DebuggerTypeProxy(typeof(DictionaryValueCollectionDebugView<,>))]

// [DebuggerDisplay("Count = {Count}")]

        public class ValueCollection : ICollection<TValue>, ICollection, IReadOnlyCollection<TValue>
        {
            private SortedDictionary<TKey, TValue> _dictionary;

            public ValueCollection(SortedDictionary<TKey, TValue> dictionary)
            {
                if (dictionary == null)
                {
                    throw ArgumentNullException("dictionary");
                }
                _dictionary = dictionary;
            }

            public Enumerator GetEnumerator()
            {
                return new Enumerator(_dictionary);
            }

            public void CopyTo(TValue[] array, int index)
            {
                if (array == null)
                {
                    throw ArgumentNullException("array");
                }

                if (index < 0)
                {
                    throw ArgumentOutOfRangeException("index");
                }

                if (array.Length - index < Count)
                {
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                }

                _dictionary._set.InOrderTreeWalk((node) => { array[index++] = node.Item.Value; return true; });
            }

            void ICollection.CopyTo(Array array, int index)
            {
                if (array == null)
                {
                    throw ArgumentNullException("array");
                }

                if (array.Rank != 1)
                {
                    throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
                }

                if (array.GetLowerBound(0) != 0)
                {
                    throw ArgumentException(SR.Arg_NonZeroLowerBound);
                }

                if (index < 0)
                {
                    throw ArgumentOutOfRangeException("arrayIndex", SR.ArgumentOutOfRange_NeedNonNegNum);
                }

                if (array.Length - index < _dictionary.Count)
                {
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                }

                TValue[] values = array as TValue[];
                if (values != null)
                {
                    CopyTo(values, index);
                }
                else
                {
                    Object[] objects = (Object[])array;
                    if (objects == null)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }

                    try
                    {
                        _dictionary._set.InOrderTreeWalk((node) => { objects[index++] = node.Item.Value; return true; });
                    }
                    catch (ArrayTypeMismatchException e)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }
                }
            }


            
// [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
// [Compact]

            public class Enumerator : IEnumerator<TValue>, IEnumerator
            {
                public Enumerator(SortedDictionary<TKey, TValue> dictionary)
                {
                    _dictEnum = dictionary.GetEnumerator();
                }

                public void Dispose()
                {
                    _dictEnum.Dispose();
                }

                public bool MoveNext()
                {
                    return _dictEnum.MoveNext();
                }

                public TValue Current
                {
                    get
                    {
                        if (_dictEnum.NotStartedOrEnded)
                        {
                            throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                        }

                        return _dictEnum.Current.Value;
                    }
                }

                void IEnumerator.Reset()
                {
                    _dictEnum.Reset();
                }
            }
        }

        internal class KeyValuePairComparer : Comparer<KeyValuePair<TKey, TValue>>
        {
            internal IComparer<TKey> keyComparer;

            public KeyValuePairComparer(IComparer<TKey> keyComparer)
            {
                if (keyComparer == null)
                {
                    this.keyComparer = Comparer<TKey>.Default;
                }
                else
                {
                    this.keyComparer = keyComparer;
                }
            }

            public override int Compare(KeyValuePair<TKey, TValue> x, KeyValuePair<TKey, TValue> y)
            {
                return keyComparer.Compare(x.Key, y.Key);
            }
        }
    }


}
