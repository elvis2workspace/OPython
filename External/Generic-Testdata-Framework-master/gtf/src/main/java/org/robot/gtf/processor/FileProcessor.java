package org.robot.gtf.processor;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.robot.gtf.builder.BuilderException;
import org.robot.gtf.configuration.Arguments;
import org.robot.gtf.configuration.BuilderConfiguration;
import org.robot.gtf.configuration.Metadata;
import org.robot.gtf.configuration.MetadataReader;
import org.robot.gtf.main.GTFException;
import org.robot.gtf.to.MappingTO;

public abstract class FileProcessor extends Processor {

	protected abstract String doTheProcessing(BuilderConfiguration builderConfiguration,
			Map<String, Metadata> metadataMap, List<MappingTO> mappingInformation) throws BuilderException;

	protected abstract String getFileEnding();

	protected abstract String getFileDirectoryPath(Arguments arguments);

	/**
	 * Processing file based testdata
	 * 
	 * @param metadataReader
	 *            Metadata Reader
	 * @param arguments
	 *            The argument file passed in via command line
	 * @throws GTFException
	 *             In case an error occurs during processings
	 */
	public void processFiles(MetadataReader metadataReader, Arguments arguments, List<MappingTO> mappingInformation)
			throws GTFException {

		String path = getFileDirectoryPath(arguments);
		File folder = new File(path);
		File[] listFiles = folder.listFiles();

		Map<File, String> directoryMap = new HashMap<File, String>();

		// Search for files in sub-directories to process
		for (File file : listFiles) {
			if (file.isDirectory()) {
				File[] subListFiles = file.listFiles();
				for (File subFile : subListFiles) {
					directoryMap.put(subFile, file.getName());
				}
				listFiles = (File[]) ArrayUtils.addAll(listFiles, subListFiles);
			}
		}

		Map<String, Metadata> metadataMap = readMetadataFiles(arguments);

		if (listFiles != null) {
			System.out.println("Processing files from " + path + "\n");
			for (File file : listFiles) {

				String subDirectory = directoryMap.get(file);
				String subDirectoryPath = directoryMap.get(file);
				if (subDirectory == null) {
					subDirectory = "";
					subDirectoryPath = "";
				} else {
					subDirectoryPath += File.separator;
				}

				String fileName = file.getName();
				if (fileName.endsWith(getFileEnding())) {
					System.out.println("Processing file: " + subDirectoryPath + fileName);

					String rawName = StringUtils.removeEnd(fileName, getFileEnding());
					String testsuiteFile = rawName + "." + arguments.getTestsuiteFilePostfix();

					BuilderConfiguration builderConfiguration = new BuilderConfiguration();
					builderConfiguration.setFilePath(file.getPath());
					builderConfiguration.setExcelEncoding(arguments.getExcelEncoding());
					builderConfiguration.setConfigurationDirectory(arguments.getConfigurationDirectory());
					builderConfiguration.setSubDirectory(subDirectory);

					String result = doTheProcessing(builderConfiguration, metadataMap, mappingInformation);

					writeTestsuiteFile(result, testsuiteFile, arguments);
					System.out.println("ok\n");
				}
			}
		} else {
			System.out.println("No files found ending with '" + getFileEnding() + "' from directory: " + path);
		}
	}

	/**
	 * Read in all Metadata Information
	 * 
	 * @param arguments
	 *            Argument-Data
	 * @return Map containing all Metadata information
	 * @throws GTFException
	 */
	private Map<String, Metadata> readMetadataFiles(Arguments arguments) throws GTFException {

		Map<String, Metadata> metadataMap = new HashMap<String, Metadata>();

		MetadataReader reader = new MetadataReader(arguments.getConfigurationDirectory());

		File folder = new File(reader.getMetadataDirectory());
		File[] listFiles = folder.listFiles();

		if (listFiles != null) {
			System.out.println("Reading metadata files from " + reader.getMetadataDirectory() + "\n");
			String keyName = "";
			for (File file : listFiles) {

				if (file.isDirectory()) {
					String directoryName = file.getName();

					File subFolder = new File(reader.getMetadataDirectory() + file.getName());
					File[] subListFiles = subFolder.listFiles();

					for (File subFile : subListFiles) {

						if (subFile.getName().endsWith(".properties")) {
							Metadata metadata = reader.read(directoryName + File.separator + subFile.getName());

							keyName = directoryName + "_" + subFile.getName();
							keyName = StringUtils.remove(keyName, ".properties");

							metadataMap.put(keyName, metadata);
							System.out.println("Reading metadata: " + keyName);
						} else {
							System.out.println("Ignoring file '" + subFile.getName()
									+ "' as it does not have the postfix '.properties'");
						}

					}
				} else {

					if (file.getName().endsWith(".properties")) {

						Metadata metadata = reader.read(file.getName());

						keyName = file.getName();
						keyName = StringUtils.remove(keyName, ".properties");

						metadataMap.put(keyName, metadata);
						System.out.println("Reading metadata: " + keyName);
					} else {
						System.out.println("Ignoring file '" + file.getName()
								+ "' as it does not have the postfix '.properties'");
					}

				}
			}

			System.out.println();
		}

		return metadataMap;
	}

}
