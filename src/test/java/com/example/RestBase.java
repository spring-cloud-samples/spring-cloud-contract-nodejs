package com.example;

import io.restassured.RestAssured;
import org.junit.Before;
import org.junit.ClassRule;

/**
 * @author Marcin Grzejszczak
 */
public class RestBase {

	@Before
	public void setup() {
		RestAssured.baseURI = "http://localhost:3000";
	}
}
