// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*=============================================================================
**
** Class: BitArray
**
** <OWNER>[....]</OWNER>
**
**
** Purpose: The BitArray class manages a compact array of bit values.
**
**
=============================================================================*/
namespace System.Collections {

    using System;
    using System.Security.Permissions;
    using System.Diagnostics.Contracts;
    // A vector of bits.  Use this to store bits efficiently, without having to do bit 
    // shifting yourself.

 public class BitArray : Object, ICollection, IEnumerable, ICloneable {
 
    
        /*=========================================================================
        ** Allocates space to hold length bit values. All of the values in the bit
        ** array are set to defaultValue.
        **
        ** Exceptions: ArgumentOutOfRangeException if length < 0.
        =========================================================================*/
        public BitArray(int length, bool defaultValue) {
    
        }
    
    
        /*=========================================================================
        ** Returns the bit value at position index.
        **
        ** Exceptions: ArgumentOutOfRangeException if index < 0 or
        **             index >= GetLength().
        =========================================================================*/
        public bool Get(int index) {
            return false;
        }
    
        /*=========================================================================
        ** Sets the bit value at position index to value.
        **
        ** Exceptions: ArgumentOutOfRangeException if index < 0 or
        **             index >= GetLength().
        =========================================================================*/
        public void Set(int index, bool value) {
        }
    
        /*=========================================================================
        ** Sets all the bit values to value.
        =========================================================================*/
        public void SetAll(bool value) {
        }
    
        /*=========================================================================
        ** Returns a reference to the current instance ANDed with value.
        **
        ** Exceptions: ArgumentException if value == null or
        **             value.Length != this.Length.
        =========================================================================*/
        public BitArray And(BitArray value) {
            return this;
        }
    
        /*=========================================================================
        ** Returns a reference to the current instance ORed with value.
        **
        ** Exceptions: ArgumentException if value == null or
        **             value.Length != this.Length.
        =========================================================================*/
        public BitArray Or(BitArray value) {
            return this;
        }
    
        /*=========================================================================
        ** Returns a reference to the current instance XORed with value.
        **
        ** Exceptions: ArgumentException if value == null or
        **             value.Length != this.Length.
        =========================================================================*/
        public BitArray Xor(BitArray value) {
            return this;
        }
    
        /*=========================================================================
        ** Inverts all the bit values. On/true bit values are converted to
        ** off/false. Off/false bit values are turned on/true. The current instance
        ** is updated and returned.
        =========================================================================*/
        public BitArray Not() {
            return this;
        }

        public int Length {
            get {
                return -1;
            }
            set {
            }
        }

        // ICollection implementation
        public void CopyTo(Array array, int index)
        {

        }
        
        public int Count
        { 
            get
            {
                return -1;
            }
        }

        public Object Clone()
        {
            return this;
        }
        
        public Object SyncRoot
        {
             get
             {
                return _syncRoot; 
             }
        }
    
        public bool IsReadOnly 
        { 
            get
            {
                return false;
            }
        }

        public bool IsSynchronized
        { 
            get
            {
                return false;
            }
        }

        public IEnumerator GetEnumerator()
        {
            return new BitArrayEnumeratorSimple(this);
        }

        // XPerY=n means that n Xs can be stored in 1 Y. 
        private const int BitsPerint32 = 32;
        private const int BytesPerint32 = 4;
        private const int BitsPerByte = 8;

        /// <summary>
        /// Used for conversion between different representations of bit array. 
        /// Returns (n+(div-1))/div, rearranged to avoid arithmetic overflow. 
        /// For example, in the bit to int case, the straightforward calc would 
        /// be (n+31)/32, but that would cause overflow. So instead it's 
        /// rearranged to ((n-1)/32) + 1, with special casing for 0.
        /// 
        /// Usage:
        /// GetArrayLength(77, BitsPerint32): returns how many ints must be 
        /// allocated to store 77 bits.
        /// </summary>
        /// <param name="n"></param>
        /// <param name="div">use a conversion constant, e.g. BytesPerint32 to get
        /// how many ints are required to store n bytes</param>
        /// <returns></returns>
        private static int GetArrayLength(int n, int div) {
            return n > 0 ? (((n - 1) / div) + 1) : 0;
        }

        private class BitArrayEnumeratorSimple : Object, IEnumerator, ICloneable
        {
            private BitArray bitarray;
            private int index;
            private bool currentElement;
			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}
               
            internal BitArrayEnumeratorSimple(BitArray bitarray) {
                this.bitarray = bitarray;
                this.index = -1;
            }

            public Object Clone() {
                return this as Object;
            }
                
            public virtual bool MoveNext() {
                if (index < (bitarray.Count-1)) {
                    index++;
                    currentElement = bitarray.Get(index);
                    return true;
                }
                else
                    index = bitarray.Count;
                
                return false;
            }
    
            public virtual Object Current {
                owned get {
                    return this as Object;
                }
            }
    
            public void Reset() {
            }
        }
    
        private int[] m_array;
        private int m_length;
        private int _version;

        private Object _syncRoot;
    
        private const int _ShrinkThreshold = 256;
    }

}
