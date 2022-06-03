package utils;

import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amazonaws.auth.*;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectTaggingRequest;
import com.amazonaws.services.s3.model.GetObjectTaggingResult;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectTagging;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.services.s3.model.SetObjectTaggingRequest;
import com.amazonaws.services.s3.model.Tag;
import com.aws_examples.storage_dyname.model.InfoVMs;

import utils.BandCloud_Tags.*;


/**
 * Class to support smaller aws stuff
 * 
 * For uploading a file to S3
 * 	https://medium.com/oril/uploading-files-to-aws-s3-bucket-using-spring-boot-483fcb6f8646
 * 
 * @author kenna
 */
public class AWS_Utils {

	// Attributes
	private static AWS_Utils instance = null;
	private final AWSCredentials credentials;
	private final AmazonS3 s3client;
	private final AmazonEC2 ec2client;
	private final DateUtils dateUtils = new DateUtils();
	
	
	/**
	 * 
	 */
	private AWS_Utils() {
		this.credentials = new BasicAWSCredentials("AKIAQIE6HOZRUGFBEJ7D", "0B7mKoVkxlNNcmCGkUO6WNile6BlImUYZSKFh8Em");
		this.s3client = AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials))
				  .withRegion(Regions.EU_WEST_1)
				  .build();
		this.ec2client = AmazonEC2ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials))
				  .withRegion(Regions.EU_WEST_1)
				  .build();
	}

	
	/**
	 * 
	 * @return
	 */
	public static AWS_Utils getInstance() {
		if(instance == null) {
			instance = new AWS_Utils();
		}
		return instance;
	}
	
	
	/**
	 * 
	 * @param bucket
	 * @return
	 */
	public List<S3ObjectSummary> listObjects(String bucket) {
		ObjectListing data = s3client.listObjects(bucket);
		return data.getObjectSummaries();
	}
	
	
	
	/**
	 * 
	 * 
	 * @param bucket
	 * @param path
	 * @param tagKey
	 * @param tagVal
	 */
	public void addTag(String bucket, String path, String tagKey, String tagVal) {
		
		// Create tag
		List<Tag> tags = new ArrayList<>();
		tags.add(new Tag(tagKey, tagVal));
		ObjectTagging tag = new ObjectTagging(tags);
		
		// Set object tags
		SetObjectTaggingRequest tagRequest = new SetObjectTaggingRequest(bucket, path, tag);
		s3client.setObjectTagging(tagRequest);
	}
	
	
	/**
	 * Get object tags
	 * 
	 * @param bucket
	 * @param path
	 * @return
	 */
	public Map<String, String> getTags(String bucket, String path, BandCloudTags tagType) {
		
		// Get object tags
		Map<String, String> output = new HashMap<>();
		GetObjectTaggingRequest getTaggingRequest = new GetObjectTaggingRequest(bucket, path);
        GetObjectTaggingResult getTagsResult = s3client.getObjectTagging(getTaggingRequest);
		
        // Populate output
        for (Tag tag : getTagsResult.getTagSet() ) {
        	if ( tagType.isTag(tag.getKey()) ) {
        		output.put(tag.getKey(), tag.getValue());
        	}
        } 
		return output;
	}
	
	
	/**
	 * 
	 * @param bucket
	 * @param path
	 * @return
	 */
	public TokenTag getSignedURL(String bucket, String path) {
		Date expire = dateUtils.getExpireDate(dateUtils.getNow());
		URL url = s3client.generatePresignedUrl(bucket, bucket, expire);
		return new TokenTag(url, expire);
	}
	
	
	/**
	 * 
	 * @param bucket
	 * @param path
	 * @param file
	 */
	public void putFile(String bucket, String path, String file) {
		
		
	}
	
	
	/**
	 * 
	 * @param bucket
	 * @param bucketKey
	 * @return
	 */
	public List<S3ObjectSummary> listObjects(String bucket, String bucketKey) {
		ObjectListing data = s3client.listObjects(bucket, bucketKey);
		return data.getObjectSummaries();
	}
	
	
	
	/**
	 * 
	 * @return
	 */
	public List<InfoVMs> listVMs() {
		List<InfoVMs> output = new ArrayList<>();
		boolean allData = false;
		DescribeInstancesResult data = ec2client.describeInstances();
		do {
			// Add results
			for (Reservation reservation : data.getReservations() ) {
				for(Instance instance : reservation.getInstances()) {
					output.add(new InfoVMs(instance));
				}
			}
			
			// Handle next page
			if (data.getNextToken() == null) {
				allData = true;
			}
			else {
				data.setNextToken(data.getNextToken());
			}
			
		} while(!allData);
		
		return output;
	}
}
