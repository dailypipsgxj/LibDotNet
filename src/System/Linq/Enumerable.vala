// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
//using System.Collections;
using System.Collections.Generic;
using System.Threading;

namespace System.Linq
{
    public abstract class Enumerable
    {
        public static IEnumerable<TSource> Where<TSource>(IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            if (source is Iterator<TSource>) return ((Iterator<TSource>)source).Where(predicate);
            if (source is TSource[]) return new WhereArrayIterator<TSource>((TSource[])source, predicate);
            if (source is List<TSource>) return new WhereListIterator<TSource>((List<TSource>)source, predicate);
            return new WhereEnumerableIterator<TSource>(source, predicate);
        }

        private static IEnumerable<TSource> WhereIterator<TSource>(IEnumerable<TSource> source, Func<TSource, int, bool> predicate)
        {
            int index = -1;
            foreach (TSource element in source)
            {
                //checked = { index++; }
                if (predicate(element, index)) yield return element;
            }
        }

        public static IEnumerable<TResult> Select<TSource, TResult>(IEnumerable<TSource> source, Func<TSource, TResult> selector)
        {
            if (source is Iterator<TSource>) return ((Iterator<TSource>)source).Select(selector);
            if (source is TSource[]) return new WhereSelectArrayIterator<TSource, TResult>((TSource[])source, null, selector);
            if (source is List<TSource>) return new WhereSelectListIterator<TSource, TResult>((List<TSource>)source, null, selector);
            return new WhereSelectEnumerableIterator<TSource, TResult>(source, null, selector);
        }


        private static IEnumerable<TResult> SelectIterator<TSource, TResult>(IEnumerable<TSource> source, Func<TSource, int, TResult> selector)
        {
            int index = -1;
            foreach (TSource element in source)
            {
                //checked { index++; }
                yield return selector(element, index);
            }
        }

        private static Func<TSource, bool> CombinePredicates<TSource>(Func<TSource, bool> predicate1, Func<TSource, bool> predicate2)
        {
            return x => predicate1(x) && predicate2(x);
        }

        private static Func<TSource, TResult> CombineSelectors<TSource, TMiddle, TResult>(Func<TSource, TMiddle> selector1, Func<TMiddle, TResult> selector2)
        {
            return x => selector2(selector1(x));
        }

        internal abstract class Iterator<TSource> : IEnumerable<TSource>, IEnumerator<TSource>
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
                get { return current; }
            }

            public abstract Iterator<TSource> Clone();

