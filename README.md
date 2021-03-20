# Application hot reload with [spring-boot-devtools](https://docs.spring.io/spring-boot/docs/2.4.3/reference/html/using-spring-boot.html#using-boot-devtools) and the [LiveReload](http://livereload.com/extensions/) browser plugin

### GIVEN
You've installed the [LiveReload-Plugin](http://livereload.com/extensions/) in your browser, and an IDE like IntelliJ IDEA.

### WHEN
You set the `spring.devtools.remote.secret` property in the [application.properties](src/main/resources/application.properties) file,

> Like any important password or secret, the value should be unique and strong such that it cannot be guessed or brute-forced.

You run [Application.java](src/main/java/de/tamaroskaljic/spring_boot_hot_reload/Application.java) from your IDE,

You visit http://localhost:8080/hello,

You click on the plugin icon in your browser to enable LiveReload,

You change something in the [HelloController](src/main/java/de/tamaroskaljic/spring_boot_hot_reload/HelloController.java)
or do anything else in [src/main/java](src/main/java),

You press `Build → Build Project` / `STRG + F9` in IntelliJ IDEA,

### THEN

The application should restart automatically.

Your browser should automatically refresh the site

---

You can also run your application as a JAR or as a Docker container.

###### SECURITY WARNING:
> Remote support is opt-in as enabling it can be a security risk.
It should only be enabled when running on a trusted network or when secured with SSL.
If neither of these options is available to you, you should not use DevTools' remote support.
You should never enable support on a production deployment.

### GIVEN

You have selected `Run → Edit Configurations...` in IntelliJ IDEA and added a new configuration with type Application:

Name: `RemoteSpringApplication`<br/>
Main class: `org.springframework.boot.devtools.RemoteSpringApplication`<br/>
Program arguments: `http://localhost:8080` (or whatever your remote URL is)

### WHEN

You use [build.sh](build.sh) or [build.cmd](build.cmd) regarding of
your operating system to build and run the application outside your IDE,

```
Usage: build [{jar}|docker] [{dev}|prod]

Build the application as jar or docker container and run it in development or production mode.
```

You press `Run → RemoteSpringApplication` / `SHIFT + F10` in IntelliJ to run the configuration.

You visit http://localhost:8080/hello again,

You do anything in [src/main/java](src/main/java),

You press `Build → Build Project` / `STRG + F9` in IntelliJ IDEA,

### THEN

You'll see something like this in the RemoteSpringApplication execution log:

```
[...] ClassPathChangeUploader  : Uploaded 1 class resource
[...] DelayedLiveReloadTrigger : Remote server has changed, triggering LiveReload
```

The application should restart automatically, and your browser should automatically refresh the site.

###### Hint:
> DevTools are disabled in "production" mode. To see how this happens, explore the
build block in [build.sh](build.sh) / [build.cmd](build.cmd). It's an override
of the maven property `exclude.devtools` specified and used in the [pom.xml](pom.xml).

---

To trigger an application restart and browser refresh you have two other options instead
of press `Build → Build Project` / `STRG + F9` in IntelliJ IDEA.

- You can recompile only a specific class in IntelliJ IDEA: To do this, press
`Build → Recompile '*.java' ` / `STRG + SHIFT + F9`.

Also, you can activate 'Build project automatically' in IntelliJ IDEA to let the IDE build changed classes automatically:

- Press `Help → Find Action...` / `CTRL + SHIFT + A` in IntelliJ IDEA, search for `Build project automatically` and enable it.

- Press `Help → Find Action...` / `CTRL + SHIFT + A` in IntelliJ, search for `Registry...` and enable `compiler.automake.allow.when.app.running`.

Now when you press `File → Safe All` / `STRG + S` in IntelliJ to save all, IntelliJ should automatically build - only the changed files.

> You can change the `spring.devtools.restart.poll-interval` and `spring.devtools.restart.quiet-period` properties in [application.properties](src/main/resources/application.properties) to change the behaviour on slow machines.
More information about these properties you can find in the [documentation](https://docs.spring.io/spring-boot/docs/2.4.3/reference/html/using-spring-boot.html#using-boot-devtools-remote-update) of Spring Boot.