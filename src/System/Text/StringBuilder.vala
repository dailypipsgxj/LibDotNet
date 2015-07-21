// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** ClassStringBuilder
**
**
** Purpose: implementation of theStringBuilder
** class.
**
===========================================================*/
namespace System.Text {
    using System.Text;
    using System.Runtime;
    using System.Runtime.Serialization;
    using System;
    using System.Runtime.CompilerServices;
    //using System.Runtime.Versioning;
    using System.Security;
    using System.Threading;
    using System.Globalization;
    using System.Diagnostics.Contracts;

    // This class represents a mutable string.  It is convenient for situations in
    // which it is desirable to modify a string, perhaps by removing, replacing, or 
    // inserting characters, without creating a newstring subsequent to
    // each modification. 
    // 
    // The methods contained within this class do not return a newStringBuilder
    // Object unless specified otherwise.  This class may be used in conjunction with thestring
    // class to carry out modifications upon strings.
    // 
    // When passing null into a constructor in VJ and VC, the null
    // should be explicitly type cast.
    // For ExampleStringBuilder sb1 = newStringBuilderStringBuilder)nullStringBuilder sb2 = newStringBuilderstring)null);
    // Console.WriteLine(sb1);
    // Console.WriteLine(sb2);
    // 


    public class StringBuilder : GLib.StringBuilder, ISerializable {
        // AStringBuilder is internally represented as a linked list of blocks each of which holds
        // a chunk of the string.  It turns out string as a whole can also be represented as just a chunk, 
        // so that is what we do.  
        //  CLASS VARIABLES
        internal char[] m_ChunkChars;                // The characters in this block
        internal StringBuilder m_ChunkPrevious;      // Link to the block logically before this block
        internal int m_ChunkLength;                  // The index in m_ChunkChars that represent the end of the block
        internal int m_ChunkOffset;                  // The logial offset (sum of all characters in previous blocks)
        internal int m_MaxCapacity = 0;
        // STATIC CONSTANTS
        internal const int DefaultCapacity = 16;
        private const string CapacityField = "Capacity";
        private const string MaxCapacityField = "m_MaxCapacity";
        private const string StringValueField = "m_stringValue";
        private const string ThreadIDField = "m_currentThread";
        // We want to keep chunk arrays out of large Object heap (< 85K uint8s ~ 40K chars) to be sure.
        // Making the maximum chunk size big means less allocation code called, but also more waste
        // in unused characters and slower inserts / replaces (since you do need to slide characters over
        // within a buffer).  
        internal const int MaxChunkSize = 8000;
        //CONSTRUCTORS
        // Creates a new empty string builder (i.e., it representsstring.Empty)
        // with the default capacity (16 characters).
        // Create a new empty string builder (i.e., it representsstring.Empty)
        // with the specified capacity.

        public StringBuilder (string? value, int startIndex = 0, int length = 0, int capacity = 16)
			requires (capacity > 0)
			requires (startIndex >= 0)
			requires (startIndex < value.length - length)
		{
            if (value == null) {
                value = "";
            }
            
            m_MaxCapacity = int32.MAX;
            if (capacity == 0) {
                capacity = DefaultCapacity;
            }
            if (capacity < length)
                capacity = length;

            m_ChunkChars = new char[capacity];
            m_ChunkLength = length;

            char* sourcePtr = value;
            ThreadSafeCopy(sourcePtr + startIndex, m_ChunkChars, 0, length);
        }


        private void VerifyClassInvariant() {
            StringBuilder currentBlock = this;
            int maxCapacity = this.m_MaxCapacity;
            for (; ; )
            {
                // All blocks have copy of the maxCapacity.
                GLib.assert(currentBlock.m_MaxCapacity == maxCapacity);
                GLib.assert(currentBlock.m_ChunkChars != null);

                GLib.assert(currentBlock.m_ChunkLength <= currentBlock.m_ChunkChars.length);
                GLib.assert(currentBlock.m_ChunkLength >= 0);
                GLib.assert(currentBlock.m_ChunkOffset >= 0);
                
                StringBuilder prevBlock = currentBlock.m_ChunkPrevious;
                if (prevBlock == null)
                {
                    GLib.assert(currentBlock.m_ChunkOffset == 0);
                    break;
                }
                // There are no gaps in the blocks. 
                GLib.assert(currentBlock.m_ChunkOffset == prevBlock.m_ChunkOffset + prevBlock.m_ChunkLength);
                currentBlock = prevBlock;
            }
        }

        public int Capacity {
            get { return m_ChunkChars.length + m_ChunkOffset; }
            set {
                if (value < 0) {
                    throw new ArgumentOutOfRangeException.NEGATIVE_CAPACITY("value");
                }
                if (value > MaxCapacity) {
                    throw new ArgumentOutOfRangeException.CAPACITY("value");
                }
                if (value < Length) {
                    throw new ArgumentOutOfRangeException.SMALL_CAPACITY("value");
                }

                if (Capacity != value) {
                    int newLen = value - m_ChunkOffset;
                    char[] newArray = new char[newLen];
                    Array.Copy(m_ChunkChars, newArray, m_ChunkLength);
                    m_ChunkChars = newArray;
                }
            }
        }

        public int MaxCapacity {
            get { return m_MaxCapacity; }
        }

        // Read-Only Property 
        // Ensures that the capacity of this string builder is at least the specified value.  
        // If capacity is greater than the capacity of this string builder, then the capacity
        // is set to capacity; otherwise the capacity is unchanged.
        // 
        public int EnsureCapacity(int capacity)
			requires (capacity >= 0)
        {
            if (Capacity < capacity)
                Capacity = capacity;
            return Capacity;
        }

        // Converts a substring of this string builder to astring.

        public string ToString(int startIndex = 0, int length = Length)
			requires (length >= 0)
			requires (startIndex < this.Length - length)
			requires (startIndex >= 0)
			requires (startIndex < this.Length)
            ensures(result != null)
        {
            int currentLength = this.Length;

            VerifyClassInvariant();
            StringBuilder chunk = this;
            int sourceEndIndex = startIndex + length;

            string ret = string.FastAllocatestring(length);
            int curDestIndex = length;
			weak char* destinationPtr = ret;
			while (curDestIndex > 0)
			{
				int chunkEndIndex = sourceEndIndex - chunk.m_ChunkOffset;
				if (chunkEndIndex >= 0)
				{
					if (chunkEndIndex > chunk.m_ChunkLength)
						chunkEndIndex = chunk.m_ChunkLength;

					int countLeft = curDestIndex;
					int chunkCount = countLeft;
					int chunkStartIndex = chunkEndIndex - countLeft;
					if (chunkStartIndex < 0)
					{
						chunkCount += chunkStartIndex;
						chunkStartIndex = 0;
					}
					curDestIndex -= chunkCount;

					if (chunkCount > 0)
					{
						// work off of local variables so that they are stable even in the presence of ----s (hackers might do this)
						char[] sourceArray = chunk.m_ChunkChars;

						// Check that we will not overrun our boundaries. 
						if ((uint)(chunkCount + curDestIndex) <= length && (uint)(chunkCount + chunkStartIndex) <= (uint)sourceArray.length)
						{
								weak char* sourcePtr = &sourceArray[chunkStartIndex];
								string.wstrcpy(destinationPtr + curDestIndex, sourcePtr, chunkCount);
						}
						else
						{
							throw new ArgumentOutOfRangeException.INDEX("chunkCount");
						}
					}
				}
				chunk = chunk.m_ChunkPrevious;
			}
            return ret;
        }

