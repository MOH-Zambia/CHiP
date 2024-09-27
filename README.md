# CHiP Project


## Prerequisites

Make sure you have the following tools installed on your machine before starting:

- [Git](https://git-scm.com/)
- [PostgreSQL 16](https://www.postgresql.org/download/)
- A PostgreSQL client such as:
  - [pgAdmin](https://www.pgadmin.org/download/) or
  - [DBeaver](https://dbeaver.io/download/)
- [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/) (IDE)

## Steps to Set Up the Project

### 1. Download and Install PostgreSQL 16

PostgreSQL 16 is the database required for this project. Follow the steps below to install it:

1. Download PostgreSQL 16 from the [official website](https://www.postgresql.org/download/).
2. Follow the installation steps for your operating system.
3. During the setup process, you will need to:
   - Set a password for the PostgreSQL `superuser` (commonly `postgres`).
   - Install the `pgAdmin` tool, which comes bundled with PostgreSQL (optional if you plan to use a different client).

After installation, make sure PostgreSQL is running.

### 2. Restore the Database for Testing

For testing purposes, a pre-configured database backup is available for download.

#### Steps to Restore the Database

1. Download the database backup from the following link:
   - [Database Backup](https://drive.google.com/file/d/1aaVbvjeHC-SYjsRmGdYQlUFWPbgP4ZWy/view)

2. Once downloaded, you can restore the database using either pgAdmin or DBeaver.

#### Using pg Admin

1. Open pgAdmin and connect to your PostgreSQL instance.
2. Right-click on `Databases` and choose `Create` > `Database...` to create a new database (e.g., `chip`).
3. Right-click on the newly created database, select `Restore...`, and in the "Filename" field, browse to the location of the downloaded `.backup` file.
4. Click `Restore` to complete the process.

### 3. Open imtecho-web in intellij IDE
1. Navigate to the imtecho-web folder inside the cloned repository and open it with IntelliJ IDEA.
2. Once IntelliJ resolves and downloads the dependencies, configure the pom.xml to use the development (dev) profile for testing.

### 4. Modify the pom.xml for the Development Profile
In the pom.xml, locate the dev profile and update the following placeholders with your specific details:

```xml
<profile>
    <id>dev</id>
    <properties>
        <server.port>8080</server.port>
        <server.redirect.port>8181</server.redirect.port>
        <server.is.secure>true</server.is.secure>
        <server.droptype>P</server.droptype>
        <server.type>DEV</server.type>
        <server.implementation.type>chip</server.implementation.type>

        <jdbc.url>localhost</jdbc.url>
        <jdbc.database>[database_name]</jdbc.database>
        <jdbc.username>[postgres_username]</jdbc.username>
        <jdbc.password>[postgres_password]</jdbc.password>
        <jdbc.port>5432</jdbc.port>
        <jdbc.maxActiveConnection>50</jdbc.maxActiveConnection>
        <jdbc.maxPoolSize>100</jdbc.maxPoolSize>

        <hibernate.showsql>true</hibernate.showsql>
        <hibernate.formatsql>true</hibernate.formatsql>
        <spring.resourceslocation>file:../</spring.resourceslocation>

        <repository.path>[path_to_repository_folder]/</repository.path>
        <firebasejson.path>[path_to_firebase_folder]/</firebasejson.path>

        <email.server>smtp.gmail.com</email.server>
        <email.port>465</email.port>
        <email.userName>no-reply@infodocrx.com</email.userName>
        <email.password>testing123_delete</email.password>
        <email.from>no-reply@infodocrx.com</email.from>
        <email.replyTo>[your_email]</email.replyTo>
        <email.isSecure>true</email.isSecure>

        <ssl.keystore.enable>false</ssl.keystore.enable>
        <ssl.keystore.file>classpath:ssl-certs/imtstaging.jks</ssl.keystore.file>
        <ssl.keystore.password>q1w2e3R$</ssl.keystore.password>

        <allow.origin>*</allow.origin>
        <skipTests>true</skipTests>

        <rch.data.push.cron.job>false</rch.data.push.cron.job>

        <ibm.access.key>WXI-fgndQ07mYNqMEHcTC5CnqZvqfxy2IjgD-4fgY9z5</ibm.access.key>
    </properties>
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
</profile>


Replace the following fields:

[database_name]: The name of the PostgreSQL database you created.
[postgres_username]: Your PostgreSQL username (commonly postgres).
[postgres_password]: Your PostgreSQL password.
[path_to_repository_folder]: The path where your repository is located.
[path_to_firebase_folder]: The path to your Firebase folder.
[your_email]: Your email address for replies.

```

### 6. Running the Project
Once everything is set up:

Ensure PostgreSQL is running.
In IntelliJ, run the project with the dev profile to verify the setup.
Use the URL http://localhost:8181 to access the application.

Ensure that the correct PostgreSQL port (default: 5432) is open.
Modify any additional settings as required for your development environment.

### 7. Open the Android Project
1. Navigate to the imtecho-android folder and open it in Android Studio:

Launch Android Studio.
Select Open from the welcome screen.
Browse to the location of the imtecho-android folder and select it.
Click OK to load the project.

2. Resolve Dependencies
Once the project is open, Android Studio will automatically resolve and download the necessary dependencies.

3. Change the Build Configuration
Open the build.gradle file (Module: app) in the imtecho-android project and add the following configuration under the buildTypes section:
```xml
debug {
    shrinkResources false
    minifyEnabled false
    buildConfigField "String", 'BASE_URL', "\"http://[your_network_ip]:8181/\""
    buildConfigField "String", 'BASE_URL_TRAINING', "\"http://[your_network_ip]:8181/\""
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
}
```

4. Run the Project
After resolving the dependencies, you can run the project using the Run button in Android Studio. Make sure your Android device or emulator is connected and set up properly.