            public virtual void Dispose()
            {
                current = null; // default(TSource);
                state = -1;
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

            public abstract IEnumerable<TSource> Where(Func<TSource, bool> predicate);

            public virtual TSource[] ToArray()
            {
                return Buffer<TSource>(this, queryInterfaces = false).ToArray();
            }
            
            void Reset()
            {
                throw new InvalidOperationException.NOTIMPLEMENTED("Not implemented");
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
                        _enumerator = _source.GetEnumerator();
                        state = 2;
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
            private List.Enumerator _enumerator;

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
                        _enumerator = _source.GetEnumerator();
                        state = 2;
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



        public static IEnumerable<TResult> SelectMany<TSource, TCollection, TResult>( IEnumerable<TSource> source, Func<TSource, IEnumerable<TCollection>> collectionSelector, Func<TSource, TCollection, TResult> resultSelector)
        {
            return SelectManyIterator<TSource, TCollection, TResult>(source, collectionSelector, resultSelector);
        }

        private static IEnumerable<TResult> SelectManyIterator<TSource, TCollection, TResult>(IEnumerable<TSource> source, Func<TSource, IEnumerable<TCollection>> collectionSelector, Func<TSource, TCollection, TResult> resultSelector)
        {
            foreach (TSource element in source)
            {
                foreach (TCollection subElement in collectionSelector(element))
                {
                    yield return resultSelector(element, subElement);
                }
            }
        }

        public static IEnumerable<TSource> Take<TSource>( IEnumerable<TSource> source, int count)
        {
            return TakeIterator<TSource>(source, count);
        }

        private static IEnumerable<TSource> TakeIterator<TSource>(IEnumerable<TSource> source, int count)
        {
            if (count > 0)
            {
                foreach (TSource element in source)
                {
                    yield return element;
                    if (--count == 0) break;
                }
            }
        }

        public static IEnumerable<TSource> TakeWhile<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            return TakeWhileIterator<TSource>(source, predicate);
        }

        private static IEnumerable<TSource> TakeWhileIterator<TSource>(IEnumerable<TSource> source, Func<TSource, int, bool> predicate)
        {
            int index = -1;
            foreach (TSource element in source)
            {
                //checked { index++; }
                if (!predicate(element, index)) break;
                yield return element;
            }
        }

        public static IEnumerable<TSource> Skip<TSource>( IEnumerable<TSource> source, int count)
        {
            return SkipIterator<TSource>(source, count);
        }

        private static IEnumerable<TSource> SkipIterator<TSource>(IEnumerable<TSource> source, int count)
        {
            IEnumerator<TSource> e = source.GetEnumerator();
            while (count > 0 && e.MoveNext()) count--;
            if (count <= 0)
                {
                    while (e.MoveNext()) yield return e.Current;
                }
        }


        private static IEnumerable<TSource> SkipWhileIterator<TSource>(IEnumerable<TSource> source, Func<TSource, int, bool> predicate)
        {
            int index = -1;
            bool yielding = false;
            foreach (TSource element in source)
            {
                //checked { index++; }
                if (!yielding && !predicate(element, index)) yielding = true;
                if (yielding) yield return element;
            }
        }

        public static IEnumerable<TResult> Join<TOuter, TInner, TKey, TResult>( IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, TInner, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            return JoinIterator<TOuter, TInner, TKey, TResult>(outer, inner, outerKeySelector, innerKeySelector, resultSelector, comparer);
        }

        private static IEnumerable<TResult> JoinIterator<TOuter, TInner, TKey, TResult>(IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, TInner, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            Lookup<TKey, TInner> lookup = Lookup<TKey, TInner>.CreateForJoin(inner, innerKeySelector, comparer);
            foreach (TOuter item in outer)
            {
                Grouping<TKey, TInner> g = lookup.GetGrouping(outerKeySelector(item), false);
                if (g != null)
                {
                    for (int i = 0; i < g.count; i++)
                    {
                        yield return resultSelector(item, g.elements[i]);
                    }
                }
            }
        }

        public static IEnumerable<TResult> GroupJoin<TOuter, TInner, TKey, TResult>( IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, IEnumerable<TInner>, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            return GroupJoinIterator<TOuter, TInner, TKey, TResult>(outer, inner, outerKeySelector, innerKeySelector, resultSelector, comparer);
        }

        private static IEnumerable<TResult> GroupJoinIterator<TOuter, TInner, TKey, TResult>(IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, IEnumerable<TInner>, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            Lookup<TKey, TInner> lookup = Lookup<TKey, TInner>.CreateForJoin(inner, innerKeySelector, comparer);
            foreach (TOuter item in outer)
            {
                yield return resultSelector(item, lookup[outerKeySelector(item)]);
            }
        }

        public static IOrderedEnumerable<TSource> OrderBy<TSource, TKey>( IEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
        {
            return new OrderedEnumerable<TSource, TKey>(source, keySelector, comparer, false);
        }

        public static IOrderedEnumerable<TSource> OrderByDescending<TSource, TKey>( IEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
        {
            return new OrderedEnumerable<TSource, TKey>(source, keySelector, comparer, true);
        }

        public static IOrderedEnumerable<TSource> ThenBy<TSource, TKey>( IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
        {
            return source.CreateOrderedEnumerable<TKey>(keySelector, comparer, false);
        }


        public static IOrderedEnumerable<TSource> ThenByDescending<TSource, TKey>( IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
        {
            return source.CreateOrderedEnumerable<TKey>(keySelector, comparer, true);
        }

        public static IEnumerable<TResult> GroupBy<TSource, TKey, TElement, TResult>( IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, Func<TKey, IEnumerable<TElement>, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            return new GroupedEnumerable<TSource, TKey, TElement, TResult>(source, keySelector, elementSelector, resultSelector, comparer);
        }

        public static IEnumerable<TSource> Concat<TSource>( IEnumerable<TSource> first, IEnumerable<TSource> second)
        {
            return ConcatIterator<TSource>(first, second);
        }

        private static IEnumerable<TSource> ConcatIterator<TSource>(IEnumerable<TSource> first, IEnumerable<TSource> second)
        {
            foreach (TSource element in first) yield return element;
            foreach (TSource element in second) yield return element;
        }

        public static IEnumerable<TResult> Zip<TFirst, TSecond, TResult>( IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> resultSelector)
        {
            return ZipIterator(first, second, resultSelector);
        }

        private static IEnumerable<TResult> ZipIterator<TFirst, TSecond, TResult>(IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> resultSelector)
        {
            IEnumerator<TFirst> e1 = first.GetEnumerator();
            IEnumerator<TSecond> e2 = second.GetEnumerator();
                while (e1.MoveNext() && e2.MoveNext())
                    yield return resultSelector(e1.Current, e2.Current);
        }


        public static IEnumerable<TSource> Distinct<TSource>( IEnumerable<TSource> source, IEqualityComparer<TSource>? comparer = null)
        {
            return DistinctIterator<TSource>(source, comparer);
        }

        private static IEnumerable<TSource> DistinctIterator<TSource>(IEnumerable<TSource> source, IEqualityComparer<TSource> comparer)
        {
            Set<TSource> set = new Set<TSource>(comparer);
            foreach (TSource element in source)
                if (set.Add(element)) yield return element;
        }

        public static IEnumerable<TSource> Union<TSource>( IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource> comparer)
        {
            return UnionIterator<TSource>(first, second, comparer);
        }

        private static IEnumerable<TSource> UnionIterator<TSource>(IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource> comparer)
        {
            Set<TSource> set = new Set<TSource>(comparer);
            foreach (TSource element in first)
                if (set.Add(element)) yield return element;
            foreach (TSource element in second)
                if (set.Add(element)) yield return element;
        }

        public static IEnumerable<TSource> Intersect<TSource>( IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource> comparer)
        {
            return IntersectIterator<TSource>(first, second, comparer);
        }

        private static IEnumerable<TSource> IntersectIterator<TSource>(IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource> comparer)
        {
            Set<TSource> set = new Set<TSource>(comparer);
            foreach (TSource element in second) set.Add(element);
            foreach (TSource element in first)
                if (set.Remove(element)) yield return element;
        }

        public static IEnumerable<TSource> Except<TSource>( IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource>? comparer = null)
        {
            return ExceptIterator<TSource>(first, second, comparer);
        }

        private static IEnumerable<TSource> ExceptIterator<TSource>(IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource>? comparer)
        {
            Set<TSource> set = new Set<TSource>(comparer);
            foreach (TSource element in second) set.Add(element);
            foreach (TSource element in first)
                if (set.Add(element)) yield return element;
        }

        public static IEnumerable<TSource> Reverse<TSource>( IEnumerable<TSource> source)
        {
            return ReverseIterator<TSource>(source);
        }

        private static IEnumerable<TSource> ReverseIterator<TSource>(IEnumerable<TSource> source)
        {
            Buffer<TSource> buffer = new Buffer<TSource>(source);
            for (int i = buffer.count - 1; i >= 0; i--) yield return buffer.items[i];
        }

        public static bool SequenceEqual<TSource>( IEnumerable<TSource> first, IEnumerable<TSource> second, IEqualityComparer<TSource> comparer)
        {
            if (comparer == null) comparer = EqualityComparer<TSource>.Default();
            IEnumerator<TSource> e1 = first.GetEnumerator();
            IEnumerator<TSource> e2 = second.GetEnumerator();
            {
                while (e1.MoveNext())
                {
                    if (!(e2.MoveNext() && comparer.Equals(e1.Current, e2.Current))) return false;
                }
                if (e2.MoveNext()) return false;
            }
            return true;
        }

        public static IEnumerable<TSource> AsEnumerable<TSource>( IEnumerable<TSource> source)
        {
            return source;
        }

        public static TSource[] ToArray<TSource>( IEnumerable<TSource> source)
        {
            return new Buffer<TSource>(source).ToArray();
        }

        public static List<TSource> ToList<TSource>( IEnumerable<TSource> source)
        {
            return new List<TSource>(source);
        }

        public static Dictionary<TKey, TElement> ToDictionary<TSource, TKey, TElement>( IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, IEqualityComparer<TKey> comparer)
        {
            Dictionary<TKey, TElement> d = new Dictionary<TKey, TElement>(comparer);
            foreach (TSource element in source) d.Add(keySelector(element), elementSelector(element));
            return d;
        }

        public static ILookup<TKey, TElement> ToLookup<TSource, TKey, TElement>( IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, IEqualityComparer<TKey> comparer)
        {
            return Lookup<TKey, TElement>.Create(source, keySelector, elementSelector, comparer);
        }

        public static IEnumerable<TSource> DefaultIfEmpty<TSource>( IEnumerable<TSource> source, TSource defaultValue)
        {
            return DefaultIfEmptyIterator<TSource>(source, defaultValue);
        }

        private static IEnumerable<TSource> DefaultIfEmptyIterator<TSource>(IEnumerable<TSource> source, TSource? defaultValue = null)
        {
			IEnumerator<TSource> e = source.GetEnumerator();
			try {
				if (e.MoveNext()) {
					do {
						yield return e.Current;
					} while (e.MoveNext());
				} else {
					yield return defaultValue;
				}
			} finally {
				e.Dispose();
			}
        }

        public static IEnumerable<TResult> OfType<TResult>( IEnumerable source)
        {
            return OfTypeIterator<TResult>(source);
        }

        private static IEnumerable<TResult> OfTypeIterator<TResult>(IEnumerable source)
        {
            foreach (GLib.Object obj in source)
            {
                if (obj is TResult) yield return (TResult)obj;
            }
        }

        public static IEnumerable<TResult> Cast<TResult>( IEnumerable source)
        {
            IEnumerable<TResult> typedSource = source as IEnumerable<TResult>;
            if (typedSource != null) return typedSource;
            return CastIterator<TResult>(source);
        }

        private static IEnumerable<TResult> CastIterator<TResult>(IEnumerable source)
        {
            foreach (GLib.Object obj in source) yield return (TResult)obj;
        }


        public static TSource First<TSource>( IEnumerable<TSource> source, Func<TSource, bool>? predicate = null)
        {
			if (predicate == null) {
				IList<TSource> list = source as IList<TSource>;
				if (list != null) {
					if (list.Count > 0) return list[0];
				} else {
					IEnumerator<TSource> e = source.GetEnumerator();
					try {
						if (e.MoveNext()) return e.Current;
					} finally {
						e.Dispose();
					}
				}
			} else {
				foreach (TSource element in source) {
					if (predicate(element)) return element;
				}
			}
            throw new ArgumentException.NOTFOUND("No Match");
        }

        public static TSource FirstOrDefault<TSource> ( IEnumerable<TSource> source, Func<TSource, bool>? predicate = null)
        {
			if (predicate == null) {
				IList<TSource> list = source as IList<TSource>;
				if (list != null) {
					if (list.Count > 0) return list[0];
				}
				IEnumerator<TSource> e = source.GetEnumerator();
				try {
					if (e.MoveNext()) return e.Current;
				} finally {
					e.Dispose();
				}
			} else {
				foreach (TSource element in source) {
					if (predicate(element)) return element;
				}				
			}
            return null;// default(TSource);
        }

        public static TSource Last<TSource>( IEnumerable<TSource> source, Func<TSource, bool>? predicate = null)
        {
            TSource result = null; // default(TSource);
            bool found = false;
            foreach (TSource element in source)
            {
                if (predicate(element))
                {
                    result = element;
                    found = true;
                }
            }
            if (found) return result;
            throw Error.NoMatch();
        }

        public static TSource LastOrDefault<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            TSource result = null; // default(TSource);
            foreach (TSource element in source)
            {
                if (predicate(element))
                {
                    result = element;
                }
            }
            return result;
        }


        public static TSource Single<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            TSource result = null; // default(TSource);
            long count = 0;
            foreach (TSource element in source)
            {
                if (predicate(element))
                {
                    result = element;
                    //checked { count++; }
                }
            }
            switch (count)
            {
                case 0: throw Error.NoMatch();
                case 1: return result;
            }
            throw Error.MoreThanOneMatch();
        }

        public static TSource SingleOrDefault<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            TSource result = null; // null; // default(TSource);
            long count = 0;
            foreach (TSource element in source)
            {
                if (predicate(element))
                {
                    result = element;
                    //checked { count++; }
                }
            }
            switch (count)
            {
                case 0: return null; // default(TSource);
                case 1: return result;
            }
            throw Error.MoreThanOneMatch();
        }

        public static TSource ElementAt<TSource>( IEnumerable<TSource> source, int index)
        {
            IList<TSource> list = source as IList<TSource>;
            if (list != null) return list[index];
            IEnumerator<TSource> e = source.GetEnumerator();
            try {
				while (true)
				{
					if (!e.MoveNext()) throw new ArgumentOutOfRangeException.INDEX("index");
					if (index == 0) return e.Current;
					index--;
				}
			} finally {
				e.Dispose();
			}
        }

        public static TSource ElementAtOrDefault<TSource>( IEnumerable<TSource> source, int index)
        {
            if (index >= 0)
            {
                IList<TSource> list = source as IList<TSource>;
                if (list != null) {
                    if (index < list.Count) return list[index];
                } else {
                    IEnumerator<TSource> e = source.GetEnumerator();
					try {
						while (true)
						{
							if (!e.MoveNext()) break;
							if (index == 0) return e.Current;
							index--;
						}
					} finally {
						e.Dispose();
					}
                }
            }
            return null; // default(TSource);
        }

        public static IEnumerable<int> Range(int start, int count)
        {
            long max = ((long)start) + count - 1;
            //if (count < 0 || max > int32.MaxValue) throw Error.ArgumentOutOfRange("count");
            return RangeIterator(start, count);
        }

        private static IEnumerable<int> RangeIterator(int start, int count)
        {
            for (int i = 0; i < count; i++) yield return start + i;
        }

        public static IEnumerable<TResult> Repeat<TResult>(TResult element, int count)
        {
            return RepeatIterator<TResult>(element, count);
        }

        private static IEnumerable<TResult> RepeatIterator<TResult>(TResult element, int count)
        {
            for (int i = 0; i < count; i++) yield return element;
        }

        public static IEnumerable<TResult> Empty<TResult>()
        {
            return EmptyEnumerable<TResult>.Instance;
        }

        public static bool Any<TSource>( IEnumerable<TSource> source, Func<TSource, bool>? predicate = null)
        {
            if (predicate == null) {
				IEnumerator<TSource> e = source.GetEnumerator();
				try {
					return e.MoveNext();
				} finally {
					e.Dispose();
				}
			} else {
				foreach (TSource element in source) {
					if (predicate(element)) return true;
				}
			}
            return false;
        }

        public static bool All<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            foreach (TSource element in source)
            {
                if (!predicate(element)) return false;
            }
            return true;
        }

        public static int Count<TSource>( IEnumerable<TSource> source, Func<TSource, bool>? predicate = null)
        {
            int count = 0;

			if (predicate == false) {
				try {
					IEnumerator<TSource> e = source.GetEnumerator();
					while (e.MoveNext()) count++;
				} finally {
					e.Dispose();
				}
			} else {
				foreach (TSource element in source)
				{
					if (predicate(element)) count++;
				}
			}
			return count;
        }

        public static long LongCount<TSource>( IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            long count = 0;
            foreach (TSource element in source)
            {
				if (predicate(element)) count++;
            }
            return count;
        }


        public static bool Contains<TSource>( IEnumerable<TSource> source, TSource value, IEqualityComparer<TSource>? comparer = nulll) {
            if (comparer == null) comparer = EqualityComparer<TSource>.Default();
            foreach (TSource element in source)
                if (comparer.Equals(element, value)) return true;
            return false;
        }

        public static TSource Aggregate<TSource>(IEnumerable<TSource> source, Func<TSource, TSource, TSource> func) {
			IEnumerator<TSource> e = source.GetEnumerator();
            try {
                if (!e.MoveNext()) throw Error.NOELEMENTS("No Elements");
                TSource result = e.Current;
                while (e.MoveNext()) result = func(result, e.Current);
                return result;
            } finally {
				((IDisposable)e).Dispose();
			}
        }
        
        public static int Sum<TSource>( IEnumerable<TSource> source, Func<TSource, int> selector)
        {
            return Enumerable.Sum(Enumerable.Select(source, selector));
        }

        public static int Min<TSource>( IEnumerable<TSource> source, Func<TSource, int> selector)
        {
            return Enumerable.Min(Enumerable.Select(source, selector));
        }

        public static int Max<TSource>( IEnumerable<TSource> source, Func<TSource, int> selector)
        {
            return Enumerable.Max(Enumerable.Select(source, selector));
        }


        public static double Average<TSource>( IEnumerable<TSource> source, Func<TSource, int> selector)
        {
            return Enumerable.Average(Enumerable.Select(source, selector));
        }

	}
    //
    // This is a more memory-intensive EmptyEnumerable<TElement> that allocates a new Enumerator each time. Unfortunately, we have to retain it
    // for desktop platforms to avoid breaking scenarios that serialize an empty enumerable on 4.5 and deserialize it on 4.0.
    // 
    internal class EmptyEnumerable<TElement>
    {
        public static   TElement[] Instance = new TElement[0];
    }