        // Convenience method for sb.length=0;
        public StringBuilder Clear() {
            this.Length = 0;
            return this;
        }

        // Sets the length of thestring in this buffer.  If length is less than the current
        // instance, theStringBuilder is truncated.  If length is greater than the current 
        // instance, nulls are appended.  The capacity is adjusted to be the same as the length.

        public int Length {
            get {
                return m_ChunkOffset + m_ChunkLength;
            }
            set {
                //If the new length is less than 0 or greater than our Maximum capacity, bail.
                if (value<0) {
                    throw new ArgumentOutOfRangeException.NEGATIVE_LENGTH("value");
                }

                if (value>MaxCapacity) {
                    throw new ArgumentOutOfRangeException.SMALL_CAPACITY("value");
                }

                int originalCapacity = Capacity;

                if (value == 0 && m_ChunkPrevious == null)
                {
                    m_ChunkLength = 0;
                    m_ChunkOffset = 0;
                    GLib.assert(Capacity >= originalCapacity, "setting the Length should never decrease the Capacity");
                    return;
                }

                int delta = value - Length;
                // if the specified length is greater than the current length
                if (delta > 0)
                {
                    // the end of the string value of the currentStringBuilder Object is padded with the Unicode NULL character
                    Append('\0', delta);        // We could improve on this, but who does this anyway?
                }
                // if the specified length is less than or equal to the current length
                else
                {
					StringBuilder chunk = FindChunkForIndex(value);
                    if (chunk != this)
                    {
                        // we crossed a chunk boundary when reducing the Length, we must replace this middle-chunk with a new
                        // larger chunk to ensure the original capacity is preserved
                        int newLen = originalCapacity - chunk.m_ChunkOffset;
                        char[] newArray = new char[newLen];

                        GLib.assert(newLen > chunk.m_ChunkChars.length);
                        Array.Copy(chunk.m_ChunkChars, newArray, chunk.m_ChunkLength);
                        
                        m_ChunkChars = newArray;
                        m_ChunkPrevious = chunk.m_ChunkPrevious;                        
                        m_ChunkOffset = chunk.m_ChunkOffset;
                    }
                    m_ChunkLength = value - chunk.m_ChunkOffset;
                    VerifyClassInvariant();
                }
                GLib.assert(Capacity >= originalCapacity);
            }
        }

        public char get (int index) {
            StringBuilder chunk = this;
			for (; ; )
			{
				int indexInBlock = index - chunk.m_ChunkOffset;
				if (indexInBlock >= 0)
				{
					if (indexInBlock >= chunk.m_ChunkLength)
						throw IndexOutOfRangeException();
					return chunk.m_ChunkChars[indexInBlock];
				}
				chunk = chunk.m_ChunkPrevious;
				if (chunk == null)
					throw IndexOutOfRangeException();
			}
		}
            
		public void set (int index, string value){
            
            StringBuilder chunk = this;
			for (; ; )
			{
				int indexInBlock = index - chunk.m_ChunkOffset;
				if (indexInBlock >= 0)
				{
					if (indexInBlock >= chunk.m_ChunkLength)
						throw new ArgumentOutOfRangeException.INDEX("index");
					chunk.m_ChunkChars[indexInBlock] = value;
					return;
				}
				chunk = chunk.m_ChunkPrevious;
				if (chunk == null)
					throw new ArgumentOutOfRangeException.INDEX("index");
			}
        }

        // Appends a character at the end of this string builder. The capacity is adjusted as needed.
        public StringBuilder AppendCopies(char value, int repeatCount) {
            if (repeatCount<0) {
                throw new ArgumentOutOfRangeException("repeatCount", Environment.GetResourcestring("ArgumentOutOfRange_NegativeCount"));
            }
            ensures(result != null);
            

            if (repeatCount==0) {
                return this;
            }
            int idx = m_ChunkLength;
            while (repeatCount > 0)
            {
                if (idx < m_ChunkChars.length)
                {
                    m_ChunkChars[idx++] = value;
                    --repeatCount;
                }
                else
                {
                    m_ChunkLength = idx;
                    ExpandByABlock(repeatCount);
                    GLib.assert(m_ChunkLength == 0, "Expand should create a new block");
                    idx = 0;
                }
            }
            m_ChunkLength = idx;
            VerifyClassInvariant();
            return this;
        }

        // Appends an array of characters at the end of this string builder. The capacity is adjusted as needed. 
        public StringBuilder AppendCharArrayFromIndex(char[] value, int startIndex, int charCount) {
            // in NetCF arguments pretty much don't matter as long as count is 0
            // we need to check this twice, as this is a contract area and we can't return from here
            if (startIndex < 0) {
                throw new ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_GenericPositive"));
            }
            if (charCount<0) {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_GenericPositive"));
            }
            // in NetCF arguments pretty much don't matter as long as count is 0
            if (CompatibilitySwitches.IsAppEarlierThanWindowsPhone8 && (charCount == 0))
            {
                return this;
            }

            if (value == null) {
                if (startIndex == 0 && charCount == 0) {
                    return this;
                }
                throw ArgumentNullException("value");
            }
            if (charCount > value.length - startIndex) {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }

            if (charCount==0) {
                return this;
            }
			weak char* valueChars = &value[startIndex];
            Append(valueChars, charCount);
            return this;
        }


        // Appends a copy of this string at the end of this string builder.
        public StringBuilder AppendString(string value) {
            ensures(result != null);

            if (value != null) {
                // This is a hand specialization of the 'AppendHelper' code below. 
                // We could have just called AppendHelper.  
                char[] chunkChars = m_ChunkChars;
                int chunkLength = m_ChunkLength;
                int valueLen = value.length;
                int newCurrentIndex = chunkLength + valueLen;
                if (newCurrentIndex < chunkChars.length)    // Use strictly < to avoid issue if count == 0, newIndex == length
                {
                    if (valueLen <= 2)
                    {
                        if (valueLen > 0)
                            chunkChars[chunkLength] = value[0];
                        if (valueLen > 1)
                            chunkChars[chunkLength + 1] = value[1];
                    }
                    else
                    {
                        weak char* valuePtr = value;
                        weak char* destPtr = &chunkChars[chunkLength];
                        string.wstrcpy(destPtr, valuePtr, valueLen);
                    }
                    m_ChunkLength = newCurrentIndex;
                }
                else
                    AppendHelper(value);
            }
            return this;
        }


