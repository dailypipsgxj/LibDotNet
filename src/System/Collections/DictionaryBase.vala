// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  DictionaryBase
**
** Purpose: Provides the abstract base class for a
**          strongly typed collection of key/value pairs.
**
===========================================================*/

using System;

namespace System.Collections
{
    // Useful base class for typed read/write collections where items derive from Object
    
    public abstract class DictionaryBase : Gee.AbstractMap<Object,Object>, IDictionary, IEnumerable, ICollection
    {
        private Hashtable _hashtable;

        protected Hashtable InnerHashtable
        {
            get
            {
                if (_hashtable == null)
                    _hashtable = new Hashtable();
                return _hashtable;
            }
        }

        protected IDictionary Dictionary
        {
            get { return (IDictionary)this; }
        }

        public int Count
        {
            // to avoid newing inner list if no items are ever added
            get { return _hashtable == null ? 0 : _hashtable.Count; }
        }

        bool IsReadOnly
        {
            get { return InnerHashtable.IsReadOnly; }
        }

        bool IsFixedSize
        {
            get { return InnerHashtable.IsFixedSize; }
        }

        bool IsSynchronized
        {
            get { return InnerHashtable.IsSynchronized; }
        }

        ICollection Keys
        {
            owned get { return InnerHashtable.Keys; }
        }

        Object SyncRoot
        {
            get { return InnerHashtable.SyncRoot; }
        }

        ICollection Values
        {
            owned get { return InnerHashtable.Values; }
        }

        public void CopyTo(Array array, int index)
        {
            InnerHashtable.CopyTo(array, index);
        }
        
        public new virtual Object get (Object key)
		{
			Object currentValue = InnerHashtable[key];
			OnGet(key, currentValue);
			return currentValue;
		}

        public new virtual void set (Object key, Object value)
        {
			OnValidate(key, value);
			bool keyExists = true;
			Object temp = InnerHashtable[key];
			if (temp == null)
			{
				keyExists = InnerHashtable.Contains(key);
			}

			OnSet(key, temp, value);
			InnerHashtable[key] = value;
			try
			{
				OnSetComplete(key, temp, value);
			}
			catch
			{
				if (keyExists)
				{
					InnerHashtable[key] = temp;
				}
				else
				{
					InnerHashtable.Remove(key);
				}
				//////throw;
			}
		}

        bool Contains(Object key)
        {
            return InnerHashtable.Contains(key);
        }

        void Add(Object key, Object value)
        {
            OnValidate(key, value);
            OnInsert(key, value);
            InnerHashtable.Add(key, value);
            try
            {
                OnInsertComplete(key, value);
            }
            catch
            {
                InnerHashtable.Remove(key);
                //////throw;
            }
        }

        public void Clear()
        {
            OnClear();
            InnerHashtable.Clear();
            OnClearComplete();
        }

        public void Remove(Object key)
        {
            if (InnerHashtable.Contains(key))
            {
                Object temp = InnerHashtable[key];
                OnValidate(key, temp);
                OnRemove(key, temp);

                InnerHashtable.Remove(key);
                try
                {
                    OnRemoveComplete(key, temp);
                }
                catch
                {
                    InnerHashtable.Add(key, temp);
                    //////throw;
                }
            }
        }


        public IDictionaryEnumerator GetEnumerator()
        {
            return InnerHashtable.GetEnumerator();
        }

        protected virtual Object OnGet(Object key,Object currentValue)
        {
            return currentValue;
        }

        protected virtual void OnSet(Object key, Object oldValue, Object newValue)
        {
        }

        protected virtual void OnInsert(Object key, Object value)
        {
        }

        protected virtual void OnClear()
        {
        }

        protected virtual void OnRemove(Object key, Object value)
        {
        }

        protected virtual void OnValidate(Object key, Object value)
        {
        }

        protected virtual void OnSetComplete(Object key, Object oldValue, Object newValue)
        {
        }

        protected virtual void OnInsertComplete(Object key, Object value)
        {
        }

        protected virtual void OnClearComplete()
        {
        }

        protected virtual void OnRemoveComplete(Object key, Object value)
        {
        }
    }
}
