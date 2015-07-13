// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
**
** Purpose: A generic sorted set.
**
** 
===========================================================*/
using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
    //
    // A binary search tree is a red-black tree if it satifies the following red-black properties:
    // 1. Every node is either red or black
    // 2. Every leaf (nil node) is black
    // 3. If a node is red, the both its children are black
    // 4. Every simple path from a node to a descendant leaf contains the same number of black nodes
    // 
    // The basic idea of red-black tree is to represent 2-3-4 trees as standard BSTs but to add one extra bit of information  
    // per node to encode 3-nodes and 4-nodes. 
    // 4-nodes will be represented as:          B
    //                                                              R            R
    // 3 -node will be represented as:           B             or         B     
    //                                                              R          B               B       R
    // 
    // For a detailed description of the algorithm, take a look at "Algorithm" by Rebert Sedgewick.
    //

    //internal delegate bool TreeWalkPredicate<T>(SortedSet.Node node);

    public class SortedSet<T> : Gee.TreeSet<T>, ISet<T>, ICollection<T>, IReadOnlyCollection<T>
    {
        private IComparer<T>? _comparer;
        private Object _syncRoot;

        public SortedSet(IComparer<T>? comparer = null)
        {
            _comparer = comparer;
            base();
        }

        public SortedSet.FromCollection(IEnumerable<T> collection, IComparer<T>? comparer = null){
			this(comparer);
			AddAllElements(collection);
        }

        private void AddAllElements(IEnumerable<T> collection)
        {
        }

        private void RemoveAllElements(IEnumerable<T> collection)
        {
        }

        public int Count
        {
            get
            {
                return size;
            }
        }

        public IComparer<T> Comparer
        {
            get
            {
                return _comparer;
            }
        }

        bool IsReadOnly
        {
            get
            {
                return false;
            }
        }

        bool IsSynchronized
        {
            get
            {
                return false;
            }
        }
        
        Object SyncRoot
        {
            get
            {
                return _syncRoot;
            }
        }

        //virtual function for subclass that needs to do range checks
        internal virtual bool IsWithinRange(T item)
        {
            return true;
        }

        /// <summary>
        /// Add the value ITEM to the tree, returns true if added, false if duplicate 
        /// </summary>
        /// <param name="item">item to be added</param> 
        public bool Add(T item)
        {
            return AddIfNotPresent(item);
        }


        /// <summary>
        /// Adds ITEM to the tree if not already present. Returns TRUE if value was successfully added         
        /// or FALSE if it is a duplicate
        /// </summary>        
        internal virtual bool AddIfNotPresent(T item)
        {
            if (contains(item))
            {
				return false;
            }
            return add(item);
        }


        public Enumerator GetEnumerator()
        {
            return new Enumerator(this);
        }


        /// <summary>
        /// Transform this set into its union with the IEnumerable OTHER            
        ///Attempts to insert each element and rejects it if it exists.          
        /// NOTE: The callerObjectis important as UnionWith uses the Comparator 
        ///associated with THIS to check equality                                
        /// Throws ArgumentNullException if OTHER is null                         
        /// </summary>
        /// <param name="other"></param>
        public void UnionWith(IEnumerable<T> other)
        {
                AddAllElements(other);
        }


        /// <summary>
        /// Transform this set into its intersection with the IEnumerable OTHER     
        /// NOTE: The callerObjectis important as IntersectionWith uses the        
        /// comparator associated with THIS to check equality                        
        /// Throws ArgumentNullException if OTHER is null                         
        /// </summary>
        /// <param name="other"></param>   
        public virtual void IntersectWith(IEnumerable<T> other)
        {
             //IntersectWithEnumerable(other);
        }

        /// <summary>
        ///  Transform this set into its complement with the IEnumerable OTHER       
        ///  NOTE: The callerObjectis important as ExceptWith uses the        
        ///  comparator associated with THIS to check equality                        
        ///  Throws ArgumentNullException if OTHER is null                           
        /// </summary>
        /// <param name="other"></param>
        public void ExceptWith(IEnumerable<T> other)
        {
            RemoveAllElements(other);
        }

        /// <summary>
        ///  Transform this set so it contains elements in THIS or OTHER but not both
        ///  NOTE: The callerObjectis important as SymmetricExceptWith uses the        
        ///  comparator associated with THIS to check equality                        
        ///  Throws ArgumentNullException if OTHER is null                           
        /// </summary>
        /// <param name="other"></param>
        public void SymmetricExceptWith(IEnumerable<T> other)
        {
        }


        /// <summary>
        /// Checks whether this Tree is a subset of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsSubsetOf(IEnumerable<T> other)
        {
			return false;
        }

        /// <summary>
        /// Checks whether this Tree is a proper subset of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsProperSubsetOf(IEnumerable<T> other)
        {
            return false;
        }

        /// <summary>
        /// Checks whether this Tree is a super set of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsSupersetOf(IEnumerable<T> other)
        {
            return true;
        }

        /// <summary>
        /// Checks whether this Tree is a proper super set of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsProperSupersetOf(IEnumerable<T> other)
        {
            return false;
        }

        /// <summary>
        /// Checks whether this Tree has all elements in common with IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool SetEquals(IEnumerable<T> other)
        {
            return true;
        }

        /// <summary>
        /// Checks whether this Tree has any elements in common with IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool Overlaps(IEnumerable<T> other)
        {
            return false;
        }

		/*
        public int RemoveWhere(Predicate<T> match)
        {
            // reverse breadth first to (try to) incur low cost
            int actuallyRemoved = 0;

            return actuallyRemoved;
        }
        */

        public T Min
        {
            get
            {
                return first();
            }
        }

        public T Max
        {
            get
            {
                return last();
            }
        }

        public IEnumerable<T> Reverse()
        {
            Enumerator e = new Enumerator(this, true);
            /*while (e.MoveNext())
            {
                yield return e.Current;
            }*/
        }


        /// <summary>
        /// Returns a subset of this tree ranging from values lBound to uBound
        /// Any changes made to the subset reflect in the actual tree
        /// </summary>
        /// <param name="lowVestalue">Lowest Value allowed in the subset</param>
        /// <param name="highestValue">Highest Value allowed in the subset</param>        
        public virtual SortedSet<T> GetViewBetween(T lowerValue, T upperValue)
        {
            if (Comparer.Compare(lowerValue, upperValue) > 0)
            {
                throw new ArgumentException("lowerBound is greater than upperBound");
            }
            return new TreeSubSet(this, lowerValue, upperValue);
        }


        /// <summary>
        /// This class represents a subset view into the tree. Any changes to this view
        /// are reflected in the actual tree. Uses the Comparator of the underlying tree.
        /// </summary>
        /// <typeparam name="T"></typeparam>   
        public class TreeSubSet : SortedSet<T>
        {
            private SortedSet<T> _underlying;
            private Gee.SortedSet _subset;

            public TreeSubSet(SortedSet<T> Underlying, T Min, T Max){
				base(Underlying.Comparer);
                _underlying = Underlying;
                _subset = _underlying.sub_set(Min, Max);

            }

            /// <summary>
            /// Additions to this tree need to be added to the underlying tree as well
            /// </summary>           

            internal override bool AddIfNotPresent(T item)
            {
                if (!IsWithinRange(item))
                {
                    throw new ArgumentOutOfRangeException("collection");
                }

                bool ret = _underlying.AddIfNotPresent(item);
                return ret;
            }


            internal override bool DoRemove(T item)
            { // todo: uppercase this and others
                if (!IsWithinRange(item))
                {
                    return false;
                }

                bool ret = _underlying.Remove(item);
                return ret;
            }

            public override void Clear()
            {
                foreach (var item in _subset)
                {
                    _underlying.Remove(item);
                }
                _subset.clear();
            }


            internal override bool IsWithinRange(T item)
            {
				if ((_subset.ceil(item) != null) && (_subset.floor(item) != null))
					return true;
					
				return false;
            }


            //This passes functionality down to the underlying tree, clipping edges if necessary
            //There's nothing gained by having a nested subset. May as well draw it from the base
            //Cannot increase the bounds of the subset, can only decrease it
            public override SortedSet<T> GetViewBetween(T lowerValue, T upperValue)
            {
                TreeSubSet ret = (TreeSubSet)_underlying.GetViewBetween(lowerValue, upperValue);
                return ret;
            }

            internal override void IntersectWithEnumerable(IEnumerable<T> other)
            {
                List<T> toSave = new List<T>(this.Count);
                foreach (T item in other)
                {
                    if (this.Contains(item))
                    {
                        toSave.Add(item);
                        this.Remove(item);
                    }
                }
                this.Clear();
                this.AddAllElements(toSave);
            }
        }


		[Compact]
        public class Enumerator : IEnumerator<T>
        {
            private SortedSet<T> _tree;
			private T _currentElement;
			private Gee.Iterator<T> _iterator;
            private bool _reverse;


            internal Enumerator(SortedSet<T> tree, bool reverse = false)
            {
                _tree = tree;
                _iterator = tree.bidir_iterator();
                _reverse = reverse;
            }

            public bool MoveNext()
            {
				if (_reverse) {
					if(_iterator.has_previous()) {
						_iterator.previous();
						_currentElement = _iterator.get();
						return true;
					}
				} else {
					if(_iterator.has_next()) {
						_iterator.next();
						_currentElement = _iterator.get();
						return true;
					}
				}
				_currentElement = default(T);
				return false;

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
            

            internal void Reset()
            {
                _iterator = tree.bidir_iterator();
				_currentElement = default(T);
            }

        }


        internal struct ElementCount
        {
            int uniqueCount;
            int unfoundCount;
        }
        

    }

    /// <summary>
    /// A class that generates an IEqualityComparer for this SortedSet. Requires that the definition of
    /// equality defined by the IComparer for this SortedSet be consistent with the default IEqualityComparer
    /// for the type T. If not, such an IEqualityComparer should be provided through the constructor.
    /// </summary>    
    internal class SortedSetEqualityComparer<T> : IEqualityComparer<SortedSet<T>>
    {
        private IComparer<T> _comparer;
        private IEqualityComparer<T> _eqComparer;

        /// <summary>
        /// Create a new SetEqualityComparer, given a comparer for member order and another for member equality (these
        /// must be consistent in their definition of equality)
        /// </summary>        
        public SortedSetEqualityComparer(IComparer<T>? comparer = null, IEqualityComparer<T>? memberEqualityComparer = null)
        {
            if (comparer == null)
                _comparer = Comparer<T>.Default;
            else
                _comparer = comparer;
            if (memberEqualityComparer == null)
                _eqComparer = EqualityComparer<T>.Default;
            else
                _eqComparer = memberEqualityComparer;
        }


        // using comparer to keep equals properties in tact; don't want to choose one of the comparers
        public bool Equals(SortedSet<T> x, SortedSet<T> y)
        {
            return SortedSet<T>.SortedSetEquals(x, y, _comparer);
        }
        //IMPORTANT: this part uses the fact that GetHashCode() is consistent with the notion of equality in
        //the set
        public int GetHashCode(SortedSet<T> obj)
        {
            int hashCode = 0;
            if (obj != null)
            {
                foreach (T t in obj)
                {
                    hashCode = hashCode ^ (_eqComparer.GetHashCode(t) & 0x7FFFFFFF);
                }
            } // else returns hashcode of 0 for null HashSets
            return hashCode;
        }

    }
}
