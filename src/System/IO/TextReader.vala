// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  TextReader
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Abstract base class for all Text-only Readers.
** Subclasses will include StreamReaderstringReader.
**
**
===========================================================*/

using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using System.Reflection;
using System.Security.Permissions;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;
#if FEATURE_ASYNC_IO
using System.Threading;
using System.Threading.Tasks;
#endif

namespace System.IO {
    // This abstract base class represents a reader that can read a sequential
    // stream of characters.  This is not intended for reading bytes -
    // there are methods on the Stream class to read bytes.
    // A subclass must minimally implement the Peek() and Read() methods.
    //
    // This class is intended for character input, not bytes.  
    // There are methods on the Stream class for reading bytes. 
    public abstract class TextReader : IDisposable {

#if FEATURE_ASYNC_IO

        private static Func<object, string> _ReadLineDelegate = state => ((TextReader)state).ReadLine();

        private static Func<object, int> _ReadDelegate = state => 
        {
            Tuple<TextReader, char[], int, int> tuple = (Tuple<TextReader, char[], int, int>)state;
            return tuple.Item1.Read(tuple.Item2, tuple.Item3, tuple.Item4);
        };
#endif //FEATURE_ASYNC_IO

        public static TextReader Null = new NullTextReader();
    
        protected TextReader() {}
    
        // Closes this TextReader and releases any system resources associated with the
        // TextReader. Following a call to Close, any operations on the TextReader
        // may raise exceptions.
        // 
        // This default method is empty, but descendant classes can override the
        // method to provide the appropriate functionality.
        public virtual void Close() 
        {
            Dispose();
            //GC.SuppressFinalize(this);
        }

        public void Dispose()
        {
            //Dispose(true);
            //GC.SuppressFinalize(this);
        }

        // Returns the next available character without actually reading it from
        // the input stream. The current position of the TextReader is not changed by
        // this operation. The returned value is -1 if no further characters are
        // available.
        // 
        // This default method simply returns -1.
        //

        public virtual int Peek() 
        {
            return -1;
        }
    
        // Reads the next character from the input stream. The returned value is
        // -1 if no further characters are available.
        // 
        // Reads a block of characters. This method will read up to
        // count characters from this TextReader into the
        // buffer character array starting at position
        // index. Returns the actual number of characters read.
        //
        public virtual int Read(ref char[]? buffer, int index = 0, int count = 1) 
			requires(index >= 0)
			requires(count > 0)
			//requires(buffer.length - index >= count)
            //ensures(result >= 0)
            ensures(result <= count)
        {
		 if (buffer==null)
			return -1;

            int n = 0;
            do {
                int ch = Read(ref buffer);
                if (ch == -1) break;
                buffer[index + n++] = (char)ch;
            } while (n < count);
            return n;
        }

        // Reads all characters from the current position to the end of the 
        // TextReader, and returns them as one string.
        public virtual string ReadToEnd()
			ensures (result != null)
        {
            char[] chars = new char[4096];
            int len;
            StringBuilder sb = new StringBuilder(4096);
            while((len=Read(chars, 0, chars.length)) != 0) 
            {
                sb.Append(chars, 0, len);
            }
            return sb.ToString();
        }

        // Blocking version of read.  Returns only when count
        // characters have been read or the end of the file was reached.
        // 
        public virtual int ReadBlock(ref char[] buffer, int index, int count) 
            ensures(result >= 0)
            ensures(result <= count)
        {
            int i, n = 0;
            do {
                n += (i = Read(buffer, index + n, count - n));
            } while (i > 0 && n < count);
            return n;
        }

        // Reads a line. A line is defined as a sequence of characters followed by
        // a carriage return ('\r'), a line feed ('\n'), or a carriage return
        // immediately followed by a line feed. The resulting string does not
        // contain the terminating carriage return and/or line feed. The returned
        // value is null if the end of the input stream has been reached.
        //
        public virtual string? ReadLine() {
			StringBuilder sb = new StringBuilder();
            while (true) {
                int ch = Read();
                if (ch == -1) break;
                if (ch == '\r' || ch == '\n') 
                {
                    if (ch == '\r' && Peek() == '\n') Read();
                    return sb.ToString();
                }
                sb.Append((char)ch);
            }
            if (sb.length > 0) return sb.ToString();
            return null;
        }

#if FEATURE_ASYNC_IO

        public virtual Task<string> ReadLineAsync()
        {
            return Task<string>.Factory.StartNew(_ReadLineDelegate, this, CancellationToken.None, TaskCreationOptions.DenyChildAttach, TaskScheduler.Default);
        }

