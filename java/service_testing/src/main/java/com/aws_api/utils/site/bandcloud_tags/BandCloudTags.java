package com.aws_api.utils.site.bandcloud_tags;

import java.net.URL;
import java.util.Date;


/**
 * 
 * @author kenna
 *
 */
public enum BandCloudTags {

	FILE_TAG {

		@Override
		public boolean isTag(BandCloudTags tag) {
			return tag == FILE_TAG;
		}

		@Override
		public String toString() {
			return "FileTag";
		}

		@Override
		public BandCloudTag makeTag(Object key, Object value) {
			return new FileTag((String) key);
		}

		@Override
		public BandCloudTag makeTag() {
			return new FileTag();
		}
		
		@Override
		public boolean isTag(String tag) {
			return tag.equals(FILE_TAG.toString());
		}
	},
	
	TOKEN_TAG {

		@Override
		public boolean isTag(BandCloudTags tag) {
			return tag == TOKEN_TAG;
		}

		@Override
		public String toString() {
			return "TokenTag";
		}

		@Override
		public BandCloudTag makeTag(Object key, Object value) {
			return new TokenTag((URL) key, (Date) value);
		}

		@Override
		public BandCloudTag makeTag() {
			return new TokenTag();
		}

		@Override
		public boolean isTag(String tag) {
			return tag.equals(TOKEN_TAG.toString());
		}
	};
	
	
	/**
	 * 
	 * @return
	 */
	public abstract boolean isTag(BandCloudTags tag);
	
	
	/**
	 * 
	 * @param tag
	 * @return
	 */
	public abstract boolean isTag(String tag);
	
	
	/**
	 * 
	 * @return
	 */
	public abstract BandCloudTag makeTag();
	
	
	/**
	 * 
	 * @param data
	 * @return
	 */
	public abstract BandCloudTag makeTag(Object key, Object value);
	
	
	/**
	 * 
	 */
	@Override
	public abstract String toString();
}
