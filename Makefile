#!make
include .env

migup: 
	@migrate -database "$(DB_CONN)" -path migrations up 1
migdown: 
	@migrate -database "$(DB_CONN)" -path migrations down 1
migfix: 
	@migrate -database "$(DB_CONN)" -path migrations force $(word 2, $(MAKECMDGOALS))
migadd: 
	@migrate create -ext sql -dir migrations -seq $(word 2, $(MAKECMDGOALS))
migver: 
	@migrate -database "$(DB_CONN)" -path migrations version

enum:
	@php ./md/enums.php $(word 2, $(MAKECMDGOALS)) $(CURDIR) $(CLIENT_DIR)
model:
	@php ./md/models.php $(word 2, $(MAKECMDGOALS)) $(CURDIR) $(CLIENT_DIR)
controller:
	@php ./md/controllers.php $(word 2, $(MAKECMDGOALS)) $(CURDIR) $(CLIENT_DIR)
%:
	@:
