if ! [ -d "target/dependency" ]; then mkdir "target\dependency"; fi
cd "target\dependency" || exit

if [ -f "../spring-boot-hot-reload-0.0.1-SNAPSHOT.jar" ]; then
  jar -xf ../spring-boot-hot-reload-0.0.1-SNAPSHOT.jar
  cd ../.. || exit
  docker build -t spring-boot-hot-reload .
  docker stop spring-boot-hot-reload
  docker run --publish=8080:8080 --rm=true --name=spring-boot-hot-reload spring-boot-hot-reload
  read -s -r -n 1 -p "Press any key to continue . . ."
  docker stop spring-boot-hot-reload
fi
