package com.aws_api.service_testing.domain.simple_controller;

import java.io.File;

import java.io.InputStream;
import java.util.ArrayList;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


import com.amazonaws.services.s3.model.PutObjectResult;
import com.amazonaws.services.s3.model.S3ObjectSummary;


import com.aws_api.model.*;
import com.aws_api.service_testing.ServiceTestingApplication;
import com.aws_api.utils.aws.*;


/**
 * 
 * @author kenna
 *
 */
@RestController
public class StorageController {

	// Attributes
	private final AWS_Utils utils;
	private final DynamoUtils dynamoUtil;
	private final String rootPath = "bandcloud";
	
	
	/**
	 * 
	 */
	public StorageController() {
		this.utils = AWS_Utils.getInstance();
		this.dynamoUtil = DynamoUtils.getInstance();
		checkFiles();
	}
	
	
	
	/**
	 * 
	 * @return
	 */
	@GetMapping("/")
	public List<S3ObjectSummary> check() {
		return utils.listObjects(rootPath);
	}
	
	
	
	/**
	 * 
	 * @param key
	 * @return
	 */
	@ResponseBody
	@GetMapping("/listData")
	public ResponseEntity<?> listData(@RequestParam("key") String key) {
		List<StorageFiles> output = new ArrayList<>();
		for ( S3ObjectSummary i : utils.listObjects(rootPath, key) ) {
			output.add( new StorageFiles(i) );
		}
		return new ResponseEntity<>(output, HttpStatus.OK);
	}
	
	
	/**
	 * 
	 * @return
	 */
	@GetMapping("/pushTestData")
	public ResponseEntity<?> pushTestData() {
		Map<String, PutObjectResult> output = utils.putFile("bandcloud");
		if ( output != null ) {
			return new ResponseEntity<>(output, HttpStatus.OK);
		}
		return new ResponseEntity<>("", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	/**
	 * 
	 * @return
	 */
	@GetMapping("/ec2")
	public List<InfoVMs> checkVm() {
		return utils.listVMs();
	}
	
	
	
	/**
	 * 
	 * @param user
	 * @return
	 */
	@PostMapping("/register")
	public ResponseEntity<?> putUser(@RequestBody DynamoModel user) {
		dynamoUtil.importItem(user.getUsername(), user.getEmail());
		dynamoUtil.getItem(user.getUsername(), user.getEmail());
		return null;
	}


	/**
	 * 
	 * @param username
	 * @return
	 */
	@GetMapping("/login")
	public ResponseEntity<?> queryUser(@RequestParam("username") String username, @RequestParam("email") String email ) {
		dynamoUtil.getItem(username, email);
		return null;
	}
	
	
	
	/**
	 * 
	 * @return
	 */
	private boolean checkFiles() {
		
		// Read files from resources
		File textFile, audioFile;		
		InputStream dataStream = ServiceTestingApplication.class.getClassLoader().getResourceAsStream("test_data/site_audio_acoustic.mp3");
		textFile = new File(ServiceTestingApplication.class.getClassLoader().getResource("test_data/todo.txt").getFile());
		audioFile = new File(ServiceTestingApplication.class.getClassLoader().getResource("test_data/site_audio_acoustic.mp3").getFile());
		
		if (dataStream == null ) {
			System.out.println("Nope, not found in resources");
			return false;
		}
		else {
			System.out.println("Yarp");
			return true;
		}
	}
}
