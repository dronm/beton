migup: 
	migrate -database "$(DB_CONN)" -path migrations up 1
migdown: 
	migrate -database "$(DB_CONN)" -path migrations down 1
migfix: 
	migrate -database "$(DB_CONN)" -path migrations force VERSION
migshow: 
	migrate -database "$(DB_CONN)" -path migrations version
migadd: 
	migrate create -ext sql -dir migrations -seq NEW