        public async virtual Task<string> ReadToEndAsync()
        {
            char[] chars = new char[4096];
            int lenstringBuilder sb = newstringBuilder(4096);
            while((len = await ReadAsyncInternal(chars, 0, chars.length).ConfigureAwait(false)) != 0) 
            {
                sb.Append(chars, 0, len);
            }
            return sb.ToString();
        }

        public virtual Task<int> ReadAsync(char[] buffer, int index, int count)
			requires (index > 0 || count > 0)
			requires (buffer.length - index >= count)
        {
            return ReadAsyncInternal(buffer, index, count);
        }

        internal virtual Task<int> ReadAsyncInternal(char[] buffer, int index, int count)
        
        {
            requires(buffer != null);
            requires(index >= 0);
            requires(count >= 0);
            requires(buffer.length - index >= count);

            Tuple<TextReader, char[], int, int> tuple = new Tuple<TextReader, char[], int, int>(this, buffer, index, count);
            return Task<int>.Factory.StartNew(_ReadDelegate, tuple, CancellationToken.None, TaskCreationOptions.DenyChildAttach, TaskScheduler.Default);
        }
// [HostProtection(ExternalThreading=true)]

// [ComVisible(false)]

        public virtual Task<int> ReadBlockAsync(char[] buffer, int index, int count)
        {
            if (buffer==null)
                throw ArgumentNullException("buffer", Environment.GetResourcestring("ArgumentNull_Buffer"));
            if (index < 0 || count < 0)
                throw ArgumentOutOfRangeException((index < 0 ? "index" : "count"), Environment.GetResourcestring("ArgumentOutOfRange_NeedNonNegNum"));
            if (buffer.length - index < count)
                throw ArgumentException(Environment.GetResourcestring("Argument_InvalidOffLen"));

            Contract.EndContractBlock();

            return ReadBlockAsyncInternal(buffer, index, count);
         }
// [HostProtection(ExternalThreading=true)]

        private async Task<int> ReadBlockAsyncInternal(char[] buffer, int index, int count)
        {
            requires(buffer != null);
            requires(index >= 0);
            requires(count >= 0);
            requires(buffer.length - index >= count);

            int i, n = 0;
            do
            {
                i = await ReadAsyncInternal(buffer, index + n, count - n).ConfigureAwait(false);
                n += i;
            } while (i > 0 && n < count);

            return n;
        }
        
#endif //FEATURE_ASYNC_IO

        public static TextReader Synchronized(TextReader reader) 
            ensures(result != null)
        {
            if (reader is SyncTextReader)
                return reader;
            
            return new SyncTextReader(reader);
        }

        private class NullTextReader : TextReader
        {
            public NullTextReader(){}
            public override int Read(ref char[]? buffer, int index = 0, int count = 1) 
            {
                return 0;
            }
            
            public override string? ReadLine() 
            {
                return null;
            }
        }

        internal class SyncTextReader : TextReader 
        {
            internal TextReader _in;
            
            internal SyncTextReader(TextReader t) 
            {
                _in = t;        
            }

            public override void Close() 
            {
                // So that any overriden Close() gets run
                _in.Close();
            }

            protected override void Dispose(bool disposing) 
            {
                // Explicitly pick up a potentially methodimpl'ed Dispose
                if (disposing)
                    ((IDisposable)_in).Dispose();
            }

            public override int Peek() 
            {
                return _in.Peek();
            }

            public override int Read(ref char[] buffer, int index, int count) 
            {
                return _in.Read(buffer, index, count);
            }

            public override int ReadBlock(ref char[] buffer, int index, int count) 
            {
                return _in.ReadBlock(buffer, index, count);
            }

            public override string ReadLine() 
            {
                return _in.ReadLine();
            }

            public override string ReadToEnd() 
            {
                return _in.ReadToEnd();
            }

#if FEATURE_ASYNC_IO

            //
            // On SyncTextReader all APIs should run synchronously, even the async ones.
            //

            public override Task<string> ReadLineAsync()
            {
                return Task.FromResult(ReadLine());
            }

            public override Task<string> ReadToEndAsync()
            {
                return Task.FromResult(ReadToEnd());
            }

            public override Task<int> ReadBlockAsync(char[] buffer, int index, int count)
				requires (index > 0 || count > 0)
				requires (buffer.length - index >= count)
            {
                return Task.FromResult(ReadBlock(buffer, index, count));
            }

            public override Task<int> ReadAsync(char[] buffer, int index, int count)
				requires (index > 0 || count > 0)
				requires (buffer.length - index >= count)
            {
                return Task.FromResult(Read(buffer, index, count));
            }
#endif //FEATURE_ASYNC_IO
        }
    }
}
