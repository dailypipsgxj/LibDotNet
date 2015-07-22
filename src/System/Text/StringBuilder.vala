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


    public class StringBuilder : GLib.StringBuilder {

        public StringBuilder (string? value = "")
			//requires (startIndex >= 0)
			//requires (startIndex < length)
		{
            //size_t m_MaxCapacity = int32.MAX;
            base(value);
            
        }

        public int Capacity {
            get { return (int)allocated_len; }
            set {
            }
        }

        public int MaxCapacity {
            get { return int32.MAX; }
        }

        // Read-Only Property 
        // Ensures that the capacity of this string builder is at least the specified value.  
        // If capacity is greater than the capacity of this string builder, then the capacity
        // is set to capacity; otherwise the capacity is unchanged.
        // 
        public int EnsureCapacity(int capacity = 16)
			requires (capacity >= 0)
        {
            if (Capacity < capacity)
                Capacity = capacity;
            return Capacity;
        }

        // Converts a substring of this string builder to astring.

        public string ToString(int startIndex = 0, int length = -1)
			requires (startIndex < this.Length)
			requires (startIndex >= 0)
            ensures(result != null)
        {
            return str.substring(startIndex, length);
        }

        // Convenience method for sb.length=0;
        public unowned StringBuilder Clear() {
            erase();
            this.Length = 0;
            return this;
        }

        // Sets the length of thestring in this buffer.  If length is less than the current
        // instance, theStringBuilder is truncated.  If length is greater than the current 
        // instance, nulls are appended.  The capacity is adjusted to be the same as the length.

        public int Length {
            get {
                return str.length;
            }
            set {
                //If the new length is less than 0 or greater than our Maximum capacity, bail.
                if (value<0) {
                    throw new ArgumentOutOfRangeException.NEGATIVE_LENGTH("value");
                }

                if (value>int32.MAX) {
                    throw new ArgumentOutOfRangeException.SMALL_CAPACITY("value");
                }

				if (value < str.length) {
					truncate(str.length - value);
				} else {
					append(string.nfill(value - str.length, (char)null));
				}
            }
        }

        public char get (int index) {
			return (char)data[index];
		}
            
		public void set (int index, string value){
			insert(index, value);
        }

        // Appends a character at the end of this string builder. The capacity is adjusted as needed.
        public unowned StringBuilder AppendCopies(char value, int repeatCount)
            ensures(result != null)
            ensures(repeatCount>=0)
        {
            if (repeatCount==0) return this;
            append(string.nfill(repeatCount, value));
            return this;
        }

        // Appends an array of characters at the end of this string builder. The capacity is adjusted as needed. 
        public unowned StringBuilder AppendCharArrayFromIndex(char[] value, int startIndex, int charCount) {
            return this;
        }


        // Appends a copy of this string at the end of this string builder.
        public unowned StringBuilder AppendString(string value)
            ensures(result != null)
        {
			append(value);
			return this;
        }

        // Appends a copy of the characters in value from startIndex to startIndex +
        // count at the end of this string builder.
        public unowned StringBuilder Append (string value, int startIndex = 0, int count = -1) {
			append(value.substring(startIndex, count));
			return this;
        }

        public unowned StringBuilder AppendLine(string? value = null)
            ensures(result != null)
		{
            if (value != null) Append(value);
            //return Append(Environment.NewLine);
            return Append("\n");
        }


        public void CopyTo(int sourceIndex, char[] destination, int destinationIndex = 0, int count = -1)
			requires(destinationIndex >= 0)
			requires(count < destination.length - destinationIndex)
        {
			

        }

        // Inserts multiple copies of a string into this string builder at the specified position.
        // Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, this
        // string builder is not changed. 
        // 
        public unowned StringBuilder InserWithCount(int index, string value, int count) {
            if (count < 0) {
                throw new ArgumentOutOfRangeException.NEED_NON_NEG_NUM("count");
            }
            return this;
        }

        // Removes the specified characters from this string builder.
        // The length of this string builder is reduced by 
        // length, but the capacity is unaffected.
        // 
        public unowned StringBuilder Remove(int startIndex, int length)
			requires (length >= 0)
			requires (startIndex >= 0)
			requires (startIndex >= 0)
        {
			erase(startIndex, length);
			return this;
        }

        // PUBLIC INSTANCE FUNCTIONS

        /*====================================Append====================================*/
        // Appends a boolean to the end of this string builder.
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendBoolean(bool value)
            ensures(result != null)
         {
            return Append(value.to_string());
        }

        // Appends an int8 to this string builder.
        // The capacity is adjusted as needed. 

        public unowned StringBuilder AppendSbyte(int8 value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends a uuint8 to this string builder.
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendByte(uint8 value)
            ensures(result != null)
         {
            return Append(value.to_string());
        }

        // Appends a character at the end of this string builder. The capacity is adjusted as needed.
        public unowned StringBuilder AppendChar(char value) {
            return this;
        }

        // Appends a short to this string builder.
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendShort(short value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends an int to this string builder.
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendInt(int value)
			ensures(result != null)
        {
            
            return Append(value.to_string());
        }

        // Appends a long to this string builder. 
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendLong(long value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends a float to this string builder. 
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendFloat(float value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends a double to this string builder. 
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendDouble(double value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

		/*
        public unowned StringBuilder AppendDecimal(decimal value) {
            ensures(result != null);
            return Append(value.to_string());
        }
        */

        // Appends an ushort to this string builder. 
        // The capacity is adjusted as needed. 

        public unowned StringBuilder AppendUshort(ushort value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends an uint to this string builder. 
        // The capacity is adjusted as needed. 

        public unowned StringBuilder AppendUint(uint value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends an unsigned long to this string builder. 
        // The capacity is adjusted as needed. 

        public unowned StringBuilder AppendUlong(ulong value)
            ensures(result != null)
        {
            return Append(value.to_string());
        }

        // Appends an Object to this string builder. 
        // The capacity is adjusted as needed. 
        public unowned StringBuilder AppendObject(Object value)
            ensures(result != null)
        {
            if (null==value) {
                //Appending null is now a no-op.
                return this;
            }
            return this; //Append(value.ToString());
        }

        // Appends all of the characters in value to the current instance.
        public unowned StringBuilder AppendCharArray(char[] value)
            ensures(result != null)
        {
            if (null != value && value.length > 0)
            {
				weak char* valueChars = &value[0];
				Append(valueChars->to_string(), value.length);
            }
            return this;
        }

        /*====================================Insert====================================
        ==============================================================================*/

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder Insert(int index, string value, int valueCount = 1)
			requires ((uint)index < (uint)Length)
            ensures(result != null)
         {
            if (value != null)
            {
				//weak char* sourcePtr = value;
				insert(index, value);
				//Insert(index, sourcePtr, value.length);
            }
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertBoolean(int index, bool value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 

        public unowned StringBuilder InsertSbyte(int index, int8 value)
             ensures(result != null)
		{
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertByte(int index, uint8 value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertShort(int index, short value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.

        public unowned StringBuilder InsertChar(int index, char value)
			ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertCharArray(int index, char[]? value)
			requires ((uint)index < (uint)Length)
			ensures(result != null)
        {
            if (value != null)
				foreach(var chr in value)
					Insert(index++, chr.to_string(), value.length);
            return this;
        }

        // Returns a reference to theStringBuilder with charCount characters from 
        // value inserted into the buffer at index.  Existing characters are shifted
        // to make room for the new text and capacity is adjusted as required.  If value is null, theStringBuilder
        // is unchanged.  Characters are taken from value starting at position startIndex.
        public unowned StringBuilder InsertCharWithCount(int index, char[]? value, int startIndex, int charCount)
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
				Insert(index, sourcePtr->to_string(), charCount);
            }
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertInt(int index, int value)
			ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertLong(int index, long value)
			ensures(result != null)
		{
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed.
        // 
        public unowned StringBuilder InsertFloat(int index, float value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with ; value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed. 
        // 
        public unowned StringBuilder InsertDouble(int index, double value)
            ensures(result != null)
         {
            Insert(index, value.to_string(), 1);
            return this;
        }

		/*
        public unowned StringBuilder InsertDecimal(int index, decimal value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
        return this;
}        
        */

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public unowned StringBuilder InsertUshort(int index, ushort value)
            ensures(result != null)
         {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public unowned StringBuilder InsertUint(int index, uint value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
            return this;
        }

        // Returns a reference to theStringBuilder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the new text.
        // The capacity is adjusted as needed. 
        // 

        public unowned StringBuilder InsertUlong(int index, ulong value)
            ensures(result != null)
        {
            Insert(index, value.to_string(), 1);
			return this;
		}        

        // Returns a reference to this string builder with value inserted into 
        // the buffer at index. Existing characters are shifted to make room for the
        // new text.  The capacity is adjusted as needed. If value equalsstring.Empty, theStringBuilder is not changed. No changes are made if value is null.
        // 
        public unowned StringBuilder InsertObject(int index, Object value)
            ensures(result != null)
        {
            if (null == value) {
                return this;
            }
            //Insert(index, value.to_string(), 1);
			return this;
		}        

		/*
        public unowned StringBuilder AppendFormat (string format, Object arg0) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0 });
        }

        public unowned StringBuilder AppendFormat (string format, Object arg0, Object arg1) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0, arg1 });
        }

        public unowned StringBuilder AppendFormat (string format, Object arg0, Object arg1, Object arg2) {
            ensures(result != null);
            return AppendFormat(null, format, new Object[] { arg0, arg1, arg2 });
        }
		*/
        public unowned StringBuilder AppendFormat (string format, params Object[] args)
			ensures (result != null)
        {
            return this; //AppendFormat((string)null, format, args);
        }

        private static void FormatError() {
            //throw new FormatException.INVALID_STRING("Format_Invalidstring");
        }

        public unowned StringBuilder AppendFormatWithProvider(IFormatProvider provider, string format, params Object[] args)
			ensures (result != null) 
        {/*
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
                        sFmt = fmt.to_string();
                    }
                    s = cf.Format(sFmt, arg, provider);
                }

                if (s == null) {
                    IFormattable formattableArg = arg as IFormattable;

                    if (formattableArg != null) {
                        if (sFmt == null && fmt != null) {
                            sFmt = fmt.to_string();
                        }

                        s = formattableArg.to_string(sFmt, provider);
                    } else if (arg != null) {
                        s = arg.to_string();
                    }
                }

                if (s == null) s = "";
                int pad = width - s.length;
                if (!leftJustify && pad > 0) Append(' ', pad);
                Append(s);
                if (leftJustify && pad > 0) Append(' ', pad);
            }*/
            return this;
        }


        public bool Equals(StringBuilder sb) 
        {
            if (sb == null)
                return false;
            if (Capacity != sb.Capacity || MaxCapacity != sb.MaxCapacity || Length != sb.str.length)
                return false;
            if (sb == this)
                return true;
            if (sb.str == this.str)
				return true;
			return false;
        }

        public unowned StringBuilder Replace(string oldValue, string newValue, int startIndex = 0, int count = -1)
            ensures(result != null)
        {
			string newstring = str.substring(startIndex, count).replace(oldValue, newValue);
			overwrite(0,newstring);
			truncate(newstring.length);
            return this;
        }

        // Returns aStringBuilder with all instances of oldChar replaced with 
        // newChar.  The size of theStringBuilder is unchanged because we're only
        // replacing characters.  If startIndex and count are specified, we 
        // only replace characters in the range from startIndex to startIndex+count
        //
        public unowned StringBuilder ReplaceChar(char oldChar, char newChar, int startIndex = 0, int count = Length)
            ensures(result != null)
         {
            return this;
        }

        /// <summary>
        /// Appends 'value' of length 'count' to the StringBuilder. 
        /// </summary>

        internal unowned StringBuilder AppendValue(char* value, int valueCount)
        {
            return this;
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

        }

        /// <summary>
        /// Returns true if the string that is starts at 'chunk' and 'indexInChunk, and has a logical
        /// length of 'count' starts with the string 'value'. 
        /// </summary>
        private bool StartsWith (StringBuilder chunk, int indexInChunk, int count, string value)
        {
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
        }

        /// <summary>
        /// We have to prevent hackers from causing modification off the end of an array.
        /// The only way to do this is to copy all interesting variables out of the heap and then do the
        /// bounds check.  This is what we do here.   
        /// </summary>

        private static void ThreadSafeCopy(char* sourcePtr, char[] destination, int destinationIndex, int count)
        {
        }

        private static void ThreadSafeCopyArray(char[] source, int sourceIndex, char[] destination, int destinationIndex, int count)
        {
        }

         // Copies the sourceStringBuilder to the destination IntPtr memory allocated with len uint8s.
         
        internal void InternalCopy(void * dest, int len) {
        }
 

        /// <summary>
        /// Finds the chunk for the logical index (number of characters in the whole StringBuilder) 'index'
        /// YOu can then get the offset in this chunk by subtracting the m_BlockOffset field from 'index' 
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private unowned StringBuilder FindChunkForIndex(int index)
        {
            return this;
        }

        /// <summary>
        /// Finds the chunk for the logical uint8 index 'uint8Index'
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private unowned StringBuilder FindChunkForByte(int uint8Index)
        {
            GLib.assert(0 <= uint8Index && uint8Index <= Length*sizeof(char));
            return this;
        }

        /// <summary>
        /// Finds the chunk that logically follows the 'chunk' chunk.  Chunks only persist the pointer to 
        /// the chunk that is logically before it, so this routine has to start at the this pointer (which 
        /// is a assumed to point at the chunk representing the whole StringBuilder) and search
        /// until it finds the current chunk (thus is O(n)).  So it is more expensive than a field fetch!
        /// </summary>
        private unowned StringBuilder Next (StringBuilder chunk)
        {
			return this;
        }

        /// <summary>
        /// Assumes that 'this' is the last chunk in the list and that it is full.  Upon return the 'this'
        /// block is updated so that it is a new block that has at least 'minBlockCharCount' characters.
        /// that can be used to copy characters into it.   
        /// </summary>
        private void ExpandByABlock(int minBlockCharCount)
        {
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
        }

        /// <summary>
        /// Removes 'count' characters from the logical index 'startIndex' and returns the chunk and 
        /// index in the chunk of that logical index in the out parameters.  
        /// </summary>

        private void RemoveChunk(int startIndex, int count, out StringBuilder chunk, out int indexInChunk)
        {
        }
    }
}
