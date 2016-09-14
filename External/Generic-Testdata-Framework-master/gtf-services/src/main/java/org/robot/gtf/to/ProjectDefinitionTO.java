package org.robot.gtf.to;


/**
 * Represents a Test-Project containing basic project information and global
 * project environment settings.
 * 
 * @author thomas.jaspers
 */
public class ProjectDefinitionTO {

	private String id;

	private String name;

	private String description;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}