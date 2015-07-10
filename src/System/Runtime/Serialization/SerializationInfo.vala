// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  SerializationInfo
**
**
** Purpose: The structure for holding all of the data needed
**          for Object serialization and deserialization.
**
**
===========================================================*/
namespace System.Runtime.Serialization
{

    using System;
    using System.Reflection;
    using System.Runtime.Remoting;
    using System.Globalization;
    using System.Diagnostics.Contracts;
    using System.Security;

    public class SerializationInfo
    {
        private const int defaultSize = 4;
        private const string s_mscorlibAssemblySimpleName = "mscorlib";
        private const string s_mscorlibFileName = s_mscorlibAssemblySimpleName + ".dll";
        
        internal string[] m_members;
        internal Object[] m_data;
        internal Type[] m_types;
        internal int m_currMember;
        internal IFormatterConverter m_converter;
        private string m_fullTypeName;
        private string m_assemName;
        private Type objectType;
        private bool isFullTypeNameSetExplicit;
        private bool isAssemblyNameSetExplicit;


        public SerializationInfo(Type type, IFormatterConverter? converter = null, bool requireSameTokenInPartialTrust = false)
        {

            objectType = type;
            m_fullTypeName = type.FullName;
            m_assemName = type.Module.Assembly.FullName;

            m_members = new string[defaultSize];
            m_data = new Object[defaultSize];
            m_types = new Type[defaultSize];

            m_converter = converter;

        }

        public string FullTypeName
        {
            get
            {
                return m_fullTypeName;
            }
            set
            {
                m_fullTypeName = value;
                isFullTypeNameSetExplicit = true;
            }
        }

        public string AssemblyName
        {
            get
            {
                return m_assemName;
            }
            set
            {
                m_assemName = value;
                isAssemblyNameSetExplicit = true;
            }
        }

        public void SetType(Type type)
        {
            if (!Object.ReferenceEquals(objectType, type))
            {
                objectType = type;
                m_fullTypeName = type.FullName;
                m_assemName = type.Module.Assembly.FullName;
                isFullTypeNameSetExplicit = false;
                isAssemblyNameSetExplicit = false;
            }
        }

        private static bool Compare(char[] a, char[] b)
        {
            // if either or both assemblies do not have public key token, we should demand, hence, returning false will force a demand
            if (a == null || b == null || a.Length == 0 || b.Length == 0 || a.Length != b.Length)
            {
                return false;
            }
            else
            {
                for (int i = 0; i < a.Length; i++)
                {
                    if (a[i] != b[i]) return false;
                }

                return true;
            }
        }

        internal static void DemandForUnsafeAssemblyNameAssignments(string originalAssemblyName, string newAssemblyName)
        {
            if (!IsAssemblyNameAssignmentSafe(originalAssemblyName, newAssemblyName))
            {
                CodeAccessPermission.Demand(PermissionType.SecuritySerialization);
            }
        }

        internal static bool IsAssemblyNameAssignmentSafe(string originalAssemblyName, string newAssemblyName)
        {
            if (originalAssemblyName == newAssemblyName)
            {
                return true;
            }

            AssemblyName originalAssembly = new AssemblyName(originalAssemblyName);
            AssemblyName newAssembly = new AssemblyName(newAssemblyName);

            // mscorlib will get loaded by the runtime regardless of its string casing or its public key token,
            // so setting the assembly name to mscorlib must always be protected by a demand
            if (string.Equals(newAssembly.Name, s_mscorlibAssemblySimpleNameStringComparison.OrdinalIgnoreCase) ||
                string.Equals(newAssembly.Name, s_mscorlibFileNameStringComparison.OrdinalIgnoreCase))
            {
                return false;
            }

            return Compare(originalAssembly.GetPublicKeyToken(), newAssembly.GetPublicKeyToken());
        }

        public int MemberCount
        {
            get
            {
                return m_currMember;
            }
        }

        public Type ObjectType
        {
            get
            {
                return objectType;
            }
        }

        public bool IsFullTypeNameSetExplicit
        {
            get
            {
                return isFullTypeNameSetExplicit;
            }
        }

        public bool IsAssemblyNameSetExplicit
        {
            get
            {
                return isAssemblyNameSetExplicit;
            }
        }

        public SerializationInfoEnumerator GetEnumerator()
        {
            return new SerializationInfoEnumerator(m_members, m_data, m_types, m_currMember);
        }

        private void ExpandArrays()
        {
            int newSize;
            Contract.Assert(m_members.Length == m_currMember, "[SerializationInfo.ExpandArrays]m_members.Length == m_currMember");

            newSize = (m_currMember * 2);

            //
            // In the pathological case, we may wrap
            //
            if (newSize < m_currMember)
            {
                if (int32.MaxValue > m_currMember)
                {
                    newSize = int32.MaxValue;
                }
            }

            //
            // Allocate more space and copy the datastring[] newMembers = newstring[newSize];
            Object[] newData = new Object[newSize];
            Type[] newTypes = new Type[newSize];

            Array.Copy(m_members, newMembers, m_currMember);
            Array.Copy(m_data, newData, m_currMember);
            Array.Copy(m_types, newTypes, m_currMember);

            //
            // Assign the new arrys back to the member vars.
            //
            m_members = newMembers;
            m_data = newData;
            m_types = newTypes;
        }

        public void AddValue (string name, Object value, Type type)
        {
            if (null == name)
            {
                throw ArgumentNullException("name");
            }

            if ((Object)type == null)
            {
                throw ArgumentNullException("type");
            }
            Contract.EndContractBlock();

            //
            // Walk until we find a member by the same name or until
            // we reach the end.  If we find a member by the same name,
            // throw.
            for (int i = 0; i < m_currMember; i++)
            {
                if (m_members[i].Equals(name))
                {
                    BCLDebug.Trace("SER", "[SerializationInfo.AddValue]Tried to add ", name, " twice to the SI.");

                    throw SerializationException(Environment.GetResourceString("Serialization_SameNameTwice"));
                }
            }

            //AddValue(name, value, type, m_currMember);

        }


