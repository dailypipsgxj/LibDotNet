// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
// [DebuggerTypeProxy(typeof(IDictionaryDebugView<,>))]

// [DebuggerDisplay("Count = {Count}")]

    public class SortedDictionary<TKey, TValue> : IDictionary<TKey, TValue>, IDictionary, IReadOnlyDictionary<TKey, TValue>
    {
        private KeyCollection _keys;

        private ValueCollection _values;

        private TreeSet<KeyValuePair<TKey, TValue>> _set;


        public SortedDictionary(IDictionary<TKey, TValue>? dictionary = null, IComparer<TKey>? comparer = null)
        {
            if (dictionary == null)
            {
                throw ArgumentNullException("dictionary");
            }

            _set = new TreeSet<KeyValuePair<TKey, TValue>>(new KeyValuePairComparer(comparer));

            foreach (KeyValuePair<TKey, TValue> pair in dictionary)
            {
                _set.Add(pair);
            }
        }

        bool Contains(KeyValuePair<TKey, TValue> keyValuePair)
        {
            TreeSet.Node node = _set.FindNode(keyValuePair);
            if (node == null)
            {
                return false;
            }

            if (keyValuePair.Value == null)
            {
                return node.Item.Value == null;
            }
            else
            {
                return EqualityComparer<TValue>.Default.Equals(node.Item.Value, keyValuePair.Value);
            }
        }

        bool Remove(KeyValuePair<TKey, TValue> keyValuePair)
        {
            TreeSet.Node node = _set.FindNode(keyValuePair);
            if (node == null)
            {
                return false;
            }

            if (EqualityComparer<TValue>.Default.Equals(node.Item.Value, keyValuePair.Value))
            {
                _set.Remove(keyValuePair);
                return true;
            }
            return false;
        }

        bool IsReadOnly
        {
            get
            {
                return false;
            }
        }

        public TValue get (TKey key) {
			if (key == null)
			{
				throw ArgumentNullException("key");
			}

			TreeSet.Node node = _set.FindNode(KeyValuePair<TKey, TValue>(key, default(TValue)));
			if (node == null)
			{
				throw KeyNotFoundException();
			}

			return node.Item.Value;
		}

         public void set (TKey key) {
			if (key == null)
			{
				throw ArgumentNullException("key");
			}

			TreeSet.Node node = _set.FindNode(KeyValuePair<TKey, TValue>(key, default(TValue)));
			if (node == null)
			{
				_set.Add(KeyValuePair<TKey, TValue>(key, value));
			}
			else
			{
				node.Item = KeyValuePair<TKey, TValue>(node.Item.Key, value);
				_set.UpdateVersion();
			}
        }

        public int Count
        {
            get
            {
                return _set.Count;
            }
        }

        public IComparer<TKey> Comparer
        {
            get
            {
                return ((KeyValuePairComparer)_set.Comparer).keyComparer;
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
            if (key == null)
            {
                throw ArgumentNullException("key");
            }
            _set.Add(new KeyValuePair<TKey, TValue>(key, value));
        }

        public void Clear()
        {
            _set.Clear();
        }

        public bool ContainsKey(TKey key)
        {
            if (key == null)
            {
                throw ArgumentNullException("key");
            }

            return _set.Contains(new KeyValuePair<TKey, TValue>(key, default(TValue)));
        }

        public bool ContainsValue(TValue value)
        {
            bool found = false;
            if (value == null)
            {
                _set.InOrderTreeWalk(delegate (TreeSet.Node node)
                {
                    if (node.Item.Value == null)
                    {
                        found = true;
                        return false;  // stop the walk
                    }
                    return true;
                });
            }
            else
            {
                EqualityComparer<TValue> valueComparer = EqualityComparer<TValue>.Default;
                _set.InOrderTreeWalk(delegate (TreeSet.Node node)
                {
                    if (valueComparer.Equals(node.Item.Value, value))
                    {
                        found = true;
                        return false;  // stop the walk
                    }
                    return true;
                });
            }
            return found;
        }

        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int index)
        {
            _set.CopyTo(array, index);
        }

        public Enumerator GetEnumerator()
        {
            return Enumerator(this, Enumerator.KeyValuePair);
        }

        public bool Remove(TKey key)
        {
            if (key == null)
            {
                throw ArgumentNullException("key");
            }

            return _set.Remove(KeyValuePair<TKey, TValue>(key, default(TValue)));
        }

        public bool TryGetValue(TKey key, out TValue value)
        {
            if (key == null)
            {
                throw ArgumentNullException("key");
            }

            TreeSet.Node node = _set.FindNode(KeyValuePair<TKey, TValue>(key, default(TValue)));
            if (node == null)
            {
                value = default(TValue);
                return false;
            }
            value = node.Item.Value;
            return true;
        }

        void CopyTo(Array array, int index)
        {
            ((ICollection)_set).CopyTo(array, index);
        }

        bool IsFixedSize
        {
            get { return false; }
        }

       
        Object get (Object key) {
			if (IsCompatibleKey(key))
			{
				TValue value;
				if (TryGetValue((TKey)key, out value))
				{
					return value;
				}
			}

			return null;
		}
        
        public void set (Object key) 
		{
			if (key == null)
			{
				throw ArgumentNullException("key");
			}

			if (value == null && !(default(TValue) == null))
				throw ArgumentNullException("value");

			try
			{
				TKey tempKey = (TKey)key;
				try
				{
					this[tempKey] = (TValue)value;
				}
				catch (InvalidCastException e)
				{
					throw ArgumentException(SR.Format(SR.Arg_WrongType, value, typeof(TValue)), "value");
				}
				finally {}
			}
			catch (InvalidCastException e)
			{
				throw ArgumentException(SR.Format(SR.Arg_WrongType, key, typeof(TKey)), "key");
			}
		}

        void Add(Object key, Object value)
        {
            if (key == null)
            {
                throw ArgumentNullException("key");
            }

            if (value == null && !(default(TValue) == null))
                throw ArgumentNullException("value");

            try
            {
                TKey tempKey = (TKey)key;

                try
                {
                    Add(tempKey, (TValue)value);
                }
                catch (InvalidCastException e)
                {
                    throw ArgumentException(SR.Format(SR.Arg_WrongType, value, typeof(TValue)), "value");
                }
            }
            catch (InvalidCastException e)
            {
                throw ArgumentException(SR.Format(SR.Arg_WrongType, key, typeof(TKey)), "key");
            }
        }

        bool Contains(Object key)
        {
            if (IsCompatibleKey(key))
            {
                return ContainsKey((TKey)key);
            }
            return false;
        }

        private static bool IsCompatibleKey(Object key)
        {
            if (key == null)
            {
                throw ArgumentNullException("key");
            }

            return (key is TKey);
        }

        IDictionaryEnumerator GetEnumerator()
        {
            return Enumerator(this, Enumerator.DictEntry);
        }

        void 
        Remove(Object key)
        {
            if (IsCompatibleKey(key))
            {
                Remove((TKey)key);
            }
        }

        bool IsSynchronized
        {
            get { return false; }
        }
        
        Object SyncRoot
        {
            get { return ((ICollection)_set).SyncRoot; }
        }

        IEnumerator GetEnumerator()
        {
            return new Enumerator(this, Enumerator.KeyValuePair);
        }
        
// [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
		[Compact]
        public class Enumerator : IEnumerator, IDictionaryEnumerator
        {
            private TreeSet.Enumerator _treeEnum;
            private int _getEnumeratorRetType;  // What should Enumerator.Current return?

            internal const int KeyValuePair = 1;
            internal const int DictEntry = 2;

            public Enumerator(SortedDictionary<TKey, TValue> dictionary, int getEnumeratorRetType)
            {
                _treeEnum = dictionary._set.GetEnumerator();
                _getEnumeratorRetType = getEnumeratorRetType;
            }

            public bool MoveNext()
            {
                return _treeEnum.MoveNext();
            }

            public void Dispose()
            {
                _treeEnum.Dispose();
            }

            public KeyValuePair<TKey, TValue> Current
            {
                get
                {
                    return _treeEnum.Current;
                }
            }

            internal bool NotStartedOrEnded
            {
                get
                {
                    return _treeEnum.NotStartedOrEnded;
                }
            }

            internal void Reset()
            {
                _treeEnum.Reset();
            }


            void Reset()
            {
                _treeEnum.Reset();
            }
            
            Object Current
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    if (_getEnumeratorRetType == DictEntry)
                    {
                        return DictionaryEntry(Current.Key, Current.Value);
                    }
                    else
                    {
                        return KeyValuePair<TKey, TValue>(Current.Key, Current.Value);
                    }
                }
            }
            
            Object Key
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
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
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return Current.Value;
                }
            }

            DictionaryEntry IDictionaryEnumerator.Entry
            {
                get
                {
                    if (NotStartedOrEnded)
                    {
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return DictionaryEntry(Current.Key, Current.Value);
                }
            }
        }
