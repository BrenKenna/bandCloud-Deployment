package com.aws_examples.storage_dynamo.s3_contoller;

import java.util.ArrayList;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.aws_examples.storage_dyname.model.DynamoModel;
import com.aws_examples.storage_dyname.model.InfoVMs;
import com.aws_examples.storage_dyname.model.StorageFiles;

import utils.AWS_Utils;
import utils.DynamoUtils;


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
	private List<S3ObjectSummary> results;
	
	
	/**
	 * 
	 */
	public StorageController() {
		this.utils = AWS_Utils.getInstance();
		this.dynamoUtil = DynamoUtils.getInstance();
		this.results = new ArrayList<>();
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
}
