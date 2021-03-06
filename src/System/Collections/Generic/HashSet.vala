// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using System.Text;
using System.Diagnostics.CodeAnalysis;
using System.Security;

namespace System.Collections.Generic
{
    /// <summary>
    /// Implementation notes:
    /// This uses an array-based implementation similar to Dictionary<T>, using a buckets array
    /// to map hash values to the Slots array. Items in the Slots array that hash to the same value
    /// are chained together through the "next" indices. 
    /// 
    /// The capacity is always prime; so during resizing, the capacity is chosen as the next prime
    /// greater than double the last capacity. 
    /// 
    /// The underlying data structures are lazily initialized. Because of the observation that, 
    /// in practice, hashtables tend to contain only a few elements, the initial capacity is
    /// set very small (3 elements) unless the ctor with a collection is used.
    /// 
    /// The +/- 1 modifications in methods that add, check for containment, etc allow us to 
    /// distinguish a hash code of 0 from an uninitialized bucket. This saves us from having to 
    /// reset each bucket to -1 when resizing. See Contains, for example.
    /// 
    /// Set methods such as UnionWith, IntersectWith, ExceptWith, and SymmetricExceptWith modify
    /// this set.
    /// 
    /// Some operations can perform faster if we can assume "other" contains unique elements
    /// according to this equality comparer. The only times this is efficient to check is if
    /// other is a hashset. Note that checking that it's a hashset alone doesn't suffice; we
    /// also have to check that the hashset is using the same equality comparer. If other 
    /// has a different equality comparer, it will have unique elements according to its own
    /// equality comparer, but not necessarily according to ours. Therefore, to go these 
    /// optimized routes we check that other is a hashset using the same equality comparer.
    /// 
    /// A HashSet with no elements has the properties of the empty set. (See IsSubset, etc. for 
    /// special empty set checks.)
    /// 
    /// A couple of methods have a special case if other is this (e.g. SymmetricExceptWith). 
    /// If we didn't have these checks, we could be iterating over the set and modifying at
    /// the same time. 
    /// </summary>
    /// <typeparam name="T"></typeparam>

    public class HashSet<T> : Gee.HashSet<T>, ICollection<T>, ISet<T>, IReadOnlyCollection<T>
    {
        private IEqualityComparer<T> _comparer;

        //Constructors
        public HashSet(IEqualityComparer<T>? comparer = null)
        {
            if (comparer == null)
            {
                comparer = EqualityComparer<T>.Default;
            }

            _comparer = comparer;
            base (null, comparer.Equals);
        }

        /// <summary>
        /// Implementation Notes:
        /// Since resizes are relatively expensive (require rehashing), this attempts to minimize 
        /// the need to resize by setting the initial capacity based on size of collection. 
        /// </summary>
        /// <param name="collection"></param>
        /// <param name="comparer"></param>
        public HashSet.FromCollection(IEnumerable<T> collection, IEqualityComparer<T>? comparer = null){
			this(comparer);
			foreach (var item in collection) {
				add (item);
			}
        }

        /// <summary>
        /// Number of elements in this hashset
        /// </summary>
        public int Count
        {
            get { return size; }
        }

        /// <summary>
        /// Whether this is  
        /// </summary>
        bool IsReadOnly
        {
            get { return false; }
        }

        //

        //IEnumerable methods

        public Enumerator GetEnumerator()
        {
            return new Enumerator(this);
        }


        //HashSet methods

        /// <summary>
        /// Add item to this HashSet. Returns bool indicating whether item was added (won't be 
        /// added if already present)
        /// </summary>
        /// <param name="item"></param>
        /// <returns>true if added, false if already present</returns>
        public bool Add(T item)
        {
            return AddIfNotPresent(item);
        }

        /// <summary>
        /// Take the union of this HashSet with other. Modifies this set.
        /// 
        /// Implementation note: GetSuggestedCapacity (to increase capacity in advance avoiding 
        /// multiple resizes ended up not being useful in practice; quickly gets to the 
        /// point where it's a wasteful check.
        /// </summary>
        /// <param name="other">enumerable with items to add</param>
        public void UnionWith(IEnumerable<T> other)
        {
            foreach (T item in other)
            {
                AddIfNotPresent(item);
            }
        }