    internal class IdentityFunction<TElement>
    {
        public static Func<TElement, TElement> Instance
        {
            get { return x => x; }
        }
    }

    public interface IOrderedEnumerable<TElement> : IEnumerable<TElement>
    {
        public abstract IOrderedEnumerable<TElement> CreateOrderedEnumerable<TKey>(Func<TElement, TKey> keySelector, IComparer<TKey> comparer, bool descending);
    }

    public interface IGrouping<TKey, TElement> : IEnumerable<TElement>
    {
        public abstract TKey Key { get; }
    }

    public interface ILookup<TKey, TElement> : IEnumerable<IGrouping<TKey, TElement>>
    {
        public abstract int Count { get; }
        public abstract IEnumerable<TElement> get (TKey key) {  }
        public abstract bool Contains(TKey key);
    }

    public class Lookup<TKey, TElement> : IEnumerable<IGrouping<TKey, TElement>>, ILookup<TKey, TElement>
    {
        private IEqualityComparer<TKey> _comparer;
        private Grouping<TKey, TElement>[] _groupings;
        private Grouping<TKey, TElement> _lastGrouping;
        private int _count;

        internal static Lookup<TKey, TElement> Create<TSource>(IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, IEqualityComparer<TKey> comparer)
        {
            Lookup<TKey, TElement> lookup = new Lookup<TKey, TElement>(comparer);
            foreach (TSource item in source)
            {
                lookup.GetGrouping(keySelector(item), true).Add(elementSelector(item));
            }
            return lookup;
        }

