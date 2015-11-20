+ Description
Maven is a java tool, So we need java to in order to use Maven.
```
http://maven.apache.org/pom.html
```
Download & Installation
```
http://maven.apache.org/download.cgi
```
 
+ Commands
```
mvn --version
Apache Maven 3.0.5 (r01de14724cdef164cd33c7c8c2fe155faf9602da; 2013-02-19 05:51:28-0800)
Maven home: /Applications/corona-java-1.0.0/apache-maven-3.0.5
Java version: 1.7.0_45, vendor: Oracle Corporation
Java home: /Applications/corona-java-1.0.0/jdk-7u45-macosx-x64/Contents/Home/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "10.9.1", arch: "x86_64", family: "mac"
pom.xml (Project Object Model) is project's configuration file.
mvn validate - Validate the project is correct and all necessary information is available.
mvn compile - Compile source code of the project.
mvn test - Test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed.
mvn package - Package the compiled source code into distributable format(JAR, WAR..).
mvn integration-test - Process and deploy the package if necessary into an environment where integration tests can be run.
mvn install - Install the package to local repo, for use as a dependency in other projects locally.
mvn deploy - Copy the package to remote repo. Done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects.
mvn clean - Clean the project.
mvn verify - Run any checks to verify the package is valid and meets quality criteria
mvn dependency:analyze - Analyze all maven project dependencies and report
[INFO] --- maven-dependency-plugin:2.1:analyze (default-cli) @ CSLFuncTest ---
[WARNING] Used undeclared dependencies found:
[WARNING] org.json:json:jar:20090211:compile
[WARNING] org.apache.velocity:velocity:jar:1.6.3:compile
[WARNING] org.testng:testng:jar:6.8.1:compile
[WARNING] Unused declared dependencies found:
[WARNING] com.paypal.test.bluefin:BluefinMetricsReporter:jar:6.0-SNAPSHOT:compile
[WARNING] com.googlecode.json-simple:json-simple:jar:1.1:compile
[WARNING] org.apache.httpcomponents:httpcore:jar:4.2.2:compile
```
 
+ Resources
```
http://maven.apache.org/plugins/maven-dependency-plugin/index.html
```
 
How to pass command line parameters to TestNG code ?
```
mvn clean test -DsuiteXmlFile=<suite.xml> -Dparameterx=value
final String parameterx_value = System.getProperty("parameterx");
System.out.println("Custom parameter value :: " + parameterx_value);
```