        /// <summary>
        /// Takes the intersection of this set with other. Modifies this set.
        /// 
        /// Implementation Notes: 
        /// We get better perf if other is a hashset using same equality comparer, because we 
        /// get constant contains check in other. Resulting cost is O(n1) to iterate over this.
        /// 
        /// If we can't go above route, iterate over the other and mark intersection by checking
        /// contains in this. Then loop over and delete any unmarked elements. Total cost is n2+n1. 
        /// 
        /// Attempts to return early based on counts alone, using the property that the 
        /// intersection of anything with the empty set is the empty set.
        /// </summary>
        /// <param name="other">enumerable with items to add </param>
        public void IntersectWith(IEnumerable<T> other)
        {
            // intersection of anything with empty set is empty set, so return if count is 0
            if (size == 0)
            {
                return;
            }

            // if other is empty, intersection is empty set; remove all elements and we're done
            // can only figure this out if implements ICollection<T>. (IEnumerable<T> has no count)
            ICollection<T> otherAsCollection = other as ICollection<T>;
            if (otherAsCollection != null)
            {
                if (otherAsCollection.Count == 0)
                {
                    Clear();
                    return;
                }

                HashSet<T> otherAsSet = other as HashSet<T>;
                // faster if other is a hashset using same equality comparer; so check 
                // that other is a hashset using the same equality comparer.
                if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
                {
                    IntersectWithHashSetWithSameEC(otherAsSet);
                    return;
                }
            }

            IntersectWithEnumerable(other);
        }

        /// <summary>
        /// Remove items in other from this set. Modifies this set.
        /// </summary>
        /// <param name="other">enumerable with items to remove</param>
        public void ExceptWith(IEnumerable<T> other)
        {
            if (size == 0)
            {
                return;
            }

            // special case if other is this; a set minus itself is the empty set
            if (other == this)
            {
                Clear();
                return;
            }

            // remove every element in other from this
            foreach (T element in other)
            {
                Remove(element);
            }
        }

        /// <summary>
        /// Takes symmetric difference (XOR) with other and this set. Modifies this set.
        /// </summary>
        /// <param name="other">enumerable with items to XOR</param>
        public void SymmetricExceptWith(IEnumerable<T> other)
        {
            // if set is empty, then symmetric difference is other
            if (size == 0)
            {
                UnionWith(other);
                return;
            }

            // special case this; the symmetric difference of a set with itself is the empty set
            if (other == this)
            {
                Clear();
                return;
            }

            HashSet<T> otherAsSet = other as HashSet<T>;
            // If other is a HashSet, it has unique elements according to its equality comparer,
            // but if they're using different equality comparers, then assumption of uniqueness
            // will fail. So first check if other is a hashset using the same equality comparer;
            // symmetric except is a lot faster and avoids bit array allocations if we can assume
            // uniqueness
            if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
            {
                SymmetricExceptWithUniqueHashSet(otherAsSet);
            }
            else
            {
                SymmetricExceptWithEnumerable(other);
            }
        }

        /// <summary>
        /// Checks if this is a subset of other.
        /// 
        /// Implementation Notes:
        /// The following properties are used up-front to avoid element-wise checks:
        /// 1. If this is the empty set, then it's a subset of anything, including the empty set
        /// 2. If other has unique elements according to this equality comparer, and this has more
        /// elements than other, then it can't be a subset.
        /// 
        /// Furthermore, if other is a hashset using the same equality comparer, we can use a 
        /// faster element-wise check.
        /// </summary>
        /// <param name="other"></param>
        /// <returns>true if this is a subset of other; false if not</returns>
        public bool IsSubsetOf(IEnumerable<T> other)
        {
            // The empty set is a subset of any set
            if (size == 0)
            {
                return true;
            }

            HashSet<T> otherAsSet = other as HashSet<T>;
            // faster if other has unique elements according to this equality comparer; so check 
            // that other is a hashset using the same equality comparer.
            if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
            {
                // if this has more elements then it can't be a subset
                if (size > otherAsSet.Count)
                {
                    return false;
                }

                // already checked that we're using same equality comparer. simply check that 
                // each element in this is contained in other.
                return IsSubsetOfHashSetWithSameEC(otherAsSet);
            }
            else
            {
                ElementCount result = CheckUniqueAndUnfoundElements(other, false);
                return (result.uniqueCount == size && result.unfoundCount >= 0);
            }
        }