        internal static Lookup<TKey, TElement> CreateForJoin(IEnumerable<TElement> source, Func<TElement, TKey> keySelector, IEqualityComparer<TKey> comparer)
        {
            Lookup<TKey, TElement> lookup = new Lookup<TKey, TElement>(comparer);
            foreach (TElement item in source)
            {
                TKey key = keySelector(item);
                if (key != null) lookup.GetGrouping(key, true).Add(item);
            }
            return lookup;
        }

        private Lookup(IEqualityComparer<TKey> comparer)
        {
            if (comparer == null) comparer = EqualityComparer<TKey>.Default;
            _comparer = comparer;
            _groupings = new Grouping<TKey, TElement>[7];
        }

        public int Count
        {
            get { return _count; }
        }

        public IEnumerable<TElement> get (TKey key) {
			Grouping<TKey, TElement> grouping = GetGrouping(key, false);
			if (grouping != null) return grouping;
			return EmptyEnumerable<TElement>.Instance;
		}

        public bool Contains(TKey key)
        {
            return GetGrouping(key, false) != null;
        }

        public IEnumerator<IGrouping<TKey, TElement>> GetEnumerator()
        {
            Grouping<TKey, TElement> g = _lastGrouping;
            if (g != null)
            {
                do
                {
                    g = g.next;
                    yield return g;
                } while (g != _lastGrouping);
            }
        }