// [DebuggerTypeProxy(typeof(DictionaryKeyCollectionDebugView<,>))]

// [DebuggerDisplay("Count = {Count}")]

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

                _dictionary._set.InOrderTreeWalk(delegate (TreeSet.Node node) { array[index++] = node.Item.Key; return true; });
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
                    object[] objects = (object[])array;
                    if (objects == null)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }

                    try
                    {
                        _dictionary._set.InOrderTreeWalk(delegate (TreeSet.Node node) { objects[index++] = node.Item.Key; return true; });
                    }
                    catch (ArrayTypeMismatchException)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }
                }
            }

            public int Count
            {
                get { return _dictionary.Count; }
            }

            bool IsReadOnly
            {
                get { return true; }
            }

            void Add(TKey item)
            {
                throw NotSupportedException(SR.NotSupported_KeyCollectionSet);
            }

            void Clear()
            {
                throw NotSupportedException(SR.NotSupported_KeyCollectionSet);
            }

            bool Contains(TKey item)
            {
                return _dictionary.ContainsKey(item);
            }

            bool Remove(TKey item)
            {
                throw NotSupportedException(SR.NotSupported_KeyCollectionSet);
            }

            bool IsSynchronized
            {
                get { return false; }
            }

            Object SyncRoot
            {
                get { return ((ICollection)_dictionary).SyncRoot; }
            }
            