        /// <summary>
        /// Checks if this is a proper subset of other (i.e. strictly contained in)
        /// 
        /// Implementation Notes:
        /// The following properties are used up-front to avoid element-wise checks:
        /// 1. If this is the empty set, then it's a proper subset of a set that contains at least
        /// one element, but it's not a proper subset of the empty set.
        /// 2. If other has unique elements according to this equality comparer, and this has >=
        /// the number of elements in other, then this can't be a proper subset.
        /// 
        /// Furthermore, if other is a hashset using the same equality comparer, we can use a 
        /// faster element-wise check.
        /// </summary>
        /// <param name="other"></param>
        /// <returns>true if this is a proper subset of other; false if not</returns>
        public bool IsProperSubsetOf(IEnumerable<T> other)
        {
            ICollection<T> otherAsCollection = other as ICollection<T>;
            if (otherAsCollection != null)
            {
                // the empty set is a proper subset of anything but the empty set
                if (size == 0)
                {
                    return otherAsCollection.Count > 0;
                }
                HashSet<T> otherAsSet = other as HashSet<T>;
                // faster if other is a hashset (and we're using same equality comparer)
                if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
                {
                    if (size >= otherAsSet.Count)
                    {
                        return false;
                    }
                    // this has strictly less than number of items in other, so the following
                    // check suffices for proper subset.
                    return IsSubsetOfHashSetWithSameEC(otherAsSet);
                }
            }

            ElementCount result = CheckUniqueAndUnfoundElements(other, false);
            return (result.uniqueCount == size && result.unfoundCount > 0);
        }

        /// <summary>
        /// Checks if this is a superset of other
        /// 
        /// Implementation Notes:
        /// The following properties are used up-front to avoid element-wise checks:
        /// 1. If other has no elements (it's the empty set), then this is a superset, even if this
        /// is also the empty set.
        /// 2. If other has unique elements according to this equality comparer, and this has less 
        /// than the number of elements in other, then this can't be a superset
        /// 
        /// </summary>
        /// <param name="other"></param>
        /// <returns>true if this is a superset of other; false if not</returns>
        public bool IsSupersetOf(IEnumerable<T> other)
        {

            // try to fall out early based on counts
            ICollection<T> otherAsCollection = other as ICollection<T>;
            if (otherAsCollection != null)
            {
                // if other is the empty set then this is a superset
                if (otherAsCollection.Count == 0)
                {
                    return true;
                }
                HashSet<T> otherAsSet = other as HashSet<T>;
                // try to compare based on counts alone if other is a hashset with
                // same equality comparer
                if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
                {
                    if (otherAsSet.Count > size)
                    {
                        return false;
                    }
                }
            }

            return ContainsAllElements(other);
        }

        /// <summary>
        /// Checks if this is a proper superset of other (i.e. other strictly contained in this)
        /// 
        /// Implementation Notes: 
        /// This is slightly more complicated than above because we have to keep track if there
        /// was at least one element not contained in other.
        /// 
        /// The following properties are used up-front to avoid element-wise checks:
        /// 1. If this is the empty set, then it can't be a proper superset of any set, even if 
        /// other is the empty set.
        /// 2. If other is an empty set and this contains at least 1 element, then this is a proper
        /// superset.
        /// 3. If other has unique elements according to this equality comparer, and other's count
        /// is greater than or equal to this count, then this can't be a proper superset
        /// 
        /// Furthermore, if other has unique elements according to this equality comparer, we can
        /// use a faster element-wise check.
        /// </summary>
        /// <param name="other"></param>
        /// <returns>true if this is a proper superset of other; false if not</returns>
        public bool IsProperSupersetOf(IEnumerable<T> other)
        {
            // the empty set isn't a proper superset of any set.
            if (size == 0)
            {
                return false;
            }

            ICollection<T> otherAsCollection = other as ICollection<T>;
            if (otherAsCollection != null)
            {
                // if other is the empty set then this is a superset
                if (otherAsCollection.Count == 0)
                {
                    // note that this has at least one element, based on above check
                    return true;
                }
                HashSet<T> otherAsSet = other as HashSet<T>;
                // faster if other is a hashset with the same equality comparer
                if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
                {
                    if (otherAsSet.Count >= size)
                    {
                        return false;
                    }
                    // now perform element check
                    return ContainsAllElements(otherAsSet);
                }
            }
            // couldn't fall out in the above cases; do it the long way
            ElementCount result = CheckUniqueAndUnfoundElements(other, true);
            return (result.uniqueCount < size && result.unfoundCount == 0);
        }