        public IEnumerable<TResult> ApplyResultSelector<TResult>(Func<TKey, IEnumerable<TElement>, TResult> resultSelector)
        {
            Grouping<TKey, TElement> g = _lastGrouping;
            if (g != null)
            {
                do
                {
                    g = g.next;
                    if (g.count != g.elements.length) { Array.Resize<TElement>(ref g.elements, g.count); }
                    yield return resultSelector(g.key, g.elements);
                } while (g != _lastGrouping);
            }
        }

        internal int InternalGetHashCode(TKey key)
        {
            // Handle comparer implementations that throw when passed null
            return (key == null) ? 0 : _comparer.GetHashCode(key) & 0x7FFFFFFF;
        }

        internal Grouping<TKey, TElement> GetGrouping(TKey key, bool create)
        {
            int hashCode = InternalGetHashCode(key);
            for (Grouping<TKey, TElement> g = _groupings[hashCode % _groupings.length]; g != null; g = g.hashNext)
                if (g.hashCode == hashCode && _comparer.Equals(g.key, key)) return g;
            if (create)
            {
                if (_count == _groupings.length) Resize();
                int index = hashCode % _groupings.length;
                Grouping<TKey, TElement> g = new Grouping<TKey, TElement>();
                g.key = key;
                g.hashCode = hashCode;
                g.elements = new TElement[1];
                g.hashNext = _groupings[index];
                _groupings[index] = g;
                if (_lastGrouping == null)
                {
                    g.next = g;
                }
                else
                {
                    g.next = _lastGrouping.next;
                    _lastGrouping.next = g;
                }
                _lastGrouping = g;
                _count++;
                return g;
            }
            return null;
        }

