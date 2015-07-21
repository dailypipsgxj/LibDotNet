// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
//using System.Collections;
using System.Collections.Generic;
using System.Threading;

namespace System.Linq
{
	public abstract class Enumerable<TSource> : GLib.Object {
		
		public virtual IEnumerable<TSource> Where(Func<TSource, bool> predicate)
        {
            if (this is Iterator<TSource>) return ((Iterator<TSource>)this).Where(predicate);
            if (this is TSource[]) return new WhereArrayIterator<TSource>((TSource[])this, predicate);
            if (this is List) return new WhereListIterator<TSource>((List<TSource>)this, predicate);
            return new WhereEnumerableIterator<TSource>((IEnumerable<TSource>)this, predicate) as IEnumerable<TSource>;
        }
/*
		public virtual TSource[] ToArray()
		{
			return new Buffer<TSource>(this as IEnumerable<TSource>, false).ToArray();
		}

		public virtual TSource[] to_string() {
			return new Buffer<TSource>(this as IEnumerable<TSource>, false).ToArray();
		}
		*/

        //public abstract IEnumerable<TSource> Where<TSource>(Func<TSource, bool> predicate);
        //public abstract IEnumerable<TResult> Select<TSource, TResult>(Func<TSource, TResult> selector);
	}

	internal abstract class Iterator<TSource> : Enumerable<TSource>, IEnumerable<TSource>, IEnumerator<TSource>
	{
		private int _threadId;
		internal int state;
		internal TSource current;

		public Iterator()
		{
			//_threadId = Environment.CurrentManagedThreadId;
		}

		public TSource Current
		{
			owned get { return current; }
		}

		public new TSource get() {
			return current;
		}
		
		public abstract Iterator<TSource> Clone();

		public virtual void Dispose()
		{
			current = null; // default(TSource);
			state = -1;
		}

		public IEnumerator<TSource> iterator() {
			return GetEnumerator();
		}

		public IEnumerator<TSource> GetEnumerator()
		{
			/*
			if (state == 0 && _threadId == Environment.CurrentManagedThreadId)
			{
				state = 1;
				return this;
			}
			*/
			Iterator<TSource> duplicate = Clone();
			duplicate.state = 1;
			return duplicate;
		}

		public abstract bool MoveNext();

		public IEnumerable<TResult> Select<TResult>(Func<TSource, TResult> selector)
		{
			// This method is a generic virtual (actually abstract) in the original desktop source.
			// Once we have generic virtual's supported in the toolset, we can make this back into an abstract.
			//
			// This is a workaround implementation that does the "virtual dispatch" manually.

			if (this is WhereEnumerableIterator<TSource>)
				return ((WhereEnumerableIterator<TSource>)this).SelectImpl<TResult>(selector);

			if (this is WhereArrayIterator<TSource>)
				return ((WhereArrayIterator<TSource>)this).SelectImpl<TResult>(selector);

			if (this is WhereListIterator<TSource>)
				return ((WhereListIterator<TSource>)this).SelectImpl<TResult>(selector);

			// If we got here, then "this" is one of these types:
			//
			//    WhereSelectEnumerableIterator<TSource, some completely random type>
			//    WhereSelectArrayIterator<TSource, some completely random type>
			//    WhereSelectListIterator<TSource, some completely random type>
			//
			// Normally, this happens when you chain two consecutive Select<,>. There may be
			// some clever way to handle that second generic parameter within the limitations of the
			// static type system but it's a lot simpler just to break the chain by inserting 
			// a dummy Where(x => y) in the middle.
			//
			return new WhereEnumerableIterator<TSource>(this, x => true).SelectImpl<TResult>(selector);
		}

		public new abstract IEnumerable<TSource> Where(Func<TSource, bool> predicate);

		public virtual TSource[] ToArray()
		{
			return new Buffer<TSource>(this, false).ToArray();
		}
		
		void Reset()
		{
			throw new InvalidOperationException.NOT_IMPLEMENTED("Not implemented");
		}
	}

	internal class WhereEnumerableIterator<TSource> : Iterator<TSource>
	{
		private IEnumerable<TSource> _source;
		private Func<TSource, bool> _predicate;
		private IEnumerator<TSource> _enumerator;

		public WhereEnumerableIterator(IEnumerable<TSource> source, Func<TSource, bool> predicate)
		{
			_source = source;
			_predicate = predicate;
		}

		public override Iterator<TSource> Clone()
		{
			return new WhereEnumerableIterator<TSource>(_source, _predicate);
		}

		public override void Dispose()
		{
			if (_enumerator is IDisposable) ((IDisposable)_enumerator).Dispose();
			_enumerator = null;
			base.Dispose();
		}

