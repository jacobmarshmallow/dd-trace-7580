 mvn dependency:copy-dependencies -Dmdep.stripVersion

docker build --target with-datadog -t repro:with-dd .
docker build --target without-datadog -t repro:without-dd .
