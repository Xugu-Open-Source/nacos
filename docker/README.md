源码打包:
```shell
mvn -Prelease-nacos -Dpmd.skip=true -Dcheckstyle.skip=true -Drat.skip=true -Dmaven.test.skip=true clean install -U
```


打包文件在distribution/target/目录下

docker镜像制作:
使用docker/build/目录下的文件进行制作,需要先将打包后的tar包放置在同级目录，并修改DockerFile中tar包的版本号

```shell
docker build -t nacos .
```

docker运行:
```shell
docker run -d \
--name nacos-xugu-1.4.6 \
-e PREFER_HOST_MODE=hostname \
-e MODE=standalone \
-e SPRING_DATASOURCE_PLATFORM=xugu \
-e XUGU_SERVICE_HOST=127.0.0.1 \
-e XUGU_SERVICE_PORT=5138 \
-e XUGU_SERVICE_USER=SYSDBA \
-e XUGU_SERVICE_PASSWORD=SYSDBA \
-e XUGU_SERVICE_DB_NAME=NACOS \
--network=host \
-p 8848:8848 \
nacos-xugu:1.4.6
```

