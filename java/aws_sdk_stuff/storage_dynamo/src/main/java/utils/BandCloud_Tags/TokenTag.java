package utils.BandCloud_Tags;

import java.net.URL;
import java.util.Date;


/**
 * 
 * @author kenna
 *
 */
public class TokenTag extends BandCloudTag {
	
	// Attributes
	private final BandCloudTags tagType = BandCloudTags.TOKEN_TAG;
	private URL url;
	private Date expire;

	
	/**
	 * 
	 */
	public TokenTag() {
		super("Token");
	}
	
	
	/**
	 * 
	 * @param url
	 * @param expire
	 */
	public TokenTag(URL url, Date expire) {
		super("Token");
		this.url = url;
		this.expire = expire;
	}


	/**
	 * 
	 * @return
	 */
	public BandCloudTags getTagType() {
		return tagType;
	}


	/**
	 * 
	 * @return
	 */
	public URL getUrl() {
		return url;
	}
	
	
	/**
	 * 
	 * @param url
	 */
	public void setUrl(URL url) {
		this.url = url;
	}


	/**
	 * 
	 * @return
	 */
	public Date getExpire() {
		return expire;
	}
	
	
	/**
	 * 
	 * @param expire
	 */
	public void setExpire(Date expire) {
		this.expire = expire;
	}


	/**
	 * 
	 */
	@Override
	public String toString() {
		return "TokenTag [key=" + getKey() + ", tagType=" + tagType + ", url=" + url + ", expire=" + expire + "]";
	}


	@Override
	public BandCloudTags whichTag() {
		// TODO Auto-generated method stub
		return null;
	}
}
