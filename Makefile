deploy: build
	(rsync -vrz ./public chzlab:~/home)
build:
	(hexo clean)
	(hexo g)

run:
	(hexo s)
