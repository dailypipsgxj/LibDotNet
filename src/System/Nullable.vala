// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==

    using System;

namespace System
{
    using System.Globalization;
    using System.Reflection;    
    using System.Collections.Generic;
    using System.Runtime;
    using System.Runtime.CompilerServices;    
    using System.Security;
    using System.Diagnostics.Contracts;

    // Warning, don't put System.Runtime.Serialization.On*Serializ*Attribute
    // on this class without first fixing ObjectClone::InvokeVtsCallbacks
    // Also, because we have special type system support that says a a boxed Nullable<T>
    // can be used where a boxed<T> is use, Nullable<T> can not implement any intefaces
    // at all (since T may not).   Do NOT add any interfaces to Nullable!
    // 
    public class Nullable<T>
    {
        private bool hasValue; 
        internal T value; 
        
        public Nullable(T value) {
            this.value = value;
            this.hasValue = true;
        }        

        public bool HasValue {
            get {
                return hasValue;
                }
            } 

        public T Value {
            get {
                return value;
            }
        }

        public T GetValueOrDefault(T defaultValue) {
            return HasValue ? value : defaultValue;
        }

        public bool Equals( Object other) {
            return false;
        }

        public int GetHashCode() {
            return 0;
        }

        public string ToString() {
            return "";
        }

	}
	
}