        // We put this fixed in its own helper to avoid the cost zero initing valueChars in the
        // case we don't actually use it.  
        private void AppendHelper(string value) {
			weak char* valueChars = value;
			Append(valueChars, value.length);
        }

        internal extern void ReplaceBufferInternal(char* newBuffer, int newLength);

        internal extern void ReplaceBufferAnsiInternal(int8* newBuffer, int newLength);

        // Appends a copy of the characters in value from startIndex to startIndex +
        // count at the end of this string builder.
        public StringBuilder Append (string value, int startIndex, int count) {
            // in NetCF arguments pretty much don't matter as long as count is 0
            // we need to check this twice, as this is a contract area and we can't return from here
            if (startIndex < 0) {
                throw new ArgumentOutOfRangeException.INDEX("startIndex");
            }

            if (count < 0) {
                throw new ArgumentOutOfRangeException.GENERIC_POSITIVE("count");
            }

            // in NetCF arguments pretty much don't matter as long as count is 0
            if (CompatibilitySwitches.IsAppEarlierThanWindowsPhone8 && (count == 0)){
                return this;
            }
        
            //If the value being added is null, eat the null
            //and return.
            if (value == null) {
                if (startIndex == 0 && count == 0) {
                    return this;
                }
                throw new ArgumentNullException.VALUE("value");
            }

            if (count == 0) {
                return this;
            }

            if (startIndex > value.length - count) {
                throw new ArgumentOutOfRangeException.INDEX("startIndex");
            }

			weak char* valueChars = value;
			Append(valueChars + startIndex, count);
            return this;
        }

        public StringBuilder AppendLine(string? value)
            ensures(result != null)
		{
            if (value != null) Append(value);
            return Append(Environment.NewLine);
        }


        public void CopyTo(int sourceIndex, char[] destination, int destinationIndex, int count) {

            if (count < 0) {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("Arg_NegativeArgCount"));
            }

            if (destinationIndex < 0) {
                throw new ArgumentOutOfRangeException("destinationIndex",
                    Environment.GetResourcestring("ArgumentOutOfRange_MustBeNonNegNum", "destinationIndex"));
            }

            if (destinationIndex > destination.length - count) {
                throw ArgumentException(Environment.GetResourcestring("ArgumentOutOfRange_OffsetOut"));
            }

