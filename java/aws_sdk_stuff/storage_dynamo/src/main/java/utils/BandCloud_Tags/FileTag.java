package utils.BandCloud_Tags;

public class FileTag extends BandCloudTag{
	
	// Attributes
	private String owner;
	
	
	/**
	 * 
	 */
	public FileTag() {
		super("Owner");
	}
	
	
	/**
	 * 
	 * @param owner
	 */
	public FileTag(String owner) {
		super("Owner");
		this.owner = owner;
	}


	/**
	 * 
	 * @return
	 */
	public void setKey(String key) {
		setKey(key);
	}


	/**
	 * 
	 * @return
	 */
	public String getOwner() {
		return owner;
	}


	/**
	 * 
	 */
	@Override
	public String toString() {
		return "FileTag [key=" + getKey() + ", owner=" + owner + "]";
	}


	@Override
	public BandCloudTags whichTag() {
		return BandCloudTags.FILE_TAG;
	}
}
