package com.aws_examples.storage_dyname.model;

import java.util.Date;

import com.amazonaws.services.s3.model.S3ObjectSummary;


/**
 * 
 * @author kenna
 *
 */
public class StorageFiles {

	private String filePath;
	private long fileSize;
	private Date lastModified;
	
	public StorageFiles() {}
	
	public StorageFiles(S3ObjectSummary data) {
		this.filePath = data.getKey();
		this.fileSize = data.getSize();
		this.lastModified = data.getLastModified();
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public Date getLastModified() {
		return lastModified;
	}

	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}

	@Override
	public String toString() {
		return "storageFiles [filePath=" + filePath + ", fileSize=" + fileSize + ", lastModified=" + lastModified + "]";
	}
}