		public override bool MoveNext()
		{
			switch (state)
			{
				case 1:
					_enumerator = _source.GetEnumerator();
					state = 2;
					return MoveNext();
					//goto case 2;
				case 2:
					while (_enumerator.MoveNext())
					{
						TSource item = _enumerator.Current;
						if (_predicate(item))
						{
							current = item;
							return true;
						}
					}
					Dispose();
					break;
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult> SelectImpl<TResult>(Func<TSource, TResult> selector)
		{
			return new WhereSelectEnumerableIterator<TSource, TResult>(_source, _predicate, selector);
		}

		public override IEnumerable<TSource> Where(Func<TSource, bool> predicate)
		{
			return new WhereEnumerableIterator<TSource>(_source, CombinePredicates(_predicate, predicate));
		}
	}

	internal class WhereArrayIterator<TSource> : Iterator<TSource>
	{
		private TSource[] _source;
		private Func<TSource, bool> _predicate;
		private int _index;

		public WhereArrayIterator(TSource[] source, Func<TSource, bool> predicate)
		{
			_source = source;
			_predicate = predicate;
		}

		public override Iterator<TSource> Clone()
		{
			return new WhereArrayIterator<TSource>(_source, _predicate);
		}

		public override bool MoveNext()
		{
			if (state == 1)
			{
				while (_index < _source.length)
				{
					TSource item = _source[_index];
					_index++;
					if (_predicate(item))
					{
						current = item;
						return true;
					}
				}
				Dispose();
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult> SelectImpl<TResult>(Func<TSource, TResult> selector)
		{
			return new WhereSelectArrayIterator<TSource, TResult>(_source, _predicate, selector);
		}

		public override IEnumerable<TSource> Where(Func<TSource, bool> predicate)
		{
			return new WhereArrayIterator<TSource>(_source, CombinePredicates(_predicate, predicate));
		}
	}

	internal class WhereListIterator<TSource> : Iterator<TSource>
	{
		private List<TSource> _source;
		private Func<TSource, bool> _predicate;
		private List.Enumerator<TSource> _enumerator;

		public WhereListIterator(List<TSource> source, Func<TSource, bool> predicate)
		{
			_source = source;
			_predicate = predicate;
		}

		public override Iterator<TSource> Clone()
		{
			return new WhereListIterator<TSource>(_source, _predicate);
		}


		public override bool MoveNext()
		{
			switch (state)
			{
				case 1:
					_enumerator = (List.Enumerator<TSource>)_source.GetEnumerator();
					state = 2;
					return MoveNext();
					//goto case 2;
				case 2:
					while (_enumerator.MoveNext())
					{
						TSource item = _enumerator.Current;
						if (_predicate(item))
						{
							current = item;
							return true;
						}
					}
					Dispose();
					break;
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult> SelectImpl<TResult>(Func<TSource, TResult> selector)
		{
			return new WhereSelectListIterator<TSource, TResult>(_source, _predicate, selector);
		}

		public override IEnumerable<TSource> Where(Func<TSource, bool> predicate)
		{
			return new WhereListIterator<TSource>(_source, CombinePredicates(_predicate, predicate));
		}

	}

	internal class WhereSelectEnumerableIterator<TSource, TResult> : Iterator<TResult>
	{
		private IEnumerable<TSource> _source;
		private Func<TSource, bool> _predicate;
		private Func<TSource, TResult> _selector;
		private IEnumerator<TSource> _enumerator;

		public WhereSelectEnumerableIterator(IEnumerable<TSource> source, Func<TSource, bool> predicate, Func<TSource, TResult> selector)
		{
			_source = source;
			_predicate = predicate;
			_selector = selector;
		}

		public override Iterator<TResult> Clone()
		{
			return new WhereSelectEnumerableIterator<TSource, TResult>(_source, _predicate, _selector);
		}

		public override void Dispose()
		{
			if (_enumerator is IDisposable) ((IDisposable)_enumerator).Dispose();
			_enumerator = null;
			base.Dispose();
		}

		public override bool MoveNext()
		{
			switch (state)
			{
				case 1:
					_enumerator = _source.GetEnumerator();
					state = 2;
					return MoveNext();
				case 2:
					while (_enumerator.MoveNext())
					{
						TSource item = _enumerator.Current;
						if (_predicate == null || _predicate(item))
						{
							current = _selector(item);
							return true;
						}
					}
					Dispose();
					break;
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult2> SelectImpl<TResult2>(Func<TResult, TResult2> selector)
		{
			return new WhereSelectEnumerableIterator<TSource, TResult2>(_source, _predicate, CombineSelectors(_selector, selector));
		}

		public override IEnumerable<TResult> Where(Func<TResult, bool> predicate)
		{
			return new WhereEnumerableIterator<TResult>(this, predicate);
		}


	}

	internal class WhereSelectArrayIterator<TSource, TResult> : Iterator<TResult>
	{
		private TSource[] _source;
		private Func<TSource, bool> _predicate;
		private Func<TSource, TResult> _selector;
		private int _index;

		public WhereSelectArrayIterator(TSource[] source, Func<TSource, bool> predicate, Func<TSource, TResult> selector)
		{
			_source = source;
			_predicate = predicate;
			_selector = selector;
		}

		public override Iterator<TResult> Clone()
		{
			return new WhereSelectArrayIterator<TSource, TResult>(_source, _predicate, _selector);
		}

		public override bool MoveNext()
		{
			if (state == 1)
			{
				while (_index < _source.length)
				{
					TSource item = _source[_index];
					_index++;
					if (_predicate == null || _predicate(item))
					{
						current = _selector(item);
						return true;
					}
				}
				Dispose();
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult2> SelectImpl<TResult2>(Func<TResult, TResult2> selector)
		{
			return new WhereSelectArrayIterator<TSource, TResult2>(_source, _predicate, CombineSelectors(_selector, selector));
		}

		public override IEnumerable<TResult> Where(Func<TResult, bool> predicate)
		{
			return new WhereEnumerableIterator<TResult>(this, predicate);
		}

		public override TResult[] ToArray()
		{
			if (_predicate != null)
			{
				return base.ToArray();
			}

			var results = new TResult[_source.length];
			for (int i = 0; i < results.length; i++)
			{
				results[i] = _selector(_source[i]);
			}
			return results;
		}
	}

	internal class WhereSelectListIterator<TSource, TResult> : Iterator<TResult>
	{
		private List<TSource> _source;
		private Func<TSource, bool> _predicate;
		private Func<TSource, TResult> _selector;
		private List.Enumerator<TSource> _enumerator;

		public WhereSelectListIterator(List<TSource> source, Func<TSource, bool> predicate, Func<TSource, TResult> selector)
		{
			_source = source;
			_predicate = predicate;
			_selector = selector;
		}

		public override Iterator<TResult> Clone()
		{
			return new WhereSelectListIterator<TSource, TResult>(_source, _predicate, _selector);
		}

		public override bool MoveNext()
		{
			switch (state)
			{
				case 1:
					_enumerator = (List.Enumerator)_source.GetEnumerator();
					state = 2;
					break;
					//goto case 2;
				case 2:
					while (_enumerator.MoveNext())
					{
						TSource item = _enumerator.Current;
						if (_predicate == null || _predicate(item))
						{
							current = _selector(item);
							return true;
						}
					}
					Dispose();
					break;
			}
			return false;
		}

		// Once we have generic virtual support back, rename this back to Select and turn it into an override of the parent's abstract Select() method.
		public IEnumerable<TResult2> SelectImpl<TResult2>(Func<TResult, TResult2> selector)
		{
			return new WhereSelectListIterator<TSource, TResult2>(_source, _predicate, CombineSelectors(_selector, selector));
		}

		public override IEnumerable<TResult> Where(Func<TResult, bool> predicate)
		{
			return new WhereEnumerableIterator<TResult>(this, predicate);
		}

		public override TResult[] ToArray()
		{
			if (_predicate != null)
			{
				return base.ToArray();
			}

			var results = new TResult[_source.Count];
			for (int i = 0; i < results.length; i++)
			{
				results[i] = _selector(_source[i]);
			}
			return results;
		}
	}

    internal class Buffer<TElement>
    {
        public TElement[] items;
        public int count;

        internal Buffer(IEnumerable<TElement> source, bool queryInterfaces = true)
        {
            TElement[] items = null;
            int count = 0;

            if (queryInterfaces)
            {
                Iterator<TElement> iterator = source as Iterator<TElement>;
                if (iterator != null)
                {
                    items = iterator.ToArray();
                    count = items.length;
                }
                else
                {
                    ICollection<TElement> collection = source as ICollection<TElement>;
                    if (collection != null)
                    {
                        count = collection.Count;
                        if (count > 0)
                        {
                            items = new TElement[count];
                            collection.CopyTo(items, 0);
                        }
                    }
                }
            }

            if (items == null)
            {
                foreach (TElement item in source)
                {
                    if (items == null)
                    {
                        items = new TElement[4];
                    }
                    else if (items.length == count)
                    {
						int newSize = count * 2;
						if (items.length != newSize) {
							TElement[] newArray = new TElement[newSize];
							int i = 0;
							foreach (var it in items) {
								newArray[i++] = it;
							}
							items = newArray;
						}
                    }
                    items[count] = item;
                    count++;
                }
            }

            this.items = items;
            this.count = count;
        }

        internal TElement[] ToArray()
        {
            if (count == 0) return new TElement[0];
            if (this.items.length == count) return this.items;

            var arr = new TElement[count];
            int i = 0;
			foreach (var item in this.items) {
				arr[i++] = item;
			}
            return arr;
        }
    }

	private static Func<TSource, bool> CombinePredicates<TSource>(Func<TSource, bool> predicate1, Func<TSource, bool> predicate2)
	{
		return x => predicate1(x) && predicate2(x);
	}

	private static Func<TSource, TResult> CombineSelectors<TSource, TMiddle, TResult> (
		Func<TSource, TMiddle> selector1,
		Func<TMiddle, TResult> selector2 )
	{
		return (x)=> { return selector2(selector1(x));};
	}

}
