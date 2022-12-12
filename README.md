# Newman-extention-
input parameters:
1. Collection file (-c)
2. Environment file (-e)
3. parallel exec (cosmos, cosmostest are folders passed as ARGUMENTS)
4. tagging (Tag is argument)
-> collection and environment file will be configured in pipeline from specific repo not hardcoded.

./parallel_exec.sh -c 'Cosmos.postman_collection.json' -e 'cosmos.postman_environment.json' "Cosmos cosmostest"
./tagging.sh -c 'Cosmos.postman_collection.json' -e 'cosmos.postman_environment.json’ Tag
