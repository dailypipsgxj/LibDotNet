// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
namespace System {
    
    using System;    
    public interface IEquatable<T>
    {
        public abstract bool Equals(T other);
    }

}

