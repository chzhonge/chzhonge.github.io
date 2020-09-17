deploy: build robots
	(rsync -vrz ./public chzlab:~/home)
build:
	(npm run clean)
	(npm run build)
robots:
	(cd public && echo '# chzlab.net\nUser-agent: *' > robots.txt)
run:
	(npm run server)
