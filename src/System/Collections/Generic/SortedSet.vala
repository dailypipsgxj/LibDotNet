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

    internal enum TreeRotation
    {
        LeftRotation = 1,
        RightRotation = 2,
        RightLeftRotation = 3,
        LeftRightRotation = 4,
    }

    public class SortedSet<T> : Gee.TreeSet<T>, ISet<T>, ICollection<T>, IReadOnlyCollection<T>
    {
        private Node _root;
        private IComparer<T> _comparer;

        private Object _syncRoot;

        internal const int StackAllocThreshold = 100;

        public SortedSet(IComparer<T>? comparer = null)
        {
            if (comparer == null)
            {
                _comparer = Comparer<T>.Default;
            }
            else
            {
                _comparer = comparer;
            }
            base(comparer.Equals);
        }


        public SortedSet.FromCollection(IEnumerable<T> collection, IComparer<T>? comparer = null){
			this(comparer);
			AddAllElements(collection);
        }

        private void AddAllElements(IEnumerable<T> collection)
        {
            foreach (T item in collection)
            {
                if (!this.Contains(item))
                    Add(item);
            }
        }

        private void RemoveAllElements(IEnumerable<T> collection)
        {
            T min = this.Min;
            T max = this.Max;
            foreach (T item in collection)
            {
                if (!(_comparer.Compare(item, min) < 0 || _comparer.Compare(item, max) > 0) && this.Contains(item))
                    this.Remove(item);
            }
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
        /// Decides whether these sets are the same, given the comparer. If the EC's are the same, we can
        /// just use SetEquals, but if they aren't then we have to manually check with the given comparer
        /// </summary>        
        internal static bool SortedSetEquals(SortedSet<T> set1, SortedSet<T> set2, IComparer<T> comparer)
        {
            // handle null cases first
            if (set1 == null)
            {
                return (set2 == null);
            }
            else if (set2 == null)
            {
                // set1 != null
                return false;
            }

            if (AreComparersEqual(set1, set2))
            {
                if (set1.Count != set2.Count)
                    return false;

                return set1.SetEquals(set2);
            }
            else
            {
                bool found = false;
                foreach (T item1 in set1)
                {
                    found = false;
                    foreach (T item2 in set2)
                    {
                        if (comparer.Compare(item1, item2) == 0)
                        {
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                        return false;
                }
                return true;
            }
        }


        //This is a little frustrating because we can't support more sorted structures
        private static bool AreComparersEqual(SortedSet<T> set1, SortedSet<T> set2)
        {
            return set1.Comparer.Equals(set2.Comparer);
        }

        /// <summary>
        /// Copies this to an array. Used for DebugView
        /// </summary>
        /// <returns></returns>
        internal T[] ToArray()
        {
            return to_array();
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
             IntersectWithEnumerable(other);
        }

        internal virtual void IntersectWithEnumerable(IEnumerable<T> other)
        {
            //TODO: Perhaps a more space-conservative way to do this
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
            AddAllElements(toSave);
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
			//need perf improvement on this
			T[] elements = (new List<T>(other)).ToArray();
			elements.sort(this.Comparer.Equals);
			SymmetricExceptWithSameEC(elements);
        }

        //OTHER must be a set
        internal void SymmetricExceptWithSameEC(ISet<T> other)
        {
            foreach (T item in other)
            {
                //yes, it is classier to say
                //if (!this.Remove(item))this.Add(item);
                //but this ends up saving on rotations                    
                if (this.Contains(item))
                {
                    this.Remove(item);
                }
                else
                {
                    this.Add(item);
                }
            }
        }

        //OTHER must be a sorted array
        internal void SymmetricExceptWithSameECFromArray(T[] other)
        {
            if (other.Length == 0)
            {
                return;
            }
            T last = other[0];
            for (int i = 0; i < other.length; i++)
            {
                while (i < other.length && i != 0 && _comparer.Compare(other[i], last) == 0)
                    i++;
                if (i >= other.length)
                    break;
                if (this.Contains(other[i]))
                {
                    this.Remove(other[i]);
                }
                else
                {
                    this.Add(other[i]);
                }
                last = other[i];
            }
        }


        /// <summary>
        /// Checks whether this Tree is a subset of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsSubsetOf(IEnumerable<T> other)
        {

            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(this, asSorted))
            {
                if (this.Count > asSorted.Count)
                    return false;
                return IsSubsetOfSortedSetWithSameEC(asSorted);
            }
            else
            {
                ElementCount result = CheckUniqueAndUnfoundElements(other, false);
                return (result.uniqueCount == Count && result.unfoundCount >= 0);
            }
        }

        private bool IsSubsetOfSortedSetWithSameEC(SortedSet<T> asSorted)
        {
            SortedSet<T> prunedOther = asSorted.GetViewBetween(this.Min, this.Max);
            foreach (T item in this)
            {
                if (!prunedOther.Contains(item))
                    return false;
            }
            return true;
        }


        /// <summary>
        /// Checks whether this Tree is a proper subset of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsProperSubsetOf(IEnumerable<T> other)
        {

            if ((other as ICollection) != null)
            {
                if (Count == 0)
                    return (other as ICollection).Count > 0;
            }


            //another for sorted sets with the same comparer
            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(this, asSorted))
            {
                if (this.Count >= asSorted.Count)
                    return false;
                return IsSubsetOfSortedSetWithSameEC(asSorted);
            }
            //worst case: mark every element in my set and see if i've counted all
            //O(MlogN).
            ElementCount result = CheckUniqueAndUnfoundElements(other, false);
            return (result.uniqueCount == Count && result.unfoundCount > 0);
        }


        /// <summary>
        /// Checks whether this Tree is a super set of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsSupersetOf(IEnumerable<T> other)
        {

            if ((other as ICollection) != null && (other as ICollection).Count == 0)
                return true;

            //do it one way for HashSets
            //another for sorted sets with the same comparer
            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(this, asSorted))
            {
                if (this.Count < asSorted.Count)
                    return false;
                SortedSet<T> pruned = GetViewBetween(asSorted.Min, asSorted.Max);
                foreach (T item in asSorted)
                {
                    if (!pruned.Contains(item))
                        return false;
                }
                return true;
            }
            //and a third for everything else
            return ContainsAllElements(other);
        }

        /// <summary>
        /// Checks whether this Tree is a proper super set of the IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool IsProperSupersetOf(IEnumerable<T> other)
        {
            if (Count == 0)
                return false;

            if ((other as ICollection) != null && (other as ICollection).Count == 0)
                return true;

            //another way for sorted sets
            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(asSorted, this))
            {
                if (asSorted.Count >= this.Count)
                    return false;
                SortedSet<T> pruned = GetViewBetween(asSorted.Min, asSorted.Max);
                foreach (T item in asSorted)
                {
                    if (!pruned.Contains(item))
                        return false;
                }
                return true;
            }

            ElementCount result = CheckUniqueAndUnfoundElements(other, true);
            return (result.uniqueCount < Count && result.unfoundCount == 0);
        }



        /// <summary>
        /// Checks whether this Tree has all elements in common with IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool SetEquals(IEnumerable<T> other)
        {

            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(this, asSorted))
            {
                IEnumerator<T> mine = this.GetEnumerator();
                IEnumerator<T> theirs = asSorted.GetEnumerator();
                bool mineEnded = !mine.MoveNext();
                bool theirsEnded = !theirs.MoveNext();
                while (!mineEnded && !theirsEnded)
                {
                    if (Comparer.Compare(mine.Current, theirs.Current) != 0)
                    {
                        return false;
                    }
                    mineEnded = !mine.MoveNext();
                    theirsEnded = !theirs.MoveNext();
                }
                return mineEnded && theirsEnded;
            }

            //worst case: mark every element in my set and see if i've counted all
            //O(N) by size of other            
            ElementCount result = CheckUniqueAndUnfoundElements(other, true);
            return (result.uniqueCount == Count && result.unfoundCount == 0);
        }



        /// <summary>
        /// Checks whether this Tree has any elements in common with IEnumerable other
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool Overlaps(IEnumerable<T> other)
        {

            if (this.Count == 0)
                return false;

            if ((other as ICollection<T> != null) && (other as ICollection<T>).Count == 0)
                return false;

            SortedSet<T> asSorted = other as SortedSet<T>;
            if (asSorted != null && AreComparersEqual(this, asSorted) && (_comparer.Compare(Min, asSorted.Max) > 0 || _comparer.Compare(Max, asSorted.Min) < 0))
            {
                return false;
            }
            foreach (T item in other)
            {
                if (this.Contains(item))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// This works similar to HashSet's CheckUniqueAndUnfound (description below), except that the bit
        /// array maps differently than in the HashSet. We can only use this for the bulk boolean checks.
        /// 
        /// Determines counts that can be used to determine equality, subset, and superset. This
        /// is only used when other is an IEnumerable and not a HashSet. If other is a HashSet
        /// these properties can be checked faster without use of marking because we can assume 
        /// other has no duplicates.
        /// 
        /// The following count checks are performed by callers:
        /// 1. Equals: checks if unfoundCount = 0 and uniqueFoundCount = Count; i.e. everything 
        /// in other is in this and everything in this is in other
        /// 2. Subset: checks if unfoundCount >= 0 and uniqueFoundCount = Count; i.e. other may
        /// have elements not in this and everything in this is in other
        /// 3. Proper subset: checks if unfoundCount > 0 and uniqueFoundCount = Count; i.e
        /// other must have at least one element not in this and everything in this is in other
        /// 4. Proper superset: checks if unfound count = 0 and uniqueFoundCount strictly less
        /// than Count; i.e. everything in other was in this and this had at least one element
        /// not contained in other.
        /// 
        /// An earlier implementation used delegates to perform these checks rather than returning
        /// an ElementCount struct; however this was changed due to the perf overhead of delegates.
        /// </summary>
        /// <param name="other"></param>
        /// <param name="returnIfUnfound">Allows us to finish faster for equals and proper superset
        /// because unfoundCount must be 0.</param>
        /// <returns></returns>
        // <SecurityKernel Critical="True" Ring="0">
        // <UsesUnsafeCode Name="Local bitArrayPtr of type: int32*" />
        // <ReferencesCritical Name="Method: BitHelper..ctor(System.int32*,System.int32)" Ring="1" />
        // <ReferencesCritical Name="Method: BitHelper.IsMarked(System.int32):System.Boolean" Ring="1" />
        // <ReferencesCritical Name="Method: BitHelper.MarkBit(System.int32):System.Void" Ring="1" />
        // </SecurityKernel>
        private   ElementCount CheckUniqueAndUnfoundElements(IEnumerable<T> other, bool returnIfUnfound)
        {
            ElementCount result;

            // need special case in case this has no elements. 
            if (Count == 0)
            {
                int numElementsInOther = 0;
                foreach (T item in other)
                {
                    numElementsInOther++;
                    // break right away, all we want to know is whether other has 0 or 1 elements
                    break;
                }
                result.uniqueCount = 0;
                result.unfoundCount = numElementsInOther;
                return result;
            }

            foreach (T item in other)
            {
            }

            result.uniqueCount = uniqueFoundCount;
            result.unfoundCount = unfoundCount;
            return result;
        }

        public int RemoveWhere(Predicate<T> match)
        {
            // reverse breadth first to (try to) incur low cost
            int actuallyRemoved = 0;

            return actuallyRemoved;
        }

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
            while (e.MoveNext())
            {
                yield return e.Current;
            }
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
        internal class TreeSubSet : SortedSet<T>
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

        internal class Node
        {
            public bool IsRed;
            public T Item;
            public Node Left;
            public Node Right;

            public Node(T item, bool isRed = true)
            {
                // The default color will be red, we never need to create a black node directly.                
                this.Item = item;
                this.IsRed = isRed;
            }
        }

		[Compact]
        public class Enumerator : IEnumerator<T>, IEnumerator
        {
            private SortedSet<T> _tree;
			private T _currentElement;
			private Gee.Iterator _iterator;
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
