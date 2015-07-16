/*
 * DESCRIPTION      Unit tests for Dia3.
 * PROJECT          Dia3
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with GPL licence.
 */

using LibDotNet;
using System.Collections;

public class SystemCollectionsArrayListTests : LibDotNet.TestCase {
	
	public SystemCollectionsArrayListTests () {
		base ("System.Collections.Generic.Comparer");
		
		add_test ("[System.Collections.Generic][Comparer] New Array List with default constructor", new_with_default_constructor);
		
	}


}

