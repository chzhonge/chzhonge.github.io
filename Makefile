deploy: build robots
	(rsync -vrz ./public chzlab:~/home)
build:
	(hexo clean)
	(hexo g)
robots:
	(cd public && echo '# chzlab.net\nUser-agent: *' > robots.txt)
run:
	(hexo s)
