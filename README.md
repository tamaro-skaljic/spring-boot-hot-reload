## Application hot reload with IntelliJ IDEA, Maven Wrapper, [spring-boot-devtools](https://docs.spring.io/spring-boot/docs/2.4.3/reference/html/using-spring-boot.html#using-boot-devtools), the LiveReload browser plugin and Docker on both Windows and Linux.

### GIVEN
You've installed the [LiveReload-Plugin](http://livereload.com/extensions/) in your browser,
an IDE like IntelliJ IDEA and Docker if you want to use hot reload in remote applications.

### WHEN
You set the `spring.devtools.remote.secret` property in the [application.properties](src/main/resources/application.properties).
> Like any important password or secret, the value should be unique and strong such that it cannot be guessed or brute-forced.

<hr/>

You have three options to run your application: Through your IDE, as a JAR or as a Docker container. When you want to
run the application outside your IDE (as a JAR or Docker container), you need the following configuration in your IDE:

Select `Run → Edit Configurations...` in IntelliJ IDEA and add a new configuration with type Application:

Name: `RemoteSpringApplication`<br/>
Main class: `org.springframework.boot.devtools.RemoteSpringApplication`<br/>
Program arguments: `http://localhost:8080` (or whatever your remote URL is)

Press OK

##### Option 1: Run the application through your IDE
You run [Application.java](src/main/java/de/tamaroskaljic/spring_boot_hot_reload/Application.java) from your IDE.

##### Option 2: Run the application as a JAR
You execute [maven-build.sh](maven-build.sh) or [maven-build.cmd](maven-build.cmd) regarding of your operating system.

You press `Run → RemoteSpringApplication` / `SHIFT + F10` in IntelliJ to run the configuration.

##### Option 2: Run the application in a Docker container
You execute [docker-build.sh](docker-build.sh) or [docker-build.cmd](docker-build.cmd) regarding of your operating system.

You press `Run → RemoteSpringApplication` / `SHIFT + F10` in IntelliJ to run the configuration.

###### SECURITY WARNING:
> Remote support is opt-in as enabling it can be a security risk.
It should only be enabled when running on a trusted network or when secured with SSL.
If neither of these options is available to you, you should not use DevTools' remote support.
You should never enable support on a production deployment.
> 
To see what difference there is between local and production environment, it is enough
to look on line 3 in [maven-build.cmd](maven-build.cmd) and [maven-build-prod.cmd](maven-build-prod.cmd) or line
1 in [maven-build.sh](maven-build.sh) and [maven-build-prod.sh](maven-build-prod.sh). It's an override of the maven
property `exclude.devtools` specified and used in the [pom.xml](pom.xml).

<hr/>

You visit http://localhost:8080/hello.

You click on the plugin icon in your browser to enable LiveReload.

You change something in the [HelloController](src/main/java/de/tamaroskaljic/spring_boot_hot_reload/HelloController.java)
or do anything else in [src/main/java](src/main/java).

<hr/>

You have three options to trigger an application restart and browser refresh:

##### Option 1: Activate 'Build project automatically' in IntelliJ IDEA

You press `Help → Find Action...` / `CTRL + SHIFT + A` in IntelliJ IDEA, search for `Build project automatically` and enable `Build project automatically`.

You press `Help → Find Action...` / `CTRL + SHIFT + A` in IntelliJ, search for `Registry...` and enable `compiler.automake.allow.when.app.running`.

You press `Silfe → Safe All` / `STRG + S` in IntelliJ to save all, IntelliJ should automatically build changed files.

###### Hint: You can change the `spring.devtools.restart.poll-interval` and `spring.devtools.restart.quiet-period` propertie in [application.properties](src/main/resources/application.properties) to change the behaviour on slow machines.

##### Option 2: Build the project in IntelliJ IDEA manually

You press `Build → Build Project` / `STRG + F9` in IntelliJ IDEA.

##### Option 3: Recompile a specific class in IntelliJ IDEA manually

You press `Build → Recompile '*.java' ` / `STRG + SHIFT + F9` in IntelliJ IDEA.

<hr/>

### THEN

The application should restart automatically.

Your browser should automatically refresh the site
