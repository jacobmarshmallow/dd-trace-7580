 mvn dependency:copy-dependencies -Dmdep.stripVersion

docker build --target with-datadog -t dd-trace-7580:with-dd .
docker build --target without-datadog -t dd-trace-7580:without-dd .
docker build --target without-cds -t dd-trace-7580:without-cds .
