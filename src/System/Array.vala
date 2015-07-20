using System;
using System.Collections.Generic;

namespace System {

	public abstract class Array<TKey, TValue> : GLib.Object {
	
		public static void Sort<TKey, TValue>(TKey[] keys, TValue[] items, IComparer<TKey>? comparer = null, int index = 0, int length = keys.length ) {

            if (length > 1) {
                TKey[] objKeys = keys;
                TValue[] objItems = null;
                if (objKeys != null)
                    objItems = items;
                if (objKeys != null && (items==null || objItems != null)) {
                    
                    SorterObjectArray sorter = new SorterObjectArray(objKeys, objItems, comparer);
                    sorter.Sort(index, length);
                }
                else {
                    SorterGenericArray sorter = new SorterGenericArray(keys, items, comparer);
                    sorter.Sort(index, length);
                }
            }

		}
		
		public static int BinarySearch(TKey[] array, int index, int length, TKey value, IComparer<TKey> comparer) {
            
            if (comparer == null) comparer = Comparer.Default;

            int lo = index;
            int hi = index + length - 1;   

            TKey[] objArray = array;

            if(objArray != null) {
                while (lo <= hi) {
                    // i might overflow if lo and hi are both large positive numbers. 
                    int i = GetMedian(lo, hi);

                    int c;
                    try {
                        c = comparer.Compare(objArray[i], value);
                    }
                    catch (Exception e) {
                        throw new InvalidOperationException.COMPAREFAILED("InvalidOperation_IComparerFailed");
                    }
                    if (c == 0) return i;
                    if (c < 0) {
                        lo = i + 1;
                    }
                    else {
                        hi = i - 1;
                    }
                }
            }
            else {
                while (lo <= hi) {
                    int i = GetMedian(lo, hi);                    

                    int c;
                    try {
                        c = comparer.Compare(array[i], value);
                    }
                    catch (Exception e) {
                        throw new InvalidOperationException.COMPAREFAILED("InvalidOperation_IComparerFailed");
                    }
                    if (c == 0) return i;
                    if (c < 0) {
                        lo = i + 1;
                    }
                    else {
                        hi = i - 1;
                    }
                }
            }
            return ~lo;
        }

	   private static int GetMedian(int low, int hi)
		   requires(low <= hi)
		   ensures (hi - low >= 0)
		{
            // Note both may be negative, if we are dealing with arrays w/ negative lower bounds.
            return low + ((hi - low) >> 1);
        }

	}


}
