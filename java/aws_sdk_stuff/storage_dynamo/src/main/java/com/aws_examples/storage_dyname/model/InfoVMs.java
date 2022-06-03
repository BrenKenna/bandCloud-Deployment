package com.aws_examples.storage_dyname.model;

import java.util.Date;

import com.amazonaws.services.ec2.model.Instance;

public class InfoVMs {
	
	private String imageId, instanceId, instanceName, instanceType,
		availZone, state, hypervisor, publicDNS;
	private Date creationDate;
	
	
	public InfoVMs() {}
	
	public InfoVMs(Instance instance) {
		this.imageId = instance.getImageId();
		this.instanceId = instance.getInstanceId();
		this.instanceName = instance.getTags().get(0).getValue();
		this.instanceType = instance.getInstanceType();
		this.availZone = instance.getPlacement().getAvailabilityZone();
		this.state = instance.getState().getName();
		this.hypervisor = instance.getHypervisor();
		this.publicDNS = instance.getPublicDnsName();
		this.creationDate = instance.getLaunchTime();
	}

	public String getImageId() {
		return imageId;
	}

	public void setImageId(String imageId) {
		this.imageId = imageId;
	}

	public String getInstanceId() {
		return instanceId;
	}

	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}

	public String getInstanceName() {
		return instanceName;
	}

	public void setInstanceName(String instanceName) {
		this.instanceName = instanceName;
	}

	public String getInstanceType() {
		return instanceType;
	}

	public void setInstanceType(String instanceType) {
		this.instanceType = instanceType;
	}

	public String getAvailZone() {
		return availZone;
	}

	public void setAvailZone(String availZone) {
		this.availZone = availZone;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getHypervisor() {
		return hypervisor;
	}

	public void setHypervisor(String hypervisor) {
		this.hypervisor = hypervisor;
	}

	public String getPublicDNS() {
		return publicDNS;
	}

	public void setPublicDNS(String publicDNS) {
		this.publicDNS = publicDNS;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	@Override
	public String toString() {
		return "InfoVMs [imageId=" + imageId + ", instanceId=" + instanceId + ", instanceName=" + instanceName
				+ ", instanceType=" + instanceType + ", availZone=" + availZone + ", state=" + state + ", hypervisor="
				+ hypervisor + ", publicDNS=" + publicDNS + ", creationDate=" + creationDate + ", getImageId()="
				+ getImageId() + ", getInstanceId()=" + getInstanceId() + ", getInstanceName()=" + getInstanceName()
				+ ", getInstanceType()=" + getInstanceType() + ", getAvailZone()=" + getAvailZone() + ", getState()="
				+ getState() + ", getHypervisor()=" + getHypervisor() + ", getPublicDNS()=" + getPublicDNS()
				+ ", getCreationDate()=" + getCreationDate() + ", getClass()=" + getClass() + ", hashCode()="
				+ hashCode() + ", toString()=" + super.toString() + "]";
	}
}
