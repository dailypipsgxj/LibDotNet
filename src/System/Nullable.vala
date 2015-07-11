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
// [Serializable]
	[Compact]
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
                if (!HasValue) {
                    //ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_NoValue);
                }
                return value;
            }
        }

        public T GetValueOrDefault(T defaultValue) {
            return HasValue ? value : defaultValue;
        }

        public override bool Equals( Object other) {
            if (!HasValue) return other == null;
            if (other == null) return false;
            return value.Equals(other);
        }

        public override int GetHashCode() {
            return HasValue ? value.GetHashCode() : 0;
        }

        public override string ToString() {
            return HasValue ? value.ToString() : "";
        }

	}
	
}
