// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
** Class: CollectionBase
**
** Purpose: Provides the abstract base class for a strongly typed collection.
**
=============================================================================*/

using System;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    // Useful base class for typed read/write collections where items derive from Object

    public abstract class CollectionBase : Gee.AbstractList<Object>, Gee.List<Object>, IList, IEnumerable, ICollection
    {
        private ArrayList _list;

        protected CollectionBase(int capacity = 0)
        {
            _list = new ArrayList(capacity);
        }


        protected ArrayList InnerList
        {
            get
            {
                if (_list == null)
                    _list = new ArrayList();
                return _list;
            }
        }

        protected IList List
        {
            get { return (IList)this; }
        }

        public int Capacity
        {
            get
            {
                return InnerList.Capacity;
            }
            set
            {
                InnerList.Capacity = value;
            }
        }


        public int Count
        {
            get
            {
                return _list == null ? 0 : _list.Count;
            }
        }

        public void Clear()
        {
            OnClear();
            InnerList.Clear();
            OnClearComplete();
        }

        public void RemoveAt(int index)
        {
            if (index < 0 || index >= Count)
                throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
            Object temp = InnerList[index];
            OnValidate(temp);
            OnRemove(index, temp);
            InnerList.RemoveAt(index);
            try
            {
                OnRemoveComplete(index, temp);
            }
            catch
            {
                InnerList.Insert(index, temp);
                //////throw;
            }
        }

        bool IsReadOnly
        {
            get { return InnerList.IsReadOnly; }
        }

        bool IsFixedSize
        {
            get { return InnerList.IsFixedSize; }
        }

        bool IsSynchronized
        {
            get { return InnerList.IsSynchronized; }
        }

        Object SyncRoot
        {
            get { return InnerList.SyncRoot; }
        }

        void CopyTo(Array array, int index)
        {
            InnerList.CopyTo(array, index);
        }

        public new virtual Object get (int index) {
			if (index < 0 || index >= Count)
				throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
			return InnerList[index];
		}
		
		public new virtual void set (int index, Object value)
		{
			if (index < 0 || index >= Count)
				throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
			OnValidate(value);
			Object temp = InnerList[index];
			OnSet(index, temp, value);
			InnerList[index] = value;
			try
			{
				OnSetComplete(index, temp, value);
			}
			catch
			{
				InnerList[index] = temp;
				//////throw;
			}
		}

        bool Contains(Object value)
        {
            return InnerList.Contains(value);
        }

        int Add(Object value)
        {
            OnValidate(value);
            OnInsert(InnerList.Count, value);
            int index = InnerList.Add(value);
            try
            {
                OnInsertComplete(index, value);
            }
            catch
            {
                InnerList.RemoveAt(index);
                //////throw;
            }
            return index;
        }


        void Remove(Object value)
        {
            OnValidate(value);
            int index = InnerList.IndexOf(value);
            if (index < 0) throw new ArgumentException.NOTFOUND("SR.Arg_RemoveArgNotFound");
            OnRemove(index, value);
            InnerList.RemoveAt(index);
            try
            {
                OnRemoveComplete(index, value);
            }
            catch
            {
                InnerList.Insert(index, value);
                //////throw;
            }
        }

        int IndexOf(Object value)
        {
            return InnerList.IndexOf(value);
        }

        void Insert(int index, Object value)
        {
            if (index < 0 || index > Count)
                throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
            OnValidate(value);
            OnInsert(index, value);
            InnerList.Insert(index, value);
            try
            {
                OnInsertComplete(index, value);
            }
            catch
            {
                InnerList.RemoveAt(index);
                ////throw;
            }
        }

        public IEnumerator GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }

        protected virtual void OnSet(int index, Object oldValue, Object newValue)
        {
        }

        protected virtual void OnInsert(int index, Object value)
        {
        }

        protected virtual void OnClear()
        {
        }

        protected virtual void OnRemove(int index, Object value)
        {
        }

        protected virtual void OnValidate(Object value)
        {
            if (value == null) throw new ArgumentNullException.VALUE("value");
        }

        protected virtual void OnSetComplete(int index, Object oldValue, Object newValue)
        {
        }

        protected virtual void OnInsertComplete(int index, Object value)
        {
        }

        protected virtual void OnClearComplete()
        {
        }

        protected virtual void OnRemoveComplete(int index, Object value)
        {
        }
    }
}