        /// <summary>
        /// Checks if this set overlaps other (i.e. they share at least one item)
        /// </summary>
        /// <param name="other"></param>
        /// <returns>true if these have at least one common element; false if disjoint</returns>
        public bool Overlaps(IEnumerable<T> other)
        {

            if (size == 0)
            {
                return false;
            }

            foreach (T element in other)
            {
                if (Contains(element))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Checks if this and other contain the same elements. This is set equality: 
        /// duplicates and order are ignored
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public bool SetEquals(IEnumerable<T> other)
        {

            HashSet<T> otherAsSet = other as HashSet<T>;
            // faster if other is a hashset and we're using same equality comparer
            if (otherAsSet != null && AreEqualityComparersEqual(this, otherAsSet))
            {
                // attempt to return early: since both contain unique elements, if they have 
                // different counts, then they can't be equal
                if (size != otherAsSet.Count)
                {
                    return false;
                }

                // already confirmed that the sets have the same number of distinct elements, so if
                // one is a superset of the other then they must be equal
                return ContainsAllElements(otherAsSet);
            }
            else
            {
                ICollection<T> otherAsCollection = other as ICollection<T>;
                if (otherAsCollection != null)
                {
                    // if this count is 0 but other contains at least one element, they can't be equal
                    if (size == 0 && otherAsCollection.Count > 0)
                    {
                        return false;
                    }
                }
                ElementCount result = CheckUniqueAndUnfoundElements(other, true);
                return (result.uniqueCount == size && result.unfoundCount == 0);
            }
        }

        public void CopyTo(T[] array, int arrayIndex = 0, int count = Count)
        {
            // check array index valid index into array
            if (arrayIndex < 0)
            {
                throw new ArgumentOutOfRangeException("arrayIndex SR.ArgumentOutOfRange_NeedNonNegNum");
            }

            // also throw if count less than 0
            if (count < 0)
            {
                throw new ArgumentOutOfRangeException("count SR.ArgumentOutOfRange_NeedNonNegNum");
            }

            // will array, starting at arrayIndex, be able to hold elements? Note: not
            // checking arrayIndex >= array.Length (consistency with list of allowing
            // count of 0; subsequent check takes care of the rest)
            if (arrayIndex > array.Length || count > array.Length - arrayIndex)
            {
                throw new ArgumentException("SR.Arg_ArrayPlusOffTooSmall");
            }

        }

        /// <summary>
        /// Remove elements that match specified predicate. Returns the number of elements removed
        /// </summary>
        /// <param name="match"></param>
        /// <returns></returns>
        /*
        public int RemoveWhere(Predicate<T> match)
        {

            int numRemoved = 0;

            return numRemoved;
        }
        */

        /// <summary>
        /// Gets the IEqualityComparer that is used to determine equality of keys for 
        /// the HashSet.
        /// </summary>
        public IEqualityComparer<T> Comparer
        {
            get
            {
                return _comparer;
            }
        }

        /// <summary>
        /// Sets the capacity of this list to the size of the list (rounded up to nearest prime),
        /// unless count is 0, in which case we release references.
        /// 
        /// This method can be used to minimize a list's memory overhead once it is known that no
        /// new elements will be added to the list. To completely clear a list and release all 
        /// memory referenced by the list, execute the following statements:
        /// 
        /// list.Clear();
        /// list.TrimExcess(); 
        /// </summary>
        public void TrimExcess()
        {

        }


        /// <summary>
        /// Initializes buckets and slots arrays. Uses suggested capacity by finding next prime
        /// greater than or equal to capacity.
        /// </summary>
        /// <param name="capacity"></param>
        private void Initialize(int capacity)
        {
        }

        /// <summary>
        /// Expand to new capacity. New capacity is next prime greater than or equal to suggested 
        /// size. This is called when the underlying array is filled. This performs no 
        /// defragmentation, allowing faster execution; note that this is reasonable since 
        /// AddIfNotPresent attempts to insert new elements in re-opened spots.
        /// </summary>
        /// <param name="sizeSuggestion"></param>
        private void IncreaseCapacity()
        {
        }

        /// <summary>
        /// Set the underlying buckets array to size newSize and rehash.  Note that newSize
        /// *must* be a prime.  It is very likely that you want to call IncreaseCapacity()
        /// instead of this method.
        /// </summary>
        private void SetCapacity(int newSize, bool forceNewHashCodes)
        {
        }

        /// <summary>
        /// Adds value to HashSet if not contained already
        /// Returns true if added and false if already present
        /// </summary>
        /// <param name="value">value to find</param>
        /// <returns></returns>
        private bool AddIfNotPresent(T value)
        {
			if (contains (value)) {
				return false;
			} else {
				return add (value);
			}
        }

        /// <summary>
        /// Checks if this contains of other's elements. Iterates over other's elements and 
        /// returns false as soon as it finds an element in other that's not in this.
        /// Used by SupersetOf, ProperSupersetOf, and SetEquals.
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        private bool ContainsAllElements(IEnumerable<T> other)
        {
            foreach (T element in other)
            {
                if (!Contains(element))
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Implementation Notes:
        /// If other is a hashset and is using same equality comparer, then checking subset is 
        /// faster. Simply check that each element in this is in other.
        /// 
        /// Note: if other doesn't use same equality comparer, then Contains check is invalid,
        /// which is why callers must take are of this.
        /// 
        /// If callers are concerned about whether this is a proper subset, they take care of that.
        ///
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        private bool IsSubsetOfHashSetWithSameEC(HashSet<T> other)
        {
            foreach (T item in this)
            {
                if (!other.Contains(item))
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// If other is a hashset that uses same equality comparer, intersect is much faster 
        /// because we can use other's Contains
        /// </summary>
        /// <param name="other"></param>
        private void IntersectWithHashSetWithSameEC(HashSet<T> other)
        {
            foreach (T item in this)
            {
                  if (!other.Contains(item))
                    {
                        Remove(item);
                    }
            }
        }

        /// <summary>
        /// Iterate over other. If contained in this, mark an element in bit array corresponding to
        /// its position in _slots. If anything is unmarked (in bit array), remove it.
        /// 
        /// This attempts to allocate on the stack, if below StackAllocThreshold.
        /// </summary>
        /// <param name="other"></param>
        private void IntersectWithEnumerable(IEnumerable<T> other)
        {
            // mark if contains: find index of in slots array and mark corresponding element in bit array
            foreach (T item in other)
            {
				
            }
        }


        /// <summary>
        /// if other is a set, we can assume it doesn't have duplicate elements, so use this
        /// technique: if can't remove, then it wasn't present in this set, so add.
        /// 
        /// As with other methods, callers take care of ensuring that other is a hashset using the
        /// same equality comparer.
        /// </summary>
        /// <param name="other"></param>
        private void SymmetricExceptWithUniqueHashSet(HashSet<T> other)
        {
            foreach (T item in other)
            {
                if (!Remove(item))
                {
                    AddIfNotPresent(item);
                }
            }
        }

        /// <summary>
        /// Implementation notes:
        /// 
        /// Used for symmetric except when other isn't a HashSet. This is more tedious because 
        /// other may contain duplicates. HashSet technique could fail in these situations:
        /// 1. Other has a duplicate that's not in this: HashSet technique would add then 
        /// remove it.
        /// 2. Other has a duplicate that's in this: HashSet technique would remove then add it
        /// back.
        /// In general, its presence would be toggled each time it appears in other. 
        /// 
        /// This technique uses bit marking to indicate whether to add/remove the item. If already
        /// present in collection, it will get marked for deletion. If added from other, it will
        /// get marked as something not to remove.
        ///
        /// </summary>
        /// <param name="other"></param>
        private void SymmetricExceptWithEnumerable(IEnumerable<T> other)
        {

            foreach (T item in other)
            {
				
            }

        }

        /// <summary>
        /// Add if not already in hashset. Returns an out param indicating index where added. This 
        /// is used by SymmetricExcept because it needs to know the following things:
        /// - whether the item was already present in the collection or added from other
        /// - where it's located (if already present, it will get marked for removal, otherwise
        /// marked for keeping)
        /// </summary>
        /// <param name="value"></param>
        /// <param name="location"></param>
        /// <returns></returns>
        private bool AddOrGetLocation(T value, out int location)
        {
			if (contains (value)) {
				for (int i = 0; i < size; i++) {
					if (this[i] == value) {
						location = i;
						return false;
					}
				}
			} else {
				location = size;
				add (value);
				return true;
			}
        }

        /// <summary>
        /// Determines counts that can be used to determine equality, subset, and superset. This
        /// is only used when other is an IEnumerable and not a HashSet. If other is a HashSet
        /// these properties can be checked faster without use of marking because we can assume 
        /// other has no duplicates.
        /// 
        /// The following count checks are performed by callers:
        /// 1. Equals: checks if unfoundCount = 0 and uniqueFoundCount = size; i.e. everything 
        /// in other is in this and everything in this is in other
        /// 2. Subset: checks if unfoundCount >= 0 and uniqueFoundCount = size; i.e. other may
        /// have elements not in this and everything in this is in other
        /// 3. Proper subset: checks if unfoundCount > 0 and uniqueFoundCount = size; i.e
        /// other must have at least one element not in this and everything in this is in other
        /// 4. Proper superset: checks if unfound count = 0 and uniqueFoundCount strictly less
        /// than size; i.e. everything in other was in this and this had at least one element
        /// not contained in other.
        /// 
        /// An earlier implementation used delegates to perform these checks rather than returning
        /// an ElementCount struct; however this was changed due to the perf overhead of delegates.
        /// </summary>
        /// <param name="other"></param>
        /// <param name="returnIfUnfound">Allows us to finish faster for equals and proper superset
        /// because unfoundCount must be 0.</param>
        /// <returns></returns>
        private ElementCount CheckUniqueAndUnfoundElements(IEnumerable<T> other, bool returnIfUnfound)
        {
            ElementCount result;

            // need special case in case this has no elements. 
            if (size == 0)
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


            // count of items in other not found in this
            int unfoundCount = 0;
            // count of unique items in other found in this
            int uniqueFoundCount = 0;

            foreach (T item in other)
            {
            }

            result.uniqueCount = uniqueFoundCount;
            result.unfoundCount = unfoundCount;
            return result;
        }

        /// <summary>
        /// Copies this to an array. Used for DebugView
        /// </summary>
        /// <returns></returns>
        internal T[] ToArray()
        {
            T[] newArray = new T[Count];
            CopyTo(newArray);
            return newArray;
        }

        /// <summary>
        /// Internal method used for HashSetEqualityComparer. Compares set1 and set2 according 
        /// to specified comparer.
        /// 
        /// Because items are hashed according to a specific equality comparer, we have to resort
        /// to n^2 search if they're using different equality comparers.
        /// </summary>
        /// <param name="set1"></param>
        /// <param name="set2"></param>
        /// <param name="comparer"></param>
        /// <returns></returns>
        internal static bool HashSetEquals(HashSet<T> set1, HashSet<T> set2, IEqualityComparer<T> comparer)
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

            // all comparers are the same; this is faster
            if (AreEqualityComparersEqual(set1, set2))
            {
                if (set1.Count != set2.Count)
                {
                    return false;
                }
                // suffices to check subset
                foreach (T item in set2)
                {
                    if (!set1.Contains(item))
                    {
                        return false;
                    }
                }
                return true;
            }
            else
            {  // n^2 search because items are hashed according to their respective ECs
                foreach (T set2Item in set2)
                {
                    bool found = false;
                    foreach (T set1Item in set1)
                    {
                        if (comparer.Equals(set2Item, set1Item))
                        {
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        /// <summary>
        /// Checks if equality comparers are equal. This is used for algorithms that can
        /// speed up if it knows the other item has unique elements. I.e. if they're using 
        /// different equality comparers, then uniqueness assumption between sets break.
        /// </summary>
        /// <param name="set1"></param>
        /// <param name="set2"></param>
        /// <returns></returns>
        private static bool AreEqualityComparersEqual(HashSet<T> set1, HashSet<T> set2)
        {
            return set1.Comparer.Equals(set2.Comparer);
        }

        /// <summary>
        /// Workaround Comparers that throw ArgumentNullException for GetHashCode(null).
        /// </summary>
        /// <param name="item"></param>
        /// <returns>hash code</returns>
        private int InternalGetHashCode(T item)
        {
            if (item == null)
            {
                return 0;
            }
            return _comparer.GetHashCode(item) & Lower31BitMask;
        }

        

        // used for set checking operations (using enumerables) that rely on counting
        internal struct ElementCount
        {
            int uniqueCount;
            int unfoundCount;
        }

        internal struct Slot
        {
            int hashCode;      // Lower 31 bits of hash code, -1 if unused
            T value;
            int next;          // Index of next entry, -1 if last
        }

		[Compact]
        public class Enumerator : IEnumerator<T>, System.Collections.IEnumerator
        {
            private HashSet<T> _set;
			private T _currentElement;
			private Gee.Iterator _iterator;

            public Enumerator(HashSet<T> hashset)
            {
                _set = hashset;
                _current = default(T);
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

           void Reset()
            {
				_iterator = _set.iterator();
                _current = default(T);
            }
        }
    }
}
