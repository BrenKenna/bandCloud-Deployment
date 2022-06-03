package com.aws_examples.storage_dyname.model;


/**
 * 
 * @author kenna
 *
 */
public class DynamoModel {

	private String username, email;
	
	public DynamoModel() {}
	
	public DynamoModel(String username, String email) {
		this.username = username;
		this.email = email;
	}

	
	/**
	 * 
	 * @return
	 */
	public String getUsername() {
		return username;
	}

	
	/**
	 * 
	 * @param username
	 */
	public void setUsername(String username) {
		this.username = username;
	}

	
	/**
	 * 
	 * @return
	 */
	public String getEmail() {
		return email;
	}

	
	/**
	 * 
	 * @param email
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	
	/**
	 * 
	 */
	@Override
	public String toString() {
		return "DynamoModel [username=" + username + ", email=" + email + "]";
	}
}