        private void Resize()
        {
            int newSize = (_count * 2 + 1);
            Grouping<TKey, TElement>[] newGroupings = new Grouping<TKey, TElement>[newSize];
            Grouping<TKey, TElement> g = _lastGrouping;
            do
            {
                g = g.next;
                int index = g.hashCode % newSize;
                g.hashNext = newGroupings[index];
                newGroupings[index] = g;
            } while (g != _lastGrouping);
            _groupings = newGroupings;
        }
    }

    //
    // It is (unfortunately) common to databind directly to Grouping.Key.
    // Because of this, we have to declare this internal type public so that we
    // can mark the Key property for public reflection.
    //
    // To limit the damage, the toolchain makes this type appear in a hidden assembly.
    // (This is also why it is no longer a nested type of Lookup<,>).
    //
    public class Grouping<TKey, TElement> : IGrouping<TKey, TElement>, IList<TElement>
    {
        internal TKey key;
        internal int hashCode;
        internal TElement[] elements;
        internal int count;
        internal Grouping<TKey, TElement> hashNext;
        internal Grouping<TKey, TElement> next;

        internal Grouping()
        {
        }

        public IEnumerator<TElement> GetEnumerator()
        {
            for (int i = 0; i < count; i++) yield return elements[i];
        }

        // DDB195907: implement IGrouping<>.Key  ly
        // so that WPF binding works on this property.
        public TKey Key
        {
            get { return key; }
        }