// [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
			
			[Compact]
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
                
                Object Current
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

                _dictionary._set.InOrderTreeWalk(delegate (TreeSet.Node node) { array[index++] = node.Item.Value; return true; });
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
                    object[] objects = (object[])array;
                    if (objects == null)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }

                    try
                    {
                        _dictionary._set.InOrderTreeWalk(delegate (TreeSet.Node node) { objects[index++] = node.Item.Value; return true; });
                    }
                    catch (ArrayTypeMismatchException)
                    {
                        throw ArgumentException(SR.Argument_InvalidArrayType);
                    }
                }
            }

            public int Count
            {
                get { return _dictionary.Count; }
            }

            bool IsReadOnly
            {
                get { return true; }
            }

            void Add(TValue item)
            {
                throw NotSupportedException(SR.NotSupported_ValueCollectionSet);
            }

            void Clear()
            {
                throw NotSupportedException(SR.NotSupported_ValueCollectionSet);
            }

            bool Contains(TValue item)
            {
                return _dictionary.ContainsValue(item);
            }

            bool Remove(TValue item)
            {
                throw NotSupportedException(SR.NotSupported_ValueCollectionSet);
            }

            bool IsSynchronized
            {
                get { return false; }
            }

            Object SyncRoot
            {
                get { return ((ICollection)_dictionary).SyncRoot; }
            }
            
// [SuppressMessage("Microsoft.Performance", "CA1815:OverrideEqualsAndOperatorEqualsOnValueTypes", Justification = "not an expected scenario")]
			[Compact]
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

    /// <summary>
    /// This class is intended as a helper for backwards compatibility with existing SortedDictionaries.
    /// TreeSet has been converted into SortedSet<T>, which will be exposed publicly. SortedDictionaries
    /// have the problem where they have already been serialized to disk as having a backing class named
    /// TreeSet. To ensure that we can read back anything that has already been written to disk, we need to
    /// make sure that we have a class named TreeSet that does everything the way it used to.
    /// 
    /// The only thing that makes it different from SortedSet is that it throws on duplicates
    /// </summary>
    /// <typeparam name="T"></typeparam>
    internal class TreeSet<T> : SortedSet<T>
    {

        public TreeSet(ICollection<T> collection, IComparer<T> comparer){
			base(collection, comparer); }

        internal override bool AddIfNotPresent(T item)
        {
            bool ret = base.AddIfNotPresent(item);
            if (!ret)
            {
                throw ArgumentException(SR.Argument_AddingDuplicate);
            }
            return ret;
        }
    }
}