            if ((uint)sourceIndex > (uint)Length) {
                throw new ArgumentOutOfRangeException("sourceIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }

            if (sourceIndex > Length - count) {
                throw ArgumentException(Environment.GetResourcestring("Arg_LongerThanSrcstring"));
            }

			
            VerifyClassInvariant();
			StringBuilder chunk = this;
            int sourceEndIndex = sourceIndex + count;
            int curDestIndex = destinationIndex + count;
            while (count > 0)
            {
                int chunkEndIndex = sourceEndIndex - chunk.m_ChunkOffset;
                if (chunkEndIndex >= 0)
                {
                    if (chunkEndIndex > chunk.m_ChunkLength)
                        chunkEndIndex = chunk.m_ChunkLength;

                    int chunkCount = count;
                    int chunkStartIndex = chunkEndIndex - count;
                    if (chunkStartIndex < 0)
                    {
                        chunkCount += chunkStartIndex;
                        chunkStartIndex = 0;
                    }
                    curDestIndex -= chunkCount;
                    count -= chunkCount;

                    // SafeCritical: we ensure that chunkStartIndex + chunkCount are within range of m_chunkChars
                    // as well as ensuring that curDestIndex + chunkCount are within range of destination
                    ThreadSafeCopy(chunk.m_ChunkChars, chunkStartIndex, destination, curDestIndex, chunkCount);
                }
                chunk = chunk.m_ChunkPrevious;
            }
        }

        // Inserts multiple copies of a string into this string builder at the specified position.
        // Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, this
        // string builder is not changed. 
        // 
        public StringBuilder InserWithCount(int index, string value, int count) {
            if (count < 0) {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_NeedNonNegNum"));
            }
            ensures(result != null);
            

            //Range check the index.
            int currentLength = Length;
            if ((uint)index > (uint)currentLength) {
                throw new ArgumentOutOfRangeException("index", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }

            //If value is null, empty or count is 0, do nothing. This is ECMA standard.
            if (value == null || value.length == 0 || count == 0) {
                return this;
            }

            //Ensure we don't insert more chars than we can hold, and we don't 
            //have any integer overflow in our inserted characters.
            long insertingChars = (long) value.length * count;
            if (insertingChars > MaxCapacity - this.Length) {
                throw OutOfMemoryException();
            }
            GLib.assert(insertingChars + this.Length < int32.MAX);
            StringBuilder chunk;
            int indexInChunk;
            MakeRoom(index, (int) insertingChars, out chunk, out indexInChunk, false);
            {
                weak char* valuePtr = value;
                while (count > 0)
				{
					ReplaceInPlaceAtChunk(ref chunk, ref indexInChunk, valuePtr, value.length);
					--count;
				}
            }
            return this;
        }

        // Removes the specified characters from this string builder.
        // The length of this string builder is reduced by 
        // length, but the capacity is unaffected.
        // 
        public StringBuilder Remove(int startIndex, int length)
			requires (length >= 0)
			requires (startIndex >= 0)
			requires (startIndex >= 0)
        {
			
            if (length<0) {
                throw new ArgumentOutOfRangeException("length", Environment.GetResourcestring("ArgumentOutOfRange_NegativeLength"));
            }

            if (startIndex<0) {
                throw new ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_StartIndex"));
            }

            if (length > Length - startIndex) {
                throw new ArgumentOutOfRangeException("index", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }
            ensures(result != null);
            

            if (Length == length && startIndex == 0) {
                // Optimization.  If we are deleting everything  
                Length = 0;
                return this;
            }

            if (length > 0) {
				StringBuilder chunk;
                int indexInChunk;
                Remove(startIndex, length, out chunk, out indexInChunk);
            }
            return this;
        }

        //
        // PUBLIC INSTANCE FUNCTIONS
        //
        //

        /*====================================Append====================================
        **
        ==============================================================================*/
        // Appends a boolean to the end of this string builder.
        // The capacity is adjusted as needed. 
        public StringBuilder AppendBoolean(bool value) {
            ensures(result != null);
            return Append(value.ToString());
        }

        // Appends an int8 to this string builder.
        // The capacity is adjusted as needed. 

        public StringBuilder AppendSbyte(int8 value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends a uuint8 to this string builder.
        // The capacity is adjusted as needed. 
        public StringBuilder AppendByte(uint8 value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends a character at the end of this string builder. The capacity is adjusted as needed.
        public StringBuilder AppendChar(char value) {
            ensures(result != null);

            if (m_ChunkLength < m_ChunkChars.length)
                m_ChunkChars[m_ChunkLength++] = value;
            else
                Append(value, 1);
            return this;
        }

        // Appends a short to this string builder.
        // The capacity is adjusted as needed. 
        public StringBuilder AppendShort(short value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends an int to this string builder.
        // The capacity is adjusted as needed. 
        public StringBuilder AppendInt(int value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends a long to this string builder. 
        // The capacity is adjusted as needed. 
        public StringBuilder AppendLong(long value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends a float to this string builder. 
        // The capacity is adjusted as needed. 
        public StringBuilder AppendFloat(float value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends a double to this string builder. 
        // The capacity is adjusted as needed. 
        public StringBuilder AppendDouble(double value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

		/*
        public StringBuilder AppendDecimal(decimal value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }
        */

        // Appends an ushort to this string builder. 
        // The capacity is adjusted as needed. 

        public StringBuilder AppendUshort(ushort value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends an uint to this string builder. 
        // The capacity is adjusted as needed. 

        public StringBuilder AppendUint(uint value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends an unsigned long to this string builder. 
        // The capacity is adjusted as needed. 

        public StringBuilder AppendUlong(ulong value) {
            ensures(result != null);
            return Append(value.ToString(CultureInfo.CurrentCulture));
        }

        // Appends an Object to this string builder. 
        // The capacity is adjusted as needed. 
        public StringBuilder AppendObject(Object value) {
            ensures(result != null);

            if (null==value) {
                //Appending null is now a no-op.
                return this;
            }
            return Append(value.ToString());
        }

        // Appends all of the characters in value to the current instance.
        public StringBuilder AppendCharArray(char[] value) {
            ensures(result != null);

            if (null != value && value.length > 0)
            {
				weak char* valueChars = &value[0];
				Append(valueChars, value.length);
            }
            return this;
        }

        /*====================================Insert====================================
        ==============================================================================*/

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertString(int index, string value) {
            if ((uint)index > (uint)Length) {
                throw new ArgumentOutOfRangeException("index", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }
            ensures(result != null);
            

            if (value != null)
            {
				weak char* sourcePtr = value;
				Insert(index, sourcePtr, value.length);
            }
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertBoolean(int index, bool value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 

        public StringBuilder InsertSbyte(int index, int8 value)
             ensures(result != null)
		{
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertByte(int index, uint8 value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertShort(int index, short value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.

        public StringBuilder InsertChar(int index, char value)
			ensures(result != null)
        {
            Insert(index, &value, 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertCharArray(int index, char[]? value)
			requires ((uint)index < (uint)Length)
			ensures(result != null)
        {
            if (value != null)
                Insert(index, value, 0, value.length);
            return this;
        }

        // Returns a reference to theStringBuilder with charCount characters from 
        // value inserted into the buffer at index.  Existing characters are shifted
        // to make room for the new text and capacity is adjusted as required.  If value is null, theStringBuilder
        // is unchanged.  Characters are taken from value starting at position startIndex.
        public StringBuilder InsertCharWithCount(int index, char[]? value, int startIndex, int charCount)
			requires ((uint)index < (uint)Length)
			requires (startIndex >= 0)
			requires (charCount >= 0)
			requires (startIndex < value.length - charCount)
            ensures(result != null)
        {
            //If they passed in a null char array, just jump out quickly.
            if (value == null) {
                if (startIndex == 0 && charCount == 0)
                {
                    return this;
                }
                throw new ArgumentNullException.STRING("ArgumentNull_string");
            }

            if (charCount > 0)
            {
				weak char* sourcePtr = &value[startIndex];
				Insert(index, sourcePtr, charCount);
            }
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertInt(int index, int value)
			ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertLong(int index, long value)
			ensures(result != null)
		{
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public StringBuilder InsertFloat(int index, float value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed. 
        // 
        public StringBuilder InsertDouble(int index, double value)
            ensures(result != null)
         {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

		/*
        public StringBuilder InsertDecimal(int index, decimal value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }
        */

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public StringBuilder InsertUshort(int index, ushort value)
            ensures(result != null)
         {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public StringBuilder InsertUint(int index, uint value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public StringBuilder InsertUlong(int index, ulong value)
            ensures(result != null)
        {
            return Insert(index, value.ToString(CultureInfo.CurrentCulture), 1);
        }

        // Returns a reference to this string builder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the
        // new text.  The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed. No changes are made if value is null.
        // 
        public StringBuilder InsertObject(int index, Object value)
            ensures(result != null)
        {
            if (null == value) {
                return this;
            }
            return Insert(index, value.ToString(), 1);
        }

		/*
        public StringBuilder AppendFormat (string format, Object arg0) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0 });
        }

        public StringBuilder AppendFormat (string format, Object arg0, Object arg1) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0, arg1 });
        }

        public StringBuilder AppendFormat (string format, Object arg0, Object arg1, Object arg2) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0, arg1, arg2 });
        }
		*/
        public StringBuilder AppendFormat (string format, params Object[] args)
			ensures (result != null)
        {
            return AppendFormat(null, format, args);
        }

        private static void FormatError() {
            throw new FormatException.INVALID_STRING("Format_Invalidstring");
        }

        public StringBuilder AppendFormatWithProvider(IFormatProvider provider, string format, params Object[] args)
			ensures (result != null) 
        {
            int pos = 0;
            int len = format.length;
            char ch = '\x0';

            ICustomFormatter cf = null;
            if (provider != null) {
                cf = (ICustomFormatter)provider.GetFormat(typeof(ICustomFormatter));
            }

            while (true) {
                int p = pos;
                int i = pos;
                while (pos < len) {
                    ch = format[pos];

                    pos++;
                    if (ch == '}')
                    {
                        if (pos < len && format[pos] == '}') // Treat as escape character for }}
                            pos++;
                        else
                            FormatError();
                    }

                    if (ch == '{')
                    {
                        if (pos < len && format[pos] == '{') // Treat as escape character for {{
                            pos++;
                        else
                        {
                            pos--;
                            break;
                        }
                    }

                    Append(ch);
                }

                if (pos == len) break;
                pos++;
                if (pos == len || (ch = format[pos]) < '0' || ch > '9') FormatError();
                int index = 0;
                do {
                    index = index * 10 + ch - '0';
                    pos++;
                    if (pos == len) FormatError();
                    ch = format[pos];
                } while (ch >= '0' && ch <= '9' && index < 1000000);
                if (index >= args.length) throw FormatException(Environment.GetResourcestring("Format_IndexOutOfRange"));
                while (pos < len && (ch = format[pos]) == ' ') pos++;
                bool leftJustify = false;
                int width = 0;
                if (ch == ',') {
                    pos++;
                    while (pos < len && format[pos] == ' ') pos++;

                    if (pos == len) FormatError();
                    ch = format[pos];
                    if (ch == '-') {
                        leftJustify = true;
                        pos++;
                        if (pos == len) FormatError();
                        ch = format[pos];
                    }
                    if (ch < '0' || ch > '9') FormatError();
                    do {
                        width = width * 10 + ch - '0';
                        pos++;
                        if (pos == len) FormatError();
                        ch = format[pos];
                    } while (ch >= '0' && ch <= '9' && width < 1000000);
                }

                while (pos < len && (ch = format[pos]) == ' ') pos++;
                Object arg = args[index];
                StringBuilder fmt = null;
                if (ch == ':') {
                    pos++;
                    p = pos;
                    i = pos;
                    while (true) {
                        if (pos == len) FormatError();
                        ch = format[pos];
                        pos++;
                        if (ch == '{')
                        {
                            if (pos < len && format[pos] == '{')  // Treat as escape character for {{
                                pos++;
                            else
                                FormatError();
                        }
                        else if (ch == '}')
                        {
                            if (pos < len && format[pos] == '}')  // Treat as escape character for }}
                                pos++;
                            else
                            {
                                pos--;
                                break;
                            }
                        }

                        if (fmt == null) {
                            fmt = newStringBuilder();
                        }
                        fmt.Append(ch);
                    }
                }
                if (ch != '}') FormatError();
                pos++;
                string sFmt = null;
                string s = null;
                if (cf != null) {
                    if (fmt != null) {
                        sFmt = fmt.ToString();
                    }
                    s = cf.Format(sFmt, arg, provider);
                }

                if (s == null) {
                    IFormattable formattableArg = arg as IFormattable;

                    if (formattableArg != null) {
                        if (sFmt == null && fmt != null) {
                            sFmt = fmt.ToString();
                        }

                        s = formattableArg.ToString(sFmt, provider);
                    } else if (arg != null) {
                        s = arg.ToString();
                    }
                }

                if (s == null) s = "";
                int pad = width - s.length;
                if (!leftJustify && pad > 0) Append(' ', pad);
                Append(s);
                if (leftJustify && pad > 0) Append(' ', pad);
            }
            return this;
        }


        public bool Equals(StringBuilder sb) 
        {
            if (sb == null)
                return false;
            if (Capacity != sb.Capacity || MaxCapacity != sb.MaxCapacity || Length != sb.length)
                return false;
            if (sb == this)
                return true;
            StringBuilder thisChunk = this;
            int thisChunkIndex = thisChunk.m_ChunkLength;
            StringBuilder sbChunk = sb;
            int sbChunkIndex = sbChunk.m_ChunkLength;
            for (; ; )
            {
                // Decrement the pointer to the 'thisStringBuilder
                --thisChunkIndex;
                --sbChunkIndex;

                while (thisChunkIndex < 0)
                {
                    thisChunk = thisChunk.m_ChunkPrevious;
                    if (thisChunk == null)
                        break;
                    thisChunkIndex = thisChunk.m_ChunkLength + thisChunkIndex;
                }

                // Decrement the pointer to the 'thisStringBuilder
                while (sbChunkIndex < 0)
                {
                    sbChunk = sbChunk.m_ChunkPrevious;
                    if (sbChunk == null)
                        break;
                    sbChunkIndex = sbChunk.m_ChunkLength + sbChunkIndex;
                }

                if (thisChunkIndex < 0)
                    return sbChunkIndex < 0;
                if (sbChunkIndex < 0)
                    return false;
                if (thisChunk.m_ChunkChars[thisChunkIndex] != sbChunk.m_ChunkChars[sbChunkIndex])
                    return false;
            }
        }

        public StringBuilder ReplaceWithCount(string oldValue, string newValue, int startIndex, int count)
        {
            ensures(result != null);

            int currentLength = Length;
            if ((uint)startIndex > (uint)currentLength)
            {
                throw new ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }
            if (count < 0 || startIndex > currentLength - count)
            {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }
            if (oldValue == null)
            {
                throw ArgumentNullException("oldValue");
            }
            if (oldValue.length == 0)
            {
                throw ArgumentException(Environment.GetResourcestring("Argument_EmptyName"), "oldValue");
            }

            if (newValue == null)
                newValue = "";

            int deltaLength = newValue.length - oldValue.length;

            int[] replacements = null;          // A list of replacement positions in a chunk to apply
            int replacementsCount = 0;

            // Find the chunk, indexInChunk for the starting pointStringBuilder chunk = FindChunkForIndex(startIndex);
            int indexInChunk = startIndex - chunk.m_ChunkOffset;
            while (count > 0)
            {
                // Look for a match in the chunk,indexInChunk pointer 
                if (StartsWith(chunk, indexInChunk, count, oldValue))
                {
                    // Push it on my replacements array (with growth), we will do all replacements in a
                    // given chunk in one operation below (see ReplaceAllInChunk) so we don't have to slide
                    // many times.  
                    if (replacements == null)
                        replacements = new int[5];
                    else if (replacementsCount >= replacements.length)
                    {
                        int[] newArray = new int[replacements.length * 3 / 2 + 4];     // grow by 1.5X but more in the begining
                        Array.Copy(replacements, newArray, replacements.length);
                        replacements = newArray;
                    }
                    replacements[replacementsCount++] = indexInChunk;
                    indexInChunk += oldValue.length;
                    count -= oldValue.length;
                }
                else
                {
                    indexInChunk++;
                    --count;
                }

                if (indexInChunk >= chunk.m_ChunkLength || count == 0)       // Have we moved out of the current chunk
                {
                    // Replacing mutates the blocks, so we need to convert to logical index and back afterward. 
                    int index = indexInChunk + chunk.m_ChunkOffset;
                    int indexBeforeAdjustment = index;

                    // See if we accumulated any replacements, if so apply them 
                    ReplaceAllInChunk(replacements, replacementsCount, chunk, oldValue.length, newValue);
                    // The replacement has affected the logical index.  Adjust it.  
                    index += ((newValue.length - oldValue.length) * replacementsCount);
                    replacementsCount = 0;

                    chunk = FindChunkForIndex(index);
                    indexInChunk = index - chunk.m_ChunkOffset;
                    GLib.assert(chunk != null || count == 0, "Chunks ended prematurely");
                }
            }
            VerifyClassInvariant();
            return this;
        }

        // Returns aStringBuilder with all instances of oldChar replaced with 
        // newChar.  The size of theStringBuilder is unchanged because we're only
        // replacing characters.  If startIndex and count are specified, we 
        // only replace characters in the range from startIndex to startIndex+count
        //
        public StringBuilder Replace(char oldChar, char newChar, int startIndex = 0, int count = Length) {
            ensures(result != null);

            int currentLength = Length;
            if ((uint)startIndex > (uint)currentLength) {
                throw new ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }

            if (count < 0 || startIndex > currentLength - count) {
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            }

            int endIndex = startIndex + count;
            StringBuilder chunk = this;
            for (; ; )
            {
                int endIndexInChunk = endIndex - chunk.m_ChunkOffset;
                int startIndexInChunk = startIndex - chunk.m_ChunkOffset;
                if (endIndexInChunk >= 0)
                {
                    int curInChunk = Math.Max(startIndexInChunk, 0);
                    int endInChunk = Math.Min(chunk.m_ChunkLength, endIndexInChunk);
                    while (curInChunk < endInChunk)
                    {
                        if (chunk.m_ChunkChars[curInChunk] == oldChar)
                            chunk.m_ChunkChars[curInChunk] = newChar;
                        curInChunk++;
                    }
                }
                if (startIndexInChunk >= 0)
                    break;
                chunk = chunk.m_ChunkPrevious;
            }
            return this;
        }

        /// <summary>
        /// Appends 'value' of length 'count' to the StringBuilder. 
        /// </summary>

        internal StringBuilder AppendValue(char* value, int valueCount)
        {
            // This case is so common we want to optimize for it heavily. 
            int newIndex = valueCount + m_ChunkLength;
            if (newIndex <= m_ChunkChars.length)
            {
                ThreadSafeCopy(value, m_ChunkChars, m_ChunkLength, valueCount);
                m_ChunkLength = newIndex;
            }
            else
            {
                // Copy the first chunk
                int firstLength = m_ChunkChars.length - m_ChunkLength;
                if (firstLength > 0)
                {
                    ThreadSafeCopy(value, m_ChunkChars, m_ChunkLength, firstLength);
                    m_ChunkLength = m_ChunkChars.length;
                }

                // Expand the builder to add another chunk. 
                int restLength = valueCount - firstLength;
                ExpandByABlock(restLength);
                GLib.assert(m_ChunkLength == 0, "Expand did not make a new block");

                // Copy the second chunk
                ThreadSafeCopy(value + firstLength, m_ChunkChars, 0, restLength);
                m_ChunkLength = restLength;
            }
            VerifyClassInvariant();
            return this;
        }

        /// <summary>
        /// Inserts 'value' of length 'cou
        /// </summary>

        private void Insert(int index, char* value, int valueCount)
			requires ((uint)index < (uint)Length)
        {
            if (valueCount > 0) {
				StringBuilder chunk;
                int indexInChunk;
                MakeRoom(index, valueCount, out chunk, out indexInChunk, false);
                ReplaceInPlaceAtChunk(ref chunk, ref indexInChunk, value, valueCount);
            }
        }

        /// <summary>
        /// 'replacements' is a list of index (relative to the begining of the 'chunk' to remove
        /// 'removeCount' characters and replace them with 'value'.   This routine does all those 
        /// replacements in bulk (and therefore very efficiently. 
        /// with the string 'value'.  
        /// </summary>
        private void ReplaceAllInChunk(int[] replacements, int replacementsCount, StringBuilder sourceChunk, int removeCount, string value)
        {
            if (replacementsCount <= 0)
                return;

            weak char* valuePtr = value;
			// calculate the total amount of extra space or space needed for all the replacements.  
			int delta = (value.length - removeCount) * replacementsCount;
			StringBuilder targetChunk = sourceChunk;        // the target as we copy chars down
			int targetIndexInChunk = replacements[0];

			// Make the room needed for all the new characters if needed. 
			if (delta > 0)
				MakeRoom(targetChunk.m_ChunkOffset + targetIndexInChunk, delta, out targetChunk, out targetIndexInChunk, true);
			// We made certain that characters after the insertion point are not moved, 
			int i = 0;
			for (; ; )
			{
				// Copy in the new string for the ith replacement
				ReplaceInPlaceAtChunk(ref targetChunk, ref targetIndexInChunk, valuePtr, value.length);
				int gapStart = replacements[i] + removeCount;
				i++;
				if (i >= replacementsCount)
					break;

				int gapEnd = replacements[i];
				GLib.assert(gapStart < sourceChunk.m_ChunkChars.length, "gap starts at end of buffer.  Should not happen");
				GLib.assert(gapStart <= gapEnd, "negative gap size");
				GLib.assert(gapEnd <= sourceChunk.m_ChunkLength, "gap too big");
				if (delta != 0)     // can skip the sliding of gaps if source an target string are the same size.  
				{
					// Copy the gap data between the current replacement and the the next replacement
					weak char* sourcePtr = &sourceChunk.m_ChunkChars[gapStart];
					ReplaceInPlaceAtChunk(ref targetChunk, ref targetIndexInChunk, sourcePtr, gapEnd - gapStart);
				}
				else
				{
					targetIndexInChunk += gapEnd - gapStart;
					GLib.assert(targetIndexInChunk <= targetChunk.m_ChunkLength, "gap not in chunk");
				}
			}

			// Remove extra space if necessary. 
			if (delta < 0)
				Remove(targetChunk.m_ChunkOffset + targetIndexInChunk, -delta, out targetChunk, out targetIndexInChunk);
        }

        /// <summary>
        /// Returns true if the string that is starts at 'chunk' and 'indexInChunk, and has a logical
        /// length of 'count' starts with the string 'value'. 
        /// </summary>
        private bool StartsWith (StringBuilder chunk, int indexInChunk, int count, string value)
        {
            for (int i = 0; i < value.length; i++)
            {
                if (count == 0)
                    return false;
                if (indexInChunk >= chunk.m_ChunkLength)
                {
                    chunk = Next(chunk);
                    if (chunk == null)
                        return false;
                    indexInChunk = 0;
                }

                // See if there no match, break out of the inner for loop
                if (value[i] != chunk.m_ChunkChars[indexInChunk])
                    return false;

                indexInChunk++;
                --count;
            }
            return true;
        }

        /// <summary>
        /// ReplaceInPlaceAtChunk is the logical equivalent of 'memcpy'.  Given a chunk and ann index in
        /// that chunk, it copies in 'count' characters from 'value' and updates 'chunk, and indexInChunk to 
        /// point at the end of the characters just copyied (thus you can splice in strings from multiple 
        /// places by calling this mulitple times.  
        /// </summary>

        private void ReplaceInPlaceAtChunk(ref StringBuilder chunk, ref int indexInChunk, char* value, int count)
        {
            if (count != 0)
            {
                for (; ; )
                {
                    int lengthInChunk = chunk.m_ChunkLength - indexInChunk;
                    GLib.assert(lengthInChunk >= 0, "index not in chunk");

                    int lengthToCopy = Math.Min(lengthInChunk, count);
                    ThreadSafeCopy(value, chunk.m_ChunkChars, indexInChunk, lengthToCopy);

                    // Advance the index. 
                    indexInChunk += lengthToCopy;
                    if (indexInChunk >= chunk.m_ChunkLength)
                    {
                        chunk = Next(chunk);
                        indexInChunk = 0;
                    }
                    count -= lengthToCopy;
                    if (count == 0)
                        break;
                    value += lengthToCopy;
                }
            }
        }

        /// <summary>
        /// We have to prevent hackers from causing modification off the end of an array.
        /// The only way to do this is to copy all interesting variables out of the heap and then do the
        /// bounds check.  This is what we do here.   
        /// </summary>

        private static void ThreadSafeCopy(char* sourcePtr, char[] destination, int destinationIndex, int count)
        {
            if (count > 0)
            {
                if ((uint)destinationIndex <= (uint)destination.length && (destinationIndex + count) <= destination.length)
                {
                    weak char* destinationPtr = &destination[destinationIndex];
					string.wstrcpy(destinationPtr, sourcePtr, count);
                }
                else
                {
                    throw new ArgumentOutOfRangeException.INDEX("destinationIndex");
                }
            }
        }

        private static void ThreadSafeCopyArray(char[] source, int sourceIndex, char[] destination, int destinationIndex, int count)
        {
            if (count > 0)
            {
                if ((uint)sourceIndex <= (uint)source.length && (sourceIndex + count) <= source.length)
                {
                   weak char* sourcePtr = &source[sourceIndex];
                   ThreadSafeCopy(sourcePtr, destination, destinationIndex, count);
                }
                else
                {
                    throw new ArgumentOutOfRangeException("sourceIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
                }
            }
        }

         // Copies the sourceStringBuilder to the destination IntPtr memory allocated with len uint8s.
         
        internal void InternalCopy(void * dest, int len) {
            if(len ==0)
                return;

            bool isLastChunk = true;
            uint8* dstPtr = (uint8*) dest.ToPointer;
            StringBuilder currentSrc = FindChunkForByte(len);

            do {
                int chunkOffsetInBytes = currentSrc.m_ChunkOffset*sizeof(char);
                int chunkLengthInBytes = currentSrc.m_ChunkLength*sizeof(char);
                weak char* charPtr = &currentSrc.m_ChunkChars[0];
				uint8* srcPtr = (uint8*) charPtr;
				if(isLastChunk) {
					isLastChunk= false;
					Buffer.Memcpy(dstPtr + chunkOffsetInBytes, srcPtr, len - chunkOffsetInBytes);
				} else {
					Buffer.Memcpy(dstPtr + chunkOffsetInBytes, srcPtr, chunkLengthInBytes);
				}
                currentSrc = currentSrc.m_ChunkPrevious;
            } while(currentSrc != null);
        }
 

        /// <summary>
        /// Finds the chunk for the logical index (number of characters in the whole StringBuilder) 'index'
        /// YOu can then get the offset in this chunk by subtracting the m_BlockOffset field from 'index' 
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private StringBuilder FindChunkForIndex(int index)
        {
            GLib.assert(0 <= index && index <= Length);
            StringBuilder ret = this;
            while (ret.m_ChunkOffset > index)
                ret = ret.m_ChunkPrevious;

            GLib.assert(ret != null);
            return ret;
        }

        /// <summary>
        /// Finds the chunk for the logical uint8 index 'uint8Index'
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private StringBuilder FindChunkForByte(int uint8Index)
        {
            GLib.assert(0 <= uint8Index && uint8Index <= Length*sizeof(char));
            StringBuilder ret = this;
            while (ret.m_ChunkOffset*sizeof(char) > uint8Index)
                ret = ret.m_ChunkPrevious;

            GLib.assert(ret != null);
            return ret;
        }

        /// <summary>
        /// Finds the chunk that logically follows the 'chunk' chunk.  Chunks only persist the pointer to 
        /// the chunk that is logically before it, so this routine has to start at the this pointer (which 
        /// is a assumed to point at the chunk representing the whole StringBuilder) and search
        /// until it finds the current chunk (thus is O(n)).  So it is more expensive than a field fetch!
        /// </summary>
        private StringBuilder Next (StringBuilder chunk)
        {
            if (chunk == this)
                return null;
            return FindChunkForIndex(chunk.m_ChunkOffset + chunk.m_ChunkLength);
        }

        /// <summary>
        /// Assumes that 'this' is the last chunk in the list and that it is full.  Upon return the 'this'
        /// block is updated so that it is a new block that has at least 'minBlockCharCount' characters.
        /// that can be used to copy characters into it.   
        /// </summary>
        private void ExpandByABlock(int minBlockCharCount)
        {
            Contract.Requires(Capacity == Length, "Expand expect to be called only when there is no space left");        // We are currently full
            Contract.Requires(minBlockCharCount > 0, "Expansion request must be positive");

            VerifyClassInvariant();

            if ((minBlockCharCount + Length) > m_MaxCapacity)
                throw new ArgumentOutOfRangeException("requiredLength", Environment.GetResourcestring("ArgumentOutOfRange_SmallCapacity"));

            // Compute the length of the new block we need 
            // We make the new chunk at least big enough for the current need (minBlockCharCount)
            // But also as big as the current length (thus doubling capacity), up to a maximum
            // (so we stay in the small Object heap, and never allocate really big chunks even if
            // the string gets really big. 
            int newBlockLength = Math.Max(minBlockCharCount, Math.Min(Length, MaxChunkSize));

            // Copy the current block to the new block, and initialize this to point at the new buffer. 
            m_ChunkPrevious = newStringBuilder(this);
            m_ChunkOffset += m_ChunkLength;
            m_ChunkLength = 0;

            // Check for integer overflow (logical buffer size > int.MaxInt)
            if (m_ChunkOffset + newBlockLength < newBlockLength)
            {
                m_ChunkChars = null;
                throw OutOfMemoryException();
            }
            m_ChunkChars = new char[newBlockLength];

            VerifyClassInvariant();
        }

        /// <summary>
        /// Used by ExpandByABlock to create a new chunk.  The new chunk is a copied from 'from'
        /// In particular the buffer is shared.  It is expected that 'from' chunk (which represents
        /// the whole list, is then updated to point to point to this new chunk. 
        /// </summary>
        private StringBuilder.From  (StringBuilder from)
        {
            m_ChunkLength = from.m_ChunkLength;
            m_ChunkOffset = from.m_ChunkOffset;
            m_ChunkChars = from.m_ChunkChars;
            m_ChunkPrevious = from.m_ChunkPrevious;
            m_MaxCapacity = from.m_MaxCapacity;
            VerifyClassInvariant();
        }

        /// <summary>
        /// Creates a gap of size 'count' at the logical offset (count of characters in the whole string
        /// builder) 'index'.  It returns the 'chunk' and 'indexInChunk' which represents a pointer to
        /// this gap that was just created.  You can then use 'ReplaceInPlaceAtChunk' to fill in the
        /// chunk
        ///
        /// ReplaceAllChunks relies on the fact that indexes above 'index' are NOT moved outside 'chunk'
        /// by this process (because we make the space by creating the cap BEFORE the chunk).  If we
        /// change this ReplaceAllChunks needs to be updated. 
        ///
        /// If dontMoveFollowingChars is true, then the room must be made by inserting a chunk BEFORE the
        /// current chunk (this is what it does most of the time anyway)
        /// </summary>
        private void MakeRoom(int index, int count, out StringBuilder chunk, out int indexInChunk, bool doneMoveFollowingChars)
        {
            VerifyClassInvariant();
            GLib.assert(count > 0, "Count must be strictly positive");
            GLib.assert(index >= 0, "Index can't be negative");
            if (count + Length > m_MaxCapacity)
                throw new ArgumentOutOfRangeException("requiredLength", Environment.GetResourcestring("ArgumentOutOfRange_SmallCapacity"));

            chunk = this;
            while (chunk.m_ChunkOffset > index)
            {
                chunk.m_ChunkOffset += count;
                chunk = chunk.m_ChunkPrevious;
            }
            indexInChunk = index - chunk.m_ChunkOffset;

            // Cool, we have some space in this block, and you don't have to copy much to get it, go ahead
            // and use it.  This happens typically  when you repeatedly insert small strings at a spot
            // (typically the absolute front) of the buffer.    
            if (!doneMoveFollowingChars && chunk.m_ChunkLength <= DefaultCapacity * 2 && chunk.m_ChunkChars.length - chunk.m_ChunkLength >= count)
            {
                for (int i = chunk.m_ChunkLength; i > indexInChunk; )
                {
                    --i;
                    chunk.m_ChunkChars[i + count] = chunk.m_ChunkChars[i];
                }
                chunk.m_ChunkLength += count;
                return;
            }

            // Allocate space for the new chunk (will go before this oneStringBuilder newChunk = newStringBuilder(Math.Max(count, DefaultCapacity), chunk.m_MaxCapacity, chunk.m_ChunkPrevious);
            newChunk.m_ChunkLength = count;

            // Copy the head of the buffer to the  new buffer. 
            int copyCount1 = Math.Min(count, indexInChunk);
            if (copyCount1 > 0)
            {
				weak char* chunkCharsPtr = chunk.m_ChunkChars;
				ThreadSafeCopy(chunkCharsPtr, newChunk.m_ChunkChars, 0, copyCount1);

				// Slide characters in the current buffer over to make room. 
				int copyCount2 = indexInChunk - copyCount1;
				if (copyCount2 >= 0)
				{
					ThreadSafeCopy(chunkCharsPtr + copyCount1, chunk.m_ChunkChars, 0, copyCount2);
					indexInChunk = copyCount2;
				}
            }

            chunk.m_ChunkPrevious = newChunk; // Wire in the new chunk
            chunk.m_ChunkOffset += count;
            if (copyCount1 < count)
            {
                chunk = newChunk;
                indexInChunk = copyCount1;
            }

            VerifyClassInvariant();
        }

        /// <summary>
        ///  Used by MakeRoom to allocate another chunk.  
        /// </summary>
        private StringBuilder.WithPreviousBlock(int size, int maxCapacity, StringBuilder previousBlock)
        {
            GLib.assert(size > 0, "size not positive");
            GLib.assert(maxCapacity > 0, "maxCapacity not positive");
            m_ChunkChars = char[size];
            m_MaxCapacity = maxCapacity;
            m_ChunkPrevious = previousBlock;
            if (previousBlock != null)
                m_ChunkOffset = previousBlock.m_ChunkOffset + previousBlock.m_ChunkLength;
            VerifyClassInvariant();
        }

        /// <summary>
        /// Removes 'count' characters from the logical index 'startIndex' and returns the chunk and 
        /// index in the chunk of that logical index in the out parameters.  
        /// </summary>

        private void RemoveChunk(int startIndex, int count, out StringBuilder chunk, out int indexInChunk)
        {
            VerifyClassInvariant();
            GLib.assert(startIndex >= 0 && startIndex < Length, "startIndex not in string");

            int endIndex = startIndex + count;

            // Find the chunks for the start and end of the block to delete. 
            chunk = this;
            StringBuilder endChunk = null;
            int endIndexInChunk = 0;
            for (; ; )
            {
                if (endIndex - chunk.m_ChunkOffset >= 0)
                {
                    if (endChunk == null)
                    {
                        endChunk = chunk;
                        endIndexInChunk = endIndex - endChunk.m_ChunkOffset;
                    }
                    if (startIndex - chunk.m_ChunkOffset >= 0)
                    {
                        indexInChunk = startIndex - chunk.m_ChunkOffset;
                        break;
                    }
                }
                else
                {
                    chunk.m_ChunkOffset -= count;
                }
                chunk = chunk.m_ChunkPrevious;
            }
            GLib.assert(chunk != null, "fell off beginning of string!");

            int copyTargetIndexInChunk = indexInChunk;
            int copyCount = endChunk.m_ChunkLength - endIndexInChunk;
            if (endChunk != chunk)
            {
                copyTargetIndexInChunk = 0;
                // Remove the characters after startIndex to end of the chunk
                chunk.m_ChunkLength = indexInChunk;

                // Remove the characters in chunks between start and end chunk
                endChunk.m_ChunkPrevious = chunk;
                endChunk.m_ChunkOffset = chunk.m_ChunkOffset + chunk.m_ChunkLength;

                // If the start is 0 then we can throw away the whole start chunk
                if (indexInChunk == 0)
                {
                    endChunk.m_ChunkPrevious = chunk.m_ChunkPrevious;
                    chunk = endChunk;
                }
            }
            endChunk.m_ChunkLength -= (endIndexInChunk - copyTargetIndexInChunk);

            // SafeCritical: We ensure that endIndexInChunk + copyCount is within range of m_ChunkChars and
            // also ensure that copyTargetIndexInChunk + copyCount is within the chunk
            //
            // Remove any characters in the end chunk, by sliding the characters down. 
            if (copyTargetIndexInChunk != endIndexInChunk)  // Sometimes no move is necessary
                ThreadSafeCopy(endChunk.m_ChunkChars, endIndexInChunk, endChunk.m_ChunkChars, copyTargetIndexInChunk, copyCount);

            GLib.assert(chunk != null);
            VerifyClassInvariant();
        }
    }
}
