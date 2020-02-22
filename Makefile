deploy:
	(rsync -vrz ./public chzlab:~/home)
build:
	(hexo g)

run:
	(hexo s)