        int Count
        {
            get { return count; }
        }

        bool IsReadOnly
        {
            get { return true; }
        }

        void Add(TElement item)
        {
            throw Error.NotSupported();
        }

        void Clear()
        {
            throw Error.NotSupported();
        }

        bool Contains(TElement item)
        {
            return Array.IndexOf(elements, item, 0, count) >= 0;
        }

        void CopyTo(TElement[] array, int arrayIndex)
        {
            Array.Copy(elements, 0, array, arrayIndex, count);
        }

        bool Remove(TElement item)
        {
            throw Error.NotSupported();
        }

        int IndexOf(TElement item)
        {
            return Array.IndexOf(elements, item, 0, count);
        }

        void Insert(int index, TElement item)
        {
            throw Error.NotSupported();
        }

        void RemoveAt(int index)
        {
            throw Error.NotSupported();
        }

        TElement get (int index) {
			if (index < 0 || index >= count) throw Error.ArgumentOutOfRange("index");
			return elements[index];
		}
    }

    internal class Set<TElement>
    {
        private int[] _buckets;
        private Slot[] _slots;
        private int _count;
        private int _freeList;
        private IEqualityComparer<TElement> _comparer;

        public Set(IEqualityComparer<TElement>? comparer = null)
        {
            if (comparer == null) _comparer = EqualityComparer<TElement>.Default<TElement>();
            _comparer = comparer;
            _buckets = new int[7];
            _slots = new Slot[7];
            _freeList = -1;
        }

        // If value is not in set, add it and return true; otherwise return false
        public bool Add(TElement value)
        {
            return !Find(value, true);
        }

        // Check whether value is in set
        public bool Contains(TElement value)
        {
            return Find(value, false);
        }

        // If value is in set, remove it and return true; otherwise return false
        public bool Remove(TElement value)
        {
            int hashCode = InternalGetHashCode(value);
            int bucket = hashCode % _buckets.length;
            int last = -1;
            for (int i = _buckets[bucket] - 1; i >= 0; last = i, i = _slots[i].next)
            {
                if (_slots[i].hashCode == hashCode && _comparer.Equals(_slots[i].value, value))
                {
                    if (last < 0)
                    {
                        _buckets[bucket] = _slots[i].next + 1;
                    }
                    else
                    {
                        _slots[last].next = _slots[i].next;
                    }
                    _slots[i].hashCode = -1;
                    _slots[i].value = null; // default(TElement);
                    _slots[i].next = _freeList;
                    _freeList = i;
                    return true;
                }
            }
            return false;
        }

        private bool Find(TElement value, bool add)
        {
            int hashCode = InternalGetHashCode(value);
            for (int i = _buckets[hashCode % _buckets.length] - 1; i >= 0; i = _slots[i].next)
            {
                if (_slots[i].hashCode == hashCode && _comparer.Equals(_slots[i].value, value)) return true;
            }
            if (add)
            {
                int index;
                if (_freeList >= 0)
                {
                    index = _freeList;
                    _freeList = _slots[index].next;
                }
                else
                {
                    if (_count == _slots.length) Resize();
                    index = _count;
                    _count++;
                }
                int bucket = hashCode % _buckets.length;
                _slots[index].hashCode = hashCode;
                _slots[index].value = value;
                _slots[index].next = _buckets[bucket] - 1;
                _buckets[bucket] = index + 1;
            }
            return false;
        }

        private void Resize()
        {
            int newSize = (_count * 2 + 1);
            int[] newBuckets = new int[newSize];
            Slot[] newSlots = new Slot[newSize];
            Array.Copy(_slots, 0, newSlots, 0, _count);
            for (int i = 0; i < _count; i++)
            {
                int bucket = newSlots[i].hashCode % newSize;
                newSlots[i].next = newBuckets[bucket] - 1;
                newBuckets[bucket] = i + 1;
            }
            _buckets = newBuckets;
            _slots = newSlots;
        }

