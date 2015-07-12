// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==

namespace System {
    using System.Collections;
    using System.Collections.Generic;    
    using System.Globalization;
    using System.Diagnostics.Contracts;
    using System.Runtime.Serialization;
    using System.Runtime.CompilerServices;

    public abstract class StringComparer :
		System.Collections.IComparer,
		System.Collections.IEqualityComparer,
		System.Collections.Generic.IComparer<string>,
		System.Collections.Generic.IEqualityComparer<string>
	{
        private static StringComparer _invariantCulture = new CultureAwareComparer(CultureInfo.InvariantCulture, false);        
        private static StringComparer _invariantCultureIgnoreCase = new CultureAwareComparer(CultureInfo.InvariantCulture, true);      
        private static StringComparer _ordinal = new OrdinalComparer(false);
        private static StringComparer _ordinalIgnoreCase = new OrdinalComparer(true);        

        public static StringComparer InvariantCulture { 
            get {
                return _invariantCulture;
            }
        }
        
        public static StringComparer InvariantCultureIgnoreCase { 
            get {
                return _invariantCultureIgnoreCase;
            }
        }

        public static StringComparer CurrentCulture { 
            owned get {
                return new CultureAwareComparer(CultureInfo.CurrentCulture, false);                
            }
        }
        
        public static StringComparer CurrentCultureIgnoreCase { 
            owned get {
                return new CultureAwareComparer(CultureInfo.CurrentCulture, true);                
            }
        }

        public static StringComparer Ordinal { 
            get {
                return _ordinal;
            }
        }

        public static StringComparer OrdinalIgnoreCase { 
            get {
                return _ordinalIgnoreCase;
            }
        }

        public static StringComparer Create(CultureInfo culture, bool ignoreCase) {
            return new CultureAwareComparer(culture, ignoreCase);            
        }  

        public virtual int Compare(Object x, Object y) {
            string _x = x as string;
            string _y = y as string;
			_x = _x.casefold();
			_y = _y.casefold();
			return _x.collate(_y);
        }

       
        public new bool Equals(Object x, Object y) {
			return (x == y);
        }
        
        public int GetHashCode( Object obj) {
            string s = obj as string;
            if( s != null) {
                return s.hash() as int;
            }
            //return obj.GetHashCode();            
        }
        
    }

    internal class CultureAwareComparer: StringComparer
    {
        private bool _ignoreCase;
        private CultureInfo _compareInfo;

        internal CultureAwareComparer(CultureInfo culture, bool ignoreCase) {
               _compareInfo = culture;
               _ignoreCase = ignoreCase;
        }

        public new virtual int Compare(string x, string y) {
            string _x, _y;
            if( _ignoreCase) {
				_x = x.casefold();
				_y = y.casefold();
                return _x.collate(_y);
            }
           return x.collate(y);
        }
                
        public new virtual bool Equals(string x, string y) {
			return (x == y);
        }               
                
        public new virtual int GetHashCode(string obj) {
            return obj.hash() as int;
        }       
    }

    // Provide x more optimal implementation of ordinal comparison.

    internal class OrdinalComparer : StringComparer 
    {
        private bool _ignoreCase;
       
        internal OrdinalComparer(bool ignoreCase) {
            _ignoreCase = ignoreCase;
        }

        public new virtual int Compare(string x, string y) {
            string _x, _y;
            if( _ignoreCase) {
				_x = x.casefold();
				_y = y.casefold();
                return _x.collate(_y);
            }
           return x.collate(y);
        }
                
        public new virtual bool Equals(string x, string y) {
			return (x == y);
        }               
                
        public new virtual int GetHashCode(string obj) {
            return obj.hash() as int;
        }       
                               
    }

}
