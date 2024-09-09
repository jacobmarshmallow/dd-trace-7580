FROM eclipse-temurin:22.0.1_8-jdk-jammy AS builder

COPY --chown=root:root ./target/cds-datadog-repro-0.0.1-SNAPSHOT.jar service.jar

RUN java -Djarmode=tools -jar service.jar extract --destination application

FROM eclipse-temurin:22.0.1_8-jdk-jammy AS runtime
COPY --from=builder application/service.jar ./service.jar
COPY --from=builder application/lib ./lib

RUN mkdir -p log
# Create the shared archive
RUN java -XX:ArchiveClassesAtExit=service.jsa -Dspring.context.exit=onRefresh -Dspring.profiles.active=cds -jar service.jar

FROM runtime AS with-datadog
COPY ./target/dependency/dd-java-agent.jar dd-java-agent.jar
ENTRYPOINT [ \
  "java", \
  "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
  "-XX:SharedArchiveFile=service.jsa", \
  "-javaagent:/dd-java-agent.jar", \
  "-Xshare:on", \
  "-Xlog:class+load:file=log/class-load.log", \
  "-Xlog:class+path=debug:file=log/class-path.log", \
  "-Xlog:class+path=debug", \
  "-Xlog:class+load=info", \
  "-jar", "service.jar" \
]

FROM runtime AS without-datadog
ENTRYPOINT [ \
  "java", \
  "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
  "-XX:SharedArchiveFile=service.jsa", \
  "-Xshare:on", \
  "-Xlog:class+load:file=log/class-load.log", \
  "-Xlog:class+path=debug:file=log/class-path.log", \
  "-Xlog:class+path=debug", \
  "-Xlog:class+load=info", \
  "-jar", "service.jar" \
]

FROM runtime AS without-cds
ENTRYPOINT [ \
  "java", \
  "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
  "-Xshare:on", \
  "-Xlog:class+load:file=log/class-load.log", \
  "-Xlog:class+path=debug:file=log/class-path.log", \
  "-Xlog:class+path=debug", \
  "-Xlog:class+load=info", \
  "-jar", "service.jar" \
]