        /*=================================UpdateValue==================================
        **Action: Finds the value if it exists in the current data.  If it does, we replace
        **        the values, if not, we append it to the end.  This is useful to the 
        **        ObjectManager when it's performing fixups, but shouldn't be used by 
        **        clients.  Exposing out this functionality would allow children to overwrite
        **        their parent's values.
        **Returns: void
        **Arguments: name  -- the name of the data to be updated.
        **           value -- the new value.
        **           type  -- the type of the data being added.
        **Exceptions: None.  All error checking is done with asserts.
        ==============================================================================*/
        internal void UpdateValue (string name, Object value, Type type)
        {
            int index = FindElement(name);
            if (index < 0)
            {
                AddValue(name, value, type, m_currMember);
            }
            else
            {
                m_members[index] = name;
                m_data[index] = value;
                m_types[index] = type;
            }

        }

        private int FindElement (string name)
        {
            for (int i = 0; i < m_currMember; i++)
            {
                Contract.Assert(m_members[i] != null, "[SerializationInfo.FindElement]Null Member instring array.");
                if (m_members[i].Equals(name))
                {
                    return i;
                }
            }
            return -1;
        }

        /*==================================GetElement==================================
        **Action: Use FindElement to get the location of a particular member and then return
        **        the value of the element at that location.  The type of the member is
        **        returned in the foundType field.
        **Returns: The value of the element at the position associated with name.
        **Arguments: name -- the name of the element to find.
        **           foundType -- the type of the element associated with the given name.
        **Exceptions: None.  FindElement does null checking and throws for elements not 
        **            found.
        ==============================================================================*/
        private Object GetElement (string name, out Type foundType)
        {
            int index = FindElement(name);
            if (index == -1)
            {
                throw SerializationException(Environment.GetResourceString("Serialization_NotFound", name));
            }
            foundType = m_types[index];
            return m_data[index];
        }

        private Object GetElementNoThrow (string name, out Type foundType)
        {
            int index = FindElement(name);
            if (index == -1)
            {
                foundType = null;
                return null;
            }

            foundType = m_types[index];
            return m_data[index];
        }

        //
        // The user should call one of these getters to get the data back in the 
        // form requested.  
        //
        public Object GetValue (string name, Type type)
        {

            RuntimeType rt = type as RuntimeType;
            if (rt == null)
                throw ArgumentException(Environment.GetResourceString("Argument_MustBeRuntimeType"));

            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
			if (Object.ReferenceEquals(foundType, type) || type.IsAssignableFrom(foundType) || value == null)
			{
				return value;
			}

            return m_converter.Convert(value, type);
        }

        internal Object GetValueNoThrow (string name, Type type)
        {
            Type foundType;
            Object value;

            value = GetElementNoThrow(name, out foundType);
            if (value == null)
                return null;
                if (Object.ReferenceEquals(foundType, type) || type.IsAssignableFrom(foundType) || value == null)
                {
                    return value;
                }

            return m_converter.Convert(value, type);
        }

        public bool GetBoolean (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(bool)))
            {
                return (bool)value;
            }
            return m_converter.ToBoolean(value);
        }

        public char GetChar (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(char)))
            {
                return (char)value;
            }
            return m_converter.ToChar(value);
        }
// [CLSCompliant(false)]

        public char GetSByte (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(char)))
            {
                return (char)value;
            }
            return m_converter.ToSByte(value);
        }

        public char GetByte (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(char)))
            {
                return (char)value;
            }
            return m_converter.ToByte(value);
        }

        public short GetInt16 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(short)))
            {
                return (short)value;
            }
            return m_converter.ToInt16(value);
        }
// [CLSCompliant(false)]

        public ushort GetUInt16 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(ushort)))
            {
                return (ushort)value;
            }
            return m_converter.ToUInt16(value);
        }

        public int Getint32 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(int)))
            {
                return (int)value;
            }
            return m_converter.Toint32(value);
        }
// [CLSCompliant(false)]

        public uint GetUint32 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(uint)))
            {
                return (uint)value;
            }
            return m_converter.ToUint32(value);
        }

        public long GetInt64 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(long)))
            {
                return (long)value;
            }
            return m_converter.ToInt64(value);
        }
// [CLSCompliant(false)]

        public ulong GetUInt64 (string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(ulong)))
            {
                return (ulong)value;
            }
            return m_converter.ToUInt64(value);
        }

        public float GetSingle(string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(float)))
            {
                return (float)value;
            }
            return m_converter.ToSingle(value);
        }


        public double GetDouble(string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(double)))
            {
                return (double)value;
            }
            return m_converter.ToDouble(value);
        }

        public float GetDecimal(string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(float)))
            {
                return (float)value;
            }
            return m_converter.ToDecimal(value);
        }

        public DateTime GetDateTime(string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof(DateTime)))
            {
                return (DateTime)value;
            }
            return m_converter.ToDateTime(value);
        }

        public string GetString(string name)
        {
            Type foundType;
            Object value;

            value = GetElement(name, out foundType);
            if (Object.ReferenceEquals(foundType, typeof (string)) || value == null)
            {
                return (string)value;
            }
            return m_converter.ToString(value);
        }

        internal string[] MemberNames
        {
            get
            {
                return m_members;
            }

        }

        internal Object[] MemberValues
        {
            get
            {
                return m_data;
            }
        }

    }
}
