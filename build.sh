# START SECTION
start () {
  NAME=spring-boot-hot-reload

  if [ "$1$2" == "" ]; then jarDev; fi

  if [ "$1$2" == "dev" ]; then jarDev; fi
  if [ "$1$2" == "prod" ]; then jarProd; fi

  if [ "$1$2" == "jar" ]; then jarDev; fi
  if [ "$1$2" == "docker" ]; then dockerDev; fi

  if [ "$1 $2" == "jar dev" ]; then jarDev; fi
  if [ "$1 $2" == "docker dev" ]; then dockerDev; fi

  if [ "$1 $2" == "jar prod" ]; then jarProd; fi
  if [ "$1 $2" == "docker prod" ]; then dockerProd; fi

  if [ "$1 $2" == "--help " ]; then usage;
  else
    notACommand "$@";
  fi
  exit
}


# SCRIPT CONFIGURATION SECTION
jarDev () {
  ENV="JAR"
  MODE="DEV"
  build
}

jarProd () {
  ENV="JAR"
  MODE="PROD"
  build
}

dockerDev () {
  ENV="DOCKER"
  MODE="DEV"
  build
}

dockerProd () {
  ENV="DOCKER"
  MODE="PROD"
  build
}


# BUILD SECTION
build () {
  echo "Env: $ENV Mode: $MODE";
  if [ $MODE == "DEV" ]; then ./mvnw -Dexclude.devtools=false clean package; fi
  if [ $MODE == "PROD" ]; then ./mvnw clean package; fi

  if [ $ENV == "JAR" ]; then startJar;
  else
    buildDocker
  fi
}

buildDocker () {
if ! [ -d "target/dependency" ]; then mkdir -p "target/dependency"; fi
cd "target/dependency" || exit

if [ -f "../$NAME-0.0.1-SNAPSHOT.jar" ]; then
  jar -xf ../"$NAME"-0.0.1-SNAPSHOT.jar
  cd ../.. || exit
  docker build -t "$NAME" .
  startDocker
fi
}


# START SECTION
startJar () {
  if [ $MODE == "DEV" ]; then java -Dspring.profiles.active=dev -jar target/"$NAME"-0.0.1-SNAPSHOT.jar; fi
  if [ $MODE == "PROD" ]; then java -jar target/"$NAME"-0.0.1-SNAPSHOT.jar; fi
  read -s -r -n 1 -p "Press any key to continue . . .";
}

startDocker () {
  docker stop -t 10 "$NAME"
  if [ $MODE == "DEV" ]; then docker run --publish=8080:8080 --rm=true --name="$NAME" -e "SPRING_PROFILES_ACTIVE=dev" "$NAME"; fi
  if [ $MODE == "PROD" ]; then docker run --publish=8080:8080 --rm=true --name="$NAME" "$NAME"; fi
  read -s -r -n 1 -p "Press any key to continue . . ."
  docker stop -t 10 "$NAME"
}


# USAGE SECTION
usage () {
  echo
  echo "Usage: $0 [{jar}|docker] [{dev}|prod]"
  echo
  echo "Build the application as jar or docker container and run it in development or production mode."
}

# NOT A COMMAND SECTION
notACommand () {
  NOT_A_COMMAND="$0: '"
  for arg in "$@"; do
    i+=1
    if [ $i == 1 ]; then
      NOT_A_COMMAND+="$arg"
    else
      NOT_A_COMMAND+=" $arg"
    fi
  done
  NOT_A_COMMAND+="' is not a $0 command."
  echo "$NOT_A_COMMAND"
  echo "See '$0 --help'"
}


start "$@"