        internal int InternalGetHashCode(TElement value)
        {
            // Handle comparer implementations that throw when passed null
            return (value == null) ? 0 : (int)(_comparer.GetHashCode(value) & 0x7FFFFFFF);
        }

        internal struct Slot
        {
            public int hashCode;
            public TElement value;
            public int next;
        }
    }

    internal class GroupedEnumerable<TSource, TKey, TElement, TResult> : GLib.Object, IEnumerable<TResult>
    {
        private IEnumerable<TSource> _source;
        private Func<TSource, TKey> _keySelector;
        private Func<TSource, TElement> _elementSelector;
        private IEqualityComparer<TKey> _comparer;
        private Func<TKey, IEnumerable<TElement>, TResult> _resultSelector;

        public GroupedEnumerable(IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, Func<TKey, IEnumerable<TElement>, TResult> resultSelector, IEqualityComparer<TKey> comparer)
        {
            _source = source;
            _keySelector = keySelector;
            _elementSelector = elementSelector;
            _comparer = comparer;
            _resultSelector = resultSelector;
        }

        public IEnumerator<TResult> GetEnumerator()
        {
            Lookup<TKey, TElement> lookup = Lookup<TKey, TElement>.Create<TSource>(_source, _keySelector, _elementSelector, _comparer);
            return lookup.ApplyResultSelector(_resultSelector).GetEnumerator();
        }

    }

    internal abstract class OrderedEnumerable<TElement> : GLib.Object, IEnumerable<TElement>, IOrderedEnumerable<TElement>
    {
        internal IEnumerable<TElement> source;

        public IEnumerator<TElement> GetEnumerator()
        {
            Buffer<TElement> buffer = Buffer<TElement>(source);
            if (buffer.count > 0)
            {
                EnumerableSorter<TElement> sorter = GetEnumerableSorter(null);
                int[] map = sorter.Sort(buffer.items, buffer.count);
                sorter = null;
                for (int i = 0; i < buffer.count; i++) yield return buffer.items[map[i]];
            }
        }

        internal abstract EnumerableSorter<TElement> GetEnumerableSorter(EnumerableSorter<TElement>? next = null);

        IOrderedEnumerable<TElement> CreateOrderedEnumerable<TKey>(Func<TElement, TKey> keySelector, IComparer<TKey> comparer, bool descending)
        {
            OrderedEnumerable<TElement, TKey> result = new OrderedEnumerable<TElement, TKey>(source, keySelector, comparer, descending);
            result.parent = this;
            return result;
        }
    }


    internal class EnumerableSorter<TElement, TKey>
    {
        internal Func<TElement, TKey> keySelector;
        internal IComparer<TKey> comparer;
        internal bool descending;
        internal EnumerableSorter<TElement> next;
        internal TKey[] keys;

        internal EnumerableSorter(Func<TElement, TKey> keySelector, IComparer<TKey> comparer, bool descending, EnumerableSorter<TElement> next)
        {
            this.keySelector = keySelector;
            this.comparer = comparer;
            this.descending = descending;
            this.next = next;
        }

        internal override void ComputeKeys(TElement[] elements, int count)
        {
            keys = new TKey[count];
            for (int i = 0; i < count; i++) keys[i] = keySelector(elements[i]);
            if (next != null) next.ComputeKeys(elements, count);
        }

        internal override int CompareKeys(int index1, int index2)
        {
            int c = comparer.Compare(keys[index1], keys[index2]);
            if (c == 0)
            {
                if (next == null) return index1 - index2;
                return next.CompareKeys(index1, index2);
            }
            return descending ? -c : c;
        }
    }

    internal struct Buffer<TElement>
    {
        public TElement[] items;
        public int count;

        internal Buffer(IEnumerable<TElement> source, bool queryInterfaces = true)
        {
            TElement[] items = null;
            int count = 0;

            if (queryInterfaces)
            {
                Enumerable.Iterator<TElement> iterator = source as Enumerable.Iterator<TElement>;
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
						if (item.length != newSize) {
							TElement[] newArray = new TElement[newSize];
							int i = 0;
							foreach (var item in items) {
								newArray[i++] = item;
							}
							array = newArray;
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
            if (items.length == count) return items;

            var arr = new TElement[count];
			foreach (var item in items) {
				arr[i++] = item;
			}
            return arr;
        }
    }


}